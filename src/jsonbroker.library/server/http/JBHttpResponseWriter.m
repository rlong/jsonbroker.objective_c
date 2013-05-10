//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBDataEntity.h"
#import "JBHttpResponse.h"
#import "JBHttpResponseWriter.h"
#import "JBHttpStatus.h"
#import "JBStreamHelper.h"

#import "JBBaseException.h"
#import "JBDataHelper.h"
#import "JBLog.h"
#import "JBOutputStreamHelper.h"
#import "JBInputStreamHelper.h"




@implementation JBHttpResponseWriter





+(void)tryWriteResponse:(JBHttpResponse*)response outputStream:(NSOutputStream*)outputStream {
    
    
    int statusCode = [response status];
    NSString* statusString = [JBHttpStatus getReason:statusCode];
    
    NSMutableString* statusLineAndHeaders = [NSMutableString stringWithFormat:@"HTTP/1.1 %d %@\r\n", statusCode, statusString];
    
    
    NSDictionary* headers = [response headers];
	for( NSString* key in headers ) {
        
		NSString* value = [headers objectForKey:key];
		[statusLineAndHeaders appendFormat:@"%@: %@\r\n", key, value];
	}

    
    id<JBEntity> entity = [response entity];

    
    ////////////////////////////////////////////////////////////////////////
    // no entity 
    
    if( nil == entity ) { 
        
        if( 204 != statusCode ) { 
            Log_warnFormat( @"nil == entity && 204 != statusCode; statusCode = %d", statusCode );
            [statusLineAndHeaders appendString:@"Content-Length: 0\r\n"];
        } else {
            // from ... 
            // http://stackoverflow.com/questions/912863/is-an-http-application-that-sends-a-content-length-or-transfer-encoding-with-a-2
            // ... it would 'appear' safest to not include 'Content-Length' on a 204
        }
        [statusLineAndHeaders appendString:@"Accept-Ranges: bytes\r\n\r\n"];
        
        NSData* data = [JBDataHelper getUtf8Data:statusLineAndHeaders];
        long maxLength = [statusLineAndHeaders lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        [outputStream write:[data bytes] maxLength:maxLength];
        
        return; // our work is done
        
    }
    
    ////////////////////////////////////////////////////////////////////////
    // has entity 

    unsigned long long entityContentLength = [entity getContentLength];
    unsigned long long seekPosition = 0;
    unsigned long long amountToWrite = entityContentLength;
    
    ////////////////////////////////////////////////////////////////////////
    // headers relevant to range support
    JBRange* range = [response range];
    
    if( nil == range ) {
        
        [statusLineAndHeaders appendString:@"Accept-Ranges: bytes\r\n"];
        
        if( HttpStatus_PARTIAL_CONTENT_206 == statusCode ) {
            Log_warn( @"nil == range && HttpStatus_PARTIAL_CONTENT_206 == statusCode" );
        }
    } else {
        
        NSString* contentRangeHeader = [NSString stringWithFormat:@"Content-Range: %@\r\n", [range toContentRange:entityContentLength]];
        [statusLineAndHeaders appendString:contentRangeHeader];
        
        amountToWrite = [range getContentLength:entityContentLength];
        seekPosition = [range getSeekPosition:entityContentLength];
        
        if( HttpStatus_PARTIAL_CONTENT_206 != statusCode ) {
            Log_warn( @"nil != range && HttpStatus_PARTIAL_CONTENT_206 != statusCode" );
        }
    }
    
    // 'Content-Length' final newline
    [statusLineAndHeaders appendFormat:@"Content-Length: %llu\r\n\r\n", amountToWrite];
    
    ////////////////////////////////////////////////////////////////////////
    // write the headers
    
    //Log_debugFormat( @"\n%@", statusLineAndHeaders);

    
    NSData* headersUtf8Data = [JBDataHelper getUtf8Data:statusLineAndHeaders];
    long maxLength = [statusLineAndHeaders lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

    
    [outputStream write:[headersUtf8Data bytes] maxLength:maxLength];


    ////////////////////////////////////////////////////////////////////////
    // write the entity

    
    [entity writeTo:outputStream offset:seekPosition length:amountToWrite];


}


+(void)writeResponse:(JBHttpResponse*)response outputStream:(NSOutputStream*)outputStream {

    
    @try {
        
        [self tryWriteResponse:response outputStream:outputStream ];
        
    }
    @finally {
        
        
        id<JBEntity> entity = [response entity];
        if( nil != entity ) {
            [entity teardownForCaller:self swallowErrors:false];

        }
    }
}

@end

//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBAuthRequestHandler.h"
#import "JBHttpDelegate.h"
#import "JBFileRequestHandler.h"
#import "JBHttpErrorHelper.h"
#import "JBHttpResponseWriter.h"

#import "JBBaseException.h"
#import "JBFileHandle.h"
#import "JBHttpRequest.h"
#import "JBRequestHandler.h"
#import "JBHttpRequestReader.h"
#import "JBHttpStatus.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBObjectTracker.h"
#import "JBOpenRequestHandler.h"
#import "JBOutputStreamHelper.h"
#import "JBInputStreamHelper.h"
#import "JBStreamHelper.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBHttpDelegate () 



// httpProcessor
//id<HttpProcessor> _httpProcessor;
@property (nonatomic, retain) id<JBRequestHandler> httpProcessor;
//@synthesize httpProcessor = _httpProcessor;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



@implementation JBHttpDelegate



-(JBHttpRequest*)readRequest:(NSInputStream*)inputStream {

    JBHttpRequest* answer = nil;
    
    @try {
        
        answer = [JBHttpRequestReader readRequest:inputStream];
        
    }
    @catch (NSException *exception) {
        Log_warnException( exception );
    }
    
    return answer;

    
}


-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    
    @try {
        return [_httpProcessor processRequest:request];
    }
    @catch (NSException *exception) {
        
        if( [exception isKindOfClass:[JBBaseException class]] ) {
            JBBaseException* be = (JBBaseException*)exception;
            NSString* errorDomain = [be errorDomain];
            
            if(  [[[JBHttpStatus errorDomain] NOT_FOUND_404] isEqualToString:errorDomain] ) {
                Log_warnFormat( @"errorDomain = '%@'; [be reason] = '%@'", errorDomain, [be reason]);
            } else {
                Log_warnException( exception );
            }
        } else {
            Log_warnException( exception );
        }
        
        return [JBHttpErrorHelper toHttpResponse:exception];
    }
    
}


-(bool)writeResponse:(JBHttpResponse*)response to:(NSOutputStream*)outputStream {
    
    @try {
        // write the response ...
        [JBHttpResponseWriter writeResponse:response outputStream:outputStream];
    }
    @catch (BaseException* exception) {
        
        if( [[JBStreamHelper ERROR_DOMAIN_BROKEN_PIPE] isEqualToString:[exception errorDomain]] ) {
#ifdef DEBUG
            Log_warn( @"broken pipe" );
#else
            // quietly swallow the 'broken pipe'
#endif
        } else {
            Log_warnException( exception );
        }
        return false;
    }
    @catch (NSException *exception) {
        Log_warnException( exception );
        return false;
    }
    
    return true;
    
    
    
}


-(void)logReqest:(JBHttpRequest*)request response:(JBHttpResponse*)response writeResponseSucceded:(bool)writeResponseSucceded{

    int statusCode = [response status];

    NSString* requestUri = [request requestUri];
    
    JBRange* range = [response range];
    
    long long contentLength = 0;
    if( nil != [response entity] ) {
        
        contentLength = [[response entity] getContentLength];
        if( nil != range ) {
            contentLength = [range getContentLength:contentLength];
        }
    }
    
    float timeTaken = -[[request created] timeIntervalSinceNow];
    
    NSString* completed;
    {
        if( writeResponseSucceded ) {
            completed = @"true";
        } else {
            completed = @"false";
        }
    }
    
    NSString* rangeString;
    {
        if( nil == range ) {
            rangeString = @"bytes";
            
        } else {
            rangeString = [range toContentRange:[[response entity] getContentLength]];
        }
    }
    
    NSString* info = [NSString stringWithFormat:@"status:%d uri:%@ content-length:%lld time-taken:%f completed:%@ range:%@", statusCode, requestUri, contentLength, timeTaken, completed, rangeString];
    Log_info( info );

}


#pragma mark - 
#pragma mark <ConnectionDelegate> implementation


-(id<JBConnectionDelegate>)processRequestOnSocket:(JBFileHandle*)socket inputStream:(NSInputStream*)inputStream  outputStream:(NSOutputStream*)outputStream {

    
    // get the request ...
    JBHttpRequest* request = [self readRequest:inputStream];
    
    if( nil == request )  {
        Log_debug(@"nil == request");
        return nil;
    }
    
    // process the request ...
    JBHttpResponse* response = [self processRequest:request];


    id<JBConnectionDelegate> answer = self;
    
    if( nil != [response connectionDelegate] ) {
        answer = [response connectionDelegate];
    }
    
    // vvv http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10
    if( [request isCloseConnectionIndicated] ) {
        answer = nil;
    }
    // ^^^ http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10
    
    uint32_t statusCode = [response status];
    if( statusCode > 399 ) {
        answer = nil;
    }
    
    if( self == answer ) {
        [response putHeader:@"Connection" value:@"keep-alive"];
    } else if( nil == answer ){
        [response putHeader:@"Connection" value:@"close"];
    }

    // write the response ...
    bool writeResponseSucceded = [self writeResponse:response to:outputStream];

    // do some logging ...
    [self logReqest:request response:response writeResponseSucceded:writeResponseSucceded];

    
    if( !writeResponseSucceded ) {
        answer = nil;
    }
    
    // if the processing completed, we will permit more requests on this socket
    return answer;

}



#pragma mark -
#pragma mark instance setup/teardown


-(id)initWithRequestHandler:(id<JBRequestHandler>)httpProcessor {
    
    JBHttpDelegate* answer = [super init];
    
    if( nil != answer ) { 
        
        [JBObjectTracker allocated:answer];
        
        [answer setHttpProcessor:httpProcessor];
    }

    
    return answer;
    
}

-(void)dealloc{ 
	
	[JBObjectTracker deallocated:self];
	
    [self setHttpProcessor:nil];

    JBSuperDealloc();
}

#pragma mark fields




// httpProcessor
//id<HttpProcessor> _httpProcessor;
//@property (nonatomic, retain) id<HttpProcessor> httpProcessor;
@synthesize httpProcessor = _httpProcessor;



@end

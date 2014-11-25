//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBDataEntity.h"
#import "JBFileRequestHandler.h"
#import "JBHttpErrorHelper.h"
#import "JBHttpRequest.h"
#import "JBHttpResponse.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBMimeTypes.h"
#import "JBRequestHandlerHelper.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBFileRequestHandler ()

// rootFolder
//NSString* _rootFolder;
@property (nonatomic, retain) NSString* rootFolder;
//@synthesize rootFolder = _rootFolder;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation JBFileRequestHandler





-(id<JBEntity>)readFile:(NSString*)absolutePath {
    
    
    NSData* fileData = [NSData dataWithContentsOfFile:absolutePath];
    JBDataEntity* answer = [[JBDataEntity alloc] initWithData:fileData];
    [answer autorelease];
    return answer;

}

-(NSString*)toAbsolutePath:(NSString*)relativePath {
    
    
    NSString* answer = [_rootFolder stringByAppendingString:relativePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if( ![fileManager fileExistsAtPath:answer] ) {
        Log_errorFormat( @"![fileManager fileExistsAtPath:answer]; answer = '%@'", answer);
        @throw [JBHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
    }
    
    if( ![fileManager isReadableFileAtPath:answer] ) {
        Log_errorFormat( @"![fileManager isReadableFileAtPath:answer]; answer = '%@'", answer);
        @throw [JBHttpErrorHelper forbidden403FromOriginator:self line:__LINE__];
        
    }
    
    return answer;
}


// could return `nil`
-(NSString*)getETag:(NSString*)absolutePath {

    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError* error = nil;
    NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:absolutePath error:&error];
    
    if( nil != error ) {
        Log_errorError( error );
        return nil;
    }
    
    NSDate* fileModificationDate = [fileAttributes fileModificationDate];
    
    NSTimeInterval modificationInterval = [fileModificationDate timeIntervalSince1970];
    uint64_t modificationTime = (uint64_t)modificationInterval;
    NSString* answer = [NSString stringWithFormat:@"\"%lld\"", modificationTime];
    Log_debugString( answer );
    return answer;

}


-(NSString*)getProcessorUri {
    return @"/";
}


-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
	
    
	NSString* requestUri = [request requestUri];

    if( [requestUri hasSuffix:@"/"] ) { 
        requestUri = [NSString stringWithFormat:@"%@index.html", requestUri];
    }
    
    { // some validation
        
		[JBRequestHandlerHelper validateRequestUri:requestUri];
		[JBRequestHandlerHelper validateMimeTypeForRequestUri:requestUri];
    }
    
    NSString* absolutePath = [self toAbsolutePath:requestUri];
    
    NSString* eTag = [self getETag:absolutePath];
    
    
    JBHttpResponse* answer;
    
    NSString* ifNoneMatch = [request getHttpHeader:@"if-none-match"];
    if( nil != ifNoneMatch && [ifNoneMatch isEqualToString:eTag] ) {
        answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_NOT_MODIFIED_304];
        JBAutorelease( answer );
    } else {
        
        id<JBEntity> body = [self readFile:absolutePath];
        
        answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:body];
        JBAutorelease( answer );
        
        NSString* contentType = [JBMimeTypes getMimeTypeForPath:requestUri];
        [answer setContentType:contentType];
        
    }
    
    [answer putHeader:@"ETag" value:eTag];
    
    return answer;
	
}

#pragma mark instance lifecycle

-(id)initWithRootFolder:(NSString*)rootFolder { 
    
    JBFileRequestHandler* answer = [super init];
    
    [answer setRootFolder:rootFolder];
    
    return answer;
    
    
}

-(void)dealloc { 
    
    [self setRootFolder:nil];
    
    [super dealloc];

}

#pragma mark fields


// rootFolder
//NSString* _rootFolder;
//@property (nonatomic, retain) NSString* rootFolder;
@synthesize rootFolder = _rootFolder;


@end

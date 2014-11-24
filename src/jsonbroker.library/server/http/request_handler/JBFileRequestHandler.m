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





-(id<JBEntity>)readFile:(NSString*)relativePath {
    
    
    NSString* absoluteFilename = [_rootFolder stringByAppendingString:relativePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    
    if( ![fileManager fileExistsAtPath:absoluteFilename] ) { 
        Log_errorFormat( @"![fileManager fileExistsAtPath:absoluteFilename]; absoluteFilename = '%@'", absoluteFilename);
        @throw [JBHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
    }
    
    if( ![fileManager isReadableFileAtPath:absoluteFilename] ) { 
        Log_errorFormat( @"![fileManager isReadableFileAtPath:absoluteFilename]; absoluteFilename = '%@'", absoluteFilename);
        @throw [JBHttpErrorHelper forbidden403FromOriginator:self line:__LINE__];
        
    }
    

    NSData* fileData = [NSData dataWithContentsOfFile:absoluteFilename];
    JBDataEntity* answer = [[JBDataEntity alloc] initWithData:fileData];
    [answer autorelease];
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
    
    @try {
        
        id<JBEntity> body = [self readFile:requestUri];
        
        JBHttpResponse* answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:body];
        [answer autorelease];
        
        NSString* contentType = [JBMimeTypes getMimeTypeForPath:requestUri];
        [answer setContentType:contentType];
        
        return answer;
    }
    @catch (BaseException *exception) {
        @throw exception;
    }
    @catch (NSException *exception) {
        Log_errorException( exception );
        @throw [JBHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
    }
	
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

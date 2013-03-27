// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBHttpDispatcher.h"
#import "JBHttpRunLoop.h"

#import "JBBaseException.h"
#import "JBDataEntity.h"
#import "JBHttpStatus.h"
#import "JBInputStreamHelper.h"
#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBStreamEntity.h"
#import "JBStreamHelper.h"
#import "JBEntity.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBHttpDispatcher ()
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBHttpDispatcher





+(NSDictionary*)getHeaders:(NSURLResponse *)response {
 
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary* allHeaderFields = [httpResponse allHeaderFields];
    
    NSMutableDictionary* answer = [[NSMutableDictionary alloc] initWithCapacity:[allHeaderFields count]];
    [answer autorelease];
    
    for( NSString* key in allHeaderFields ) {
        
        NSString* value = [allHeaderFields objectForKey:key];
        
        [answer setObject:value forKey:[key lowercaseString]];
    }
    
    return answer;

}





// authenticator can be null 
-(int)dispatch:(NSMutableURLRequest*)request authenticator:(JBAuthenticator*)authenticator responseHandler:(id<JBHttpResponseHandler>)responseHandler {
    
    
    NSURLResponse* urlResponse = nil;
	NSError* error = nil;

    JBHttpRunLoop* httpRunLoop = [JBHttpRunLoop getInstance];
	NSData* data = [httpRunLoop sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    
	if( nil != error ) { 
        
        Log_errorInt( [error code] );
        Log_errorString( [error localizedDescription] );
        {
            NSDictionary* userInfo = [error userInfo];
            for( NSString* key in userInfo ) { 
                Log_debugString( key );
                NSObject* value = [userInfo objectForKey:key];
                Log_debugString( NSStringFromClass([value class]));
                if( [value isKindOfClass:[NSString class]] ) {
                    Log_debugString( (NSString*)value );
                }
            }
        }
        
		NSString* technicalError = [error localizedDescription];
		
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e setFaultCode:(int)[error code]];
		[e setError:error];
		[e autorelease];
		
		@throw e;
		
	}
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)urlResponse;


    @try {

        NSDictionary* responsehHeaders = [JBHttpDispatcher getHeaders:httpResponse];
        if( nil != authenticator ) { 
            [authenticator handleHttpResponseHeaders:responsehHeaders];
        }
        
        int statusCode = (int)[httpResponse statusCode];
        if( 200 <= statusCode && 300 > statusCode ) {
            
            // all is well
            if( nil == data ) { // e.g. http 204 
                [responseHandler handleResponseHeaders:responsehHeaders responseEntity:nil];
            } else {
                JBDataEntity* dataEntity = [[JBDataEntity alloc] initWithData:data];
                [dataEntity autorelease];
                [responseHandler handleResponseHeaders:responsehHeaders responseEntity:dataEntity];                
            }
        }
        return statusCode;
    }
    @finally {
        // close a stream in java & C# ... no equivalent in objective-c 
    }

}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


// authenticator can be null 
-(NSMutableURLRequest*)buildGetRequest:(JBHttpRequestAdapter*)requestAdapter authenticator:(JBAuthenticator*)authenticator { 
    
    NSString* requestUri = [requestAdapter requestUri];
    
    NSString* urlString = [NSString stringWithFormat:@"http://%@%@", [_networkAddress toString], requestUri];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* answer = [NSMutableURLRequest requestWithURL:url];
    
    [answer setHTTPMethod:@"GET"]; // just to be explicit
    
    // extra headers ... 
    {
    
        NSDictionary* requestHeaders = [requestAdapter requestHeaders];
        for( NSString* name in requestHeaders ) { 
            NSString* value = [requestHeaders objectForKey:name];
            [answer addValue:value forHTTPHeaderField:name];
        }        
    }
    
    if( nil != authenticator ) { 

        NSString* authorization = [authenticator getRequestAuthorizationForMethod:[answer HTTPMethod] requestUri:requestUri entity:nil];
        Log_debugString( authorization);
        if( nil != authorization ) { 
            [answer addValue:authorization forHTTPHeaderField:@"Authorization"];
        }
    }
    
    return answer;
    
}





////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


-(void)get:(JBHttpRequestAdapter*)requestAdapter authenticator:(JBAuthenticator*)authenticator responseHandler:(id<JBHttpResponseHandler>)responseHandler {
    
    
    NSMutableURLRequest* request = [self buildGetRequest:requestAdapter authenticator:authenticator];
    
    int statusCode = [self dispatch:request authenticator:authenticator responseHandler:responseHandler];
    
    if( 401 == statusCode ) {
        request = [self buildGetRequest:requestAdapter authenticator:authenticator];
        statusCode = [self dispatch:request authenticator:authenticator responseHandler:responseHandler];
    }
    
    if( statusCode < 200 || statusCode > 299 ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:[JBHttpStatus getReason:statusCode]];
        [e autorelease];
        [e setFaultCode:statusCode];
        NSString* requestUri = [requestAdapter requestUri];
        [e addStringContext:requestUri withName:@"requestUri"];
        @throw  e;
    }
}


-(void)get:(JBHttpRequestAdapter*)requestAdapter responseHandler:(id<JBHttpResponseHandler>)responseHandler {
    
    
    NSMutableURLRequest* request = [self buildGetRequest:requestAdapter authenticator:nil];
    
    int statusCode = [self dispatch:request authenticator:nil responseHandler:responseHandler];
    
    
    if( statusCode < 200 || statusCode > 299 ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:[JBHttpStatus getReason:statusCode]];
        [e autorelease];
        [e setFaultCode:statusCode];
        NSString* requestUri = [requestAdapter requestUri];
        [e addStringContext:requestUri withName:@"requestUri"];
        @throw  e;
    }
    
    
}


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////



// authenticator can be null 
-(NSMutableURLRequest*)buildPostRequest:(JBHttpRequestAdapter*)requestAdapter authenticator:(JBAuthenticator*)authenticator { 
    
    NSString* requestUri = [requestAdapter requestUri];
    id<JBEntity> entity = [requestAdapter requestEntity];
    
    NSString* urlString = [NSString stringWithFormat:@"http://%@%@", [_networkAddress toString], requestUri];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* answer = [NSMutableURLRequest requestWithURL:url];
    [answer setHTTPMethod:@"POST"]; // just to be explicit
    
    
    // extra headers ... 
    {
        
        NSDictionary* requestHeaders = [requestAdapter requestHeaders];
        for( NSString* name in requestHeaders ) { 
            NSString* value = [requestHeaders objectForKey:name];
            [answer addValue:value forHTTPHeaderField:name];
        }        
    }
    
    // auth headers ... 
    if( nil != authenticator ) { 
        NSString* authorization = [authenticator getRequestAuthorizationForMethod:[answer HTTPMethod] requestUri:requestUri entity:entity];

        if( nil != authorization ) {
            [answer addValue:authorization forHTTPHeaderField:@"Authorization"];
        } else {
            // no-op
        }
    }
    
    // body ... 
    if( [entity isKindOfClass:[JBDataEntity class]] ) { 
        
        JBDataEntity* dataEntity = (JBDataEntity*)entity;
        [answer setHTTPBody:[dataEntity data]];
    } else { 

        if( NO ) {
            
            /* from the docs on [NSMutableURLRequest setHTTPBodyStream:] ... 
             
             Parameters
             inputStream
             The input stream that will be the request body of the receiver. The entire contents of the stream will be sent as the body, as in an HTTP POST request. The inputStream should be unopened and the receiver will take over as the stream’s delegate.
             */
            [answer setHTTPBodyStream:[entity getContent]];
            
        } else {
            
            NSInputStream* inputStream = [entity getContent];
            int contentLength = (int)[entity getContentLength];
            
            NSData* httpBody = [JBInputStreamHelper readDataFromStream:inputStream count:contentLength];
            [answer setHTTPBody:httpBody];
        }
    }
    
    NSString* contentLength = [NSString stringWithFormat:@"%lld", [entity getContentLength]];
    [answer setValue:contentLength forHTTPHeaderField:@"Content-Length"];

    return answer;
    
}


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


-(void)post:(JBHttpRequestAdapter*)requestAdapter authenticator:(JBAuthenticator*)authenticator responseHandler:(id<JBHttpResponseHandler>)responseHandler {
    
    
    NSMutableURLRequest* request = [self buildPostRequest:requestAdapter authenticator:authenticator];
    
    int statusCode = [self dispatch:request authenticator:authenticator responseHandler:responseHandler];
    
    if( 401 == statusCode ) {
        request = [self buildPostRequest:requestAdapter authenticator:authenticator];
        statusCode = [self dispatch:request authenticator:authenticator responseHandler:responseHandler];
    }
    
    if( statusCode < 200 || statusCode > 299 ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:[JBHttpStatus getReason:statusCode]];
        [e autorelease];
        [e setFaultCode:statusCode];
        NSString* requestUri = [requestAdapter requestUri];
        [e addStringContext:requestUri withName:@"requestUri"];
        @throw  e;
    }
}


-(void)post:(JBHttpRequestAdapter*)requestAdapter responseHandler:(id<JBHttpResponseHandler>)responseHandler {
    
    
    NSMutableURLRequest* request = [self buildPostRequest:requestAdapter authenticator:nil];
    
    int statusCode = [self dispatch:request authenticator:nil responseHandler:responseHandler];
    
    
    if( statusCode < 200 || statusCode > 299 ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:[JBHttpStatus getReason:statusCode]];
        [e autorelease];
        [e setFaultCode:statusCode];
        NSString* requestUri = [requestAdapter requestUri];
        [e addStringContext:requestUri withName:@"requestUri"];
        @throw  e;
    }
        
}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithNetworkAddress:(JBNetworkAddress*)networkAddress {
	
	JBHttpDispatcher* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	[answer setNetworkAddress:networkAddress];
	
	return answer;
	
}

-(void)dealloc { 
	
	Log_enteredMethod();
	
	[JBObjectTracker deallocated:self];
	
	[self setNetworkAddress:nil];
	

	
	[super dealloc];
}

#pragma mark -
#pragma mark fields

//NetworkAddress* _networkAddress;
//@property (nonatomic, retain) NetworkAddress* networkAddress;
@synthesize networkAddress = _networkAddress;


		   
@end



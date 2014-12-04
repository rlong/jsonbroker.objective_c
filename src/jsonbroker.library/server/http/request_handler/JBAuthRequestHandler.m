//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBAuthorization.h"
#import "JBAuthRequestHandler.h"
#import "JBBaseException.h"
#import "JBBrokerMessage.h"
#import "JBHttpErrorHelper.h"
#import "JBHttpSecurityManager.h"
#import "JBLog.h"
#import "JBServicesRegistery.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBAuthRequestHandler () 


// processors
//NSMutableDictionary* _processors;
@property (nonatomic, retain) NSMutableDictionary* processors;
//@synthesize processors = _processors;


// securityManager
//HttpSecurityManager* _securityManager;
@property (nonatomic, retain) JBHttpSecurityManager* securityManager;
//@synthesize securityManager = _securityManager;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBAuthRequestHandler


static NSString* _REQUEST_URI = @"/_dynamic_/auth"; 



-(void)addRequestHandler:(id<JBRequestHandler>)processor {
    
    NSString* requestUri = [NSString stringWithFormat:@"%@%@", _REQUEST_URI, [processor getProcessorUri]];
    Log_debugString( requestUri );
    
    [_processors setObject:processor forKey:requestUri];
    
}


-(id<JBRequestHandler>)getRequestHandler:(NSString*)requestUri {
    
    Log_debugString( requestUri );
    
    NSRange indexOfQuestionMark = [requestUri rangeOfString:@"?"];
    if( NSNotFound != indexOfQuestionMark.location ) { 
        
        requestUri = [requestUri substringToIndex:indexOfQuestionMark.location];
    }
    
    
    id<JBRequestHandler> answer = [_processors objectForKey:requestUri];
    
    return answer;
}

-(NSString*)getProcessorUri {
    return _REQUEST_URI;
}


-(JBAuthorization*)getAuthorizationRequestHeader:(JBHttpRequest*)request {
    
    JBAuthorization* answer = nil;
    
    
    NSString* authorization = [request getHttpHeader:@"authorization"];
    if( nil == authorization ) {
        
        Log_error( @"nil == authorization" );
        @throw  [JBHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
        
    }
    
    answer = [JBAuthorization buildFromString:authorization];
    
    if( ![@"auth" isEqualToString:[answer qop]] ) { 
    
        Log_errorFormat( @"![@\"auth\" isEqualToString:[answer qop]]; [answer qop] = '%@'", [answer qop] );
        @throw  [JBHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
        
    }
    
    return answer;
    
}


-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    
    NSString* requestUri = [request requestUri];
    
    id<JBRequestHandler> httpProcessor;
    {
        httpProcessor = [self getRequestHandler:requestUri];
        
        if( nil ==  httpProcessor ) {
            
            Log_errorFormat( @"nil ==  processor; requestUri = '%@'", requestUri );
            @throw [JBHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
        }

    }
    
    
    JBHttpResponse* answer = nil;
    JBAuthorization* authorization = nil;
    
    @try {
        authorization = [self getAuthorizationRequestHeader:request];
        [_securityManager authenticateRequest:[[request method] name] authorizationRequestHeader:authorization];
        
        answer = [httpProcessor processRequest:request];
        return answer;
    }
    @catch (BaseException *exception) {
        
        NSString* UNAUTHORIZED_401 = [[JBHttpStatus errorDomain] UNAUTHORIZED_401];
        
        if( [UNAUTHORIZED_401 isEqualToString:[exception errorDomain]] ) {
            Log_warn( [exception reason] );
        } else {
            Log_errorException( exception );
        }
        
        answer = [JBHttpErrorHelper toHttpResponse:exception];
        return answer;            
    }
    @catch (NSException *exception) {
        Log_errorException( exception );
        answer = [JBHttpErrorHelper toHttpResponse:exception];
        return answer;
    }
    @finally {
        id<JBHttpHeader> header = [_securityManager getHeaderForResponse:authorization responseStatusCode:[answer status] responseEntity:[answer entity]];
        [answer putHeader:[header getName] value:[header getValue]];

    }
    
}


#pragma mark instance lifecycle

-(id)initWithSecurityManager:(JBHttpSecurityManager*)httpSecurityManager { 
    
    JBAuthRequestHandler* answer = [super init];
    
    if( nil != answer ) { 
        
        answer->_processors = [[NSMutableDictionary alloc] init];
        [answer setSecurityManager:httpSecurityManager];
        
    }
    
    return answer;
    
}


-(void)dealloc {
	
	[self setProcessors:nil];
	[self setSecurityManager:nil];
	
	[super dealloc];
	
}


#pragma mark fields

// processors
//NSMutableDictionary* _processors;
//@property (nonatomic, retain) NSMutableDictionary* processors;
@synthesize processors = _processors;


// securityManager
//HttpSecurityManager* _securityManager;
//@property (nonatomic, retain) HttpSecurityManager* securityManager;
@synthesize securityManager = _securityManager;



@end

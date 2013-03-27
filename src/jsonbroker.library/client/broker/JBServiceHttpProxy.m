// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBDataEntity.h"
#import "JBServiceHttpProxy.h"
#import "JBSerializer.h"

#import "JBLog.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBServiceHttpProxy () 

// httpDispatcher
//HttpDispatcher* _httpDispatcher;
@property (nonatomic, retain) JBHttpDispatcher* httpDispatcher;
//@synthesize httpDispatcher = _httpDispatcher;




// responseHandler
//BrokerMessageResponseHandler* _responseHandler;
@property (nonatomic, retain) JBBrokerMessageResponseHandler* responseHandler;
//@synthesize responseHandler = _responseHandler;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBServiceHttpProxy



-(JBBrokerMessage*)process:(JBBrokerMessage*)request {
    
    
    NSData* bodyData = [JBSerializer serialize:request];
    
    id<JBEntity> entity = [[JBDataEntity alloc] initWithData:bodyData];
    [entity autorelease];
    
    NSString* requestUri;
    
    if( nil == _authenticator ) {
        requestUri = @"/_dynamic_/open/services";
    } else {
        if( [_authenticator authInt] ) { 
            requestUri = @"/_dynamic_/auth-int/services";
        } else {
            requestUri = @"/_dynamic_/auth/services";
        }
    }
    
    JBHttpRequestAdapter* requestAdapter = [[JBHttpRequestAdapter alloc] initWithRequestUri:requestUri];
    [requestAdapter autorelease];
    [requestAdapter setRequestEntity:entity];
    
    [_httpDispatcher post:requestAdapter authenticator:_authenticator responseHandler:_responseHandler];
    
    return [_responseHandler getResponse];
    
}


// can return nil
-(NSString*)realm {

    if( nil == _authenticator ) { 
        return nil;
    }
    
    NSString* realm = [_authenticator realm];
    return realm;
    
}

-(NSString*)serviceName {
    return nil;
}

#pragma mark instance lifecycle

-(id)initWithHttpDispatcher:(JBHttpDispatcher*)httpDispatcher {
    
    JBServiceHttpProxy* answer = [super init];
    
    [answer setHttpDispatcher:httpDispatcher];
    answer->_authenticator = nil; // just to be clear about our intent
    answer->_responseHandler = [[JBBrokerMessageResponseHandler alloc] init];
    
    return answer;
    
}


-(id)initWithHttpDispatcher:(JBHttpDispatcher*)httpDispatcher authenticator:(JBAuthenticator*)authenticator {
    
    JBServiceHttpProxy* answer = [super init];
    
    [answer setHttpDispatcher:httpDispatcher];
    [answer setAuthenticator:authenticator];
    answer->_responseHandler = [[JBBrokerMessageResponseHandler alloc] init];
    
    return answer;

}


-(void)dealloc {
	
	[self setHttpDispatcher:nil];
	[self setAuthenticator:nil];
    [self setResponseHandler:nil];

	[super dealloc];
	
}


#pragma mark fields


// httpDispatcher
//HttpDispatcher* _httpDispatcher;
//@property (nonatomic, retain) HttpDispatcher* httpDispatcher;
@synthesize httpDispatcher = _httpDispatcher;

// authenticator
//Authenticator* _authenticator;
//@property (nonatomic, retain) Authenticator* authenticator;
@synthesize authenticator = _authenticator;


// responseHandler
//BrokerMessageResponseHandler* _responseHandler;
//@property (nonatomic, retain) BrokerMessageResponseHandler* responseHandler;
@synthesize responseHandler = _responseHandler;



@end

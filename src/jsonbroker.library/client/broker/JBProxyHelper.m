// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBProxyHelper.h"
#import "JBServiceHelper.h"

#import "JBLog.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBProxyHelper () 



// clientSecurityConfiguration
//id<ClientSecurityConfiguration> _clientSecurityConfiguration;
@property (nonatomic, retain) id<JBClientSecurityConfiguration> clientSecurityConfiguration;
//@synthesize clientSecurityConfiguration = _clientSecurityConfiguration;


// openHttpProxy
//ServiceHttpProxy* _openHttpProxy;
@property (nonatomic, retain) JBServiceHttpProxy* openHttpProxy;
//@synthesize openHttpProxy = _openHttpProxy;


// authHttpProxy
//ServiceHttpProxy* _authHttpProxy;
@property (nonatomic, retain) JBServiceHttpProxy* authHttpProxy;
//@synthesize authHttpProxy = _authHttpProxy;




@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



@implementation JBProxyHelper


// will throw an exception if 'initialize' has not been previously called
-(id<JBService>)getOpenService {
    
    if( nil == _host ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"nil == _host"];
        [e autorelease];
        @throw  e;
    }
    
    if( nil != _openHttpProxy ) { 
        return _openHttpProxy;
    }

    JBNetworkAddress* networkAddress = [[JBNetworkAddress alloc] initWithIp4Address:_host port:_port]; // 
    [networkAddress autorelease];
    
    JBHttpDispatcher* httpDispatcher = [[JBHttpDispatcher alloc] initWithNetworkAddress:networkAddress];
    [httpDispatcher autorelease];
    
    _openHttpProxy = [[JBServiceHttpProxy alloc] initWithHttpDispatcher:httpDispatcher];        

    return _openHttpProxy;
    
}

// will throw an exception if 'initialize' has not been previously called
-(id<JBService>)getAuthService:(id<JBClientSecurityConfiguration>)clientSecurityConfiguration {
    
    if( nil == _host ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"nil == _host"];
        [e autorelease];
        @throw  e;
    }
    
    
    if( nil != _authHttpProxy && [[_authHttpProxy authenticator] securityConfiguration] == clientSecurityConfiguration ) {
        return _authHttpProxy;
    }
    
    JBNetworkAddress* networkAddress = [[JBNetworkAddress alloc] initWithIp4Address:_host port:_port]; // 
    [networkAddress autorelease];
    
    JBHttpDispatcher* httpDispatcher = [[JBHttpDispatcher alloc] initWithNetworkAddress:networkAddress];
    [httpDispatcher autorelease];

    JBAuthenticator* authenticator = [[JBAuthenticator alloc] initWithAuthInt:FALSE securityConfiguration:clientSecurityConfiguration];
    [authenticator autorelease];

    _authHttpProxy = [[JBServiceHttpProxy alloc] initWithHttpDispatcher:httpDispatcher authenticator:authenticator];
    return _authHttpProxy;
    
}



// username, realm, password can be nil when 
-(void)initializeWithHost:(NSString*)host port:(int)port {
    
    
    [self setHost:host];
    [self setPort:port];
    
    [self setOpenHttpProxy:nil];
    [self setAuthHttpProxy:nil];
    
    
}



-(NSString*)hostIdentifer {
    
    if( nil == _authHttpProxy ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"nil == _authHttpProxy"];
        [e autorelease];
        @throw e;
    }
    NSString* realm = [_authHttpProxy realm];
    if( nil != realm ) { 
        return realm;
    }
    
    NSString* answer = [NSString stringWithFormat:@"%@:%d", [self host], [self port]];
    return answer;
    
}

#pragma mark instance lifecycle 


-(id)init {
    
    JBProxyHelper* answer = [super init];
    
    return answer;
}


-(void)dealloc {
	
    [self setHost:nil];
    [self setClientSecurityConfiguration:nil];
	[self setOpenHttpProxy:nil];
    [self setAuthHttpProxy:nil];

	
	[super dealloc];
	
}


#pragma mark fields


// host
//NSString* _host;
//@property (nonatomic, retain) NSString* host;
@synthesize host = _host;

// port
//int  _port;
//@property (nonatomic) int  port;
@synthesize port = _port;


// clientSecurityConfiguration
//id<ClientSecurityConfiguration> _clientSecurityConfiguration;
//@property (nonatomic, retain) id<ClientSecurityConfiguration> clientSecurityConfiguration;
@synthesize clientSecurityConfiguration = _clientSecurityConfiguration;


// openHttpProxy
//ServiceHttpProxy* _openHttpProxy;
//@property (nonatomic, retain) ServiceHttpProxy* openHttpProxy;
@synthesize openHttpProxy = _openHttpProxy;


// authHttpProxy
//ServiceHttpProxy* _authHttpProxy;
//@property (nonatomic, retain) ServiceHttpProxy* authHttpProxy;
@synthesize authHttpProxy = _authHttpProxy;



@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>

#import "JBClientSecurityConfiguration.h"
#import "JBService.h"
#import "JBServiceHttpProxy.h"

@interface JBProxyHelper : NSObject {
    
    // host
    NSString* _host;
    //@property (nonatomic, retain) NSString* host;
    //@synthesize host = _host;

    // port
	int  _port;
	//@property (nonatomic) int  port;
	//@synthesize port = _port;
    
    // clientSecurityConfiguration
    id<JBClientSecurityConfiguration> _clientSecurityConfiguration;
    //@property (nonatomic, retain) id<ClientSecurityConfiguration> clientSecurityConfiguration;
    //@synthesize clientSecurityConfiguration = _clientSecurityConfiguration;

    // 'openHttpProxy' can be nil, if not if service is not 'initialize'd 
    // openHttpProxy
	JBServiceHttpProxy* _openHttpProxy;
	//@property (nonatomic, readonly) ServiceHttpProxy* openHttpProxy;
	//@synthesize openHttpProxy = _openHttpProxy;

    // 'authHttpProxy' can be nil, if not if service is not 'initialize'd with a username, realm, password
    // authHttpProxy
	JBServiceHttpProxy* _authHttpProxy;
	//@property (nonatomic, retain) ServiceHttpProxy* authHttpProxy;
	//@synthesize authHttpProxy = _authHttpProxy;
    
}


// will throw an exception if 'initialize' has not been previously called
-(id<JBService>)getOpenService;

// will throw an exception if 'initialize' has not been previously called
-(id<JBService>)getAuthService:(id<JBClientSecurityConfiguration>)clientSecurityConfiguration;

-(void)initializeWithHost:(NSString*)host port:(int)port;

-(NSString*)hostIdentifer;

#pragma mark -
#pragma mark instance lifecycle

-(id)init;


#pragma mark -
#pragma mark fields

// host
//NSString* _host;
@property (nonatomic, retain) NSString* host;
//@synthesize host = _host;


// port
//int  _port;
@property (nonatomic) int  port;
//@synthesize port = _port;



@end

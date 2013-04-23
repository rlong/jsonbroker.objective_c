// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBDefaults.h"
#import "JBHttpDispatcher.h"
#import "JBIntegrationTestUtilities.h"
#import "JBJsonBrokerException.h"
#import "JBLog.h"
#import "JBOpenRequestHandler.h"
#import "JBRootRequestHandler.h"
#import "JBSecurityConfiguration.h"
#import "JBServiceHttpProxy.h"
#import "JBServicesRegistery.h"
#import "JBServicesRequestHandler.h"
#import "JBWebServer.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBIntegrationTestUtilities ()




-(void)setup;


// internalWebServer
//JBIntegrationTestServer* _internalWebServer;
@property (nonatomic, retain) JBIntegrationTestServer* internalWebServer;
//@synthesize internalWebServer = _internalWebServer;

// networkAddress
//JBNetworkAddress* _networkAddress;
@property (nonatomic, retain) JBNetworkAddress* networkAddress;
//@synthesize networkAddress = _networkAddress;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBIntegrationTestUtilities

static JBJsonObject* _internalServerConfig = nil;
static JBJsonObject* _externalServerConfig = nil;

static JBIntegrationTestUtilities* _INSTANCE;

+(void)initialize {
    
    
    /*
     name: jsonbroker_IntegrationTestUtilities
     value: {}
     value: {"internalServerConfig":{}}
     value: {"internalServerConfig":{"useAuthService":true}}
     value: {"externalServerConfig":{"hostIp4Address":"127.0.0.1","useAuthService":false}}
     value: {"externalServerConfig":{"hostIp4Address":"127.0.0.1","useAuthService":true}}
     */
    
    JBDefaults* defaults = [[JBDefaults alloc] initWithScope:@"jsonbroker.IntegrationTestUtilities"];
    {
        
        _internalServerConfig = [[defaults jsonObjectWithName:@"internalServerConfig" defaultValue:nil] retain];
        _externalServerConfig = [[defaults jsonObjectWithName:@"externalServerConfig" defaultValue:nil] retain];
        
    }
    [defaults release];
    
    
    Log_debugPointer( _internalServerConfig );
    Log_debugPointer( _externalServerConfig );
    
    
    
}



+(JBIntegrationTestUtilities*)getInstance {
    
    if( nil != _INSTANCE ) {
        return _INSTANCE;
    }
    
    _INSTANCE = [[JBIntegrationTestUtilities alloc] init];
    [_INSTANCE setup];
    
    return _INSTANCE;
    
    
}


-(bool)configuredForExternalServer {
    
    if( nil != _externalServerConfig ) {
        return true;
    }
    
    return false;
    
}

-(bool)configuredForInternalServer {
    
    if( nil != _internalServerConfig ) {
        return true;
    }
    
    return false;
    
}


-(void)setup {
    
    Log_enteredMethod();
    
    
    if( nil != _internalServerConfig ) {

        if( nil != _internalWebServer ) {
            return;
        }

        _internalWebServer = [[JBIntegrationTestServer alloc] init];
        [_internalWebServer start];
        
        _networkAddress = [[JBNetworkAddress alloc] initWithIp4Address:@"127.0.0.1" port:8081]; // localhost

        return;

    }
    
    if( nil != _externalServerConfig ) {
        
        NSString* hostIp4Address = [_externalServerConfig stringForKey:@"hostIp4Address"];
        _networkAddress = [[JBNetworkAddress alloc] initWithIp4Address:hostIp4Address port:8081];
        
        return;
        
    }
    
    
    
    // co-located ...
    return;
    
    
    
}

-(void)teardown {

    Log_enteredMethod();
    
    if( nil != _internalWebServer ) {
        [_internalWebServer stop];
    }

}


-(JBServiceHttpProxy*)buildServiceHttpProxy:(bool)useAuthService {
    
    JBAuthenticator* authenticator =  nil;

    
    if( useAuthService ) {
        
        JBSecurityConfiguration* securityConfiguration = [JBSecurityConfiguration TEST];
        authenticator = [[JBAuthenticator alloc] initWithAuthInt:false securityConfiguration:securityConfiguration];
        [authenticator autorelease];
    }
    

    JBHttpDispatcher* httpDispatcher = [[JBHttpDispatcher alloc] initWithNetworkAddress:_networkAddress];
    [httpDispatcher autorelease];
    
    JBServiceHttpProxy* answer = [[JBServiceHttpProxy alloc] initWithHttpDispatcher:httpDispatcher authenticator:authenticator];
    [answer autorelease];

    return answer;    
    
}

-(id<JBService>)wrapService:(id<JBDescribedService>)service {
    
    
    if( nil != _internalServerConfig ) {
        
        // add the service to the running webserver ...
        [_internalWebServer addService:service];
        
        bool useAuthService = [_internalServerConfig boolForKey:@"useAuthService" defaultValue:false];
        return [self buildServiceHttpProxy:useAuthService];

    }
    
    if( nil != _externalServerConfig ) {
        
        bool useAuthService = [_externalServerConfig boolForKey:@"useAuthService" defaultValue:false];
        return [self buildServiceHttpProxy:useAuthService];        
        
    }
    
    return service;
    
}



#pragma mark -
#pragma mark instance lifecycle

-(void)dealloc {
	
	[self setInternalWebServer:nil];
    [self setNetworkAddress:nil];

	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields

// internalWebServer
//JBIntegrationTestServer* _internalWebServer;
//@property (nonatomic, retain) JBIntegrationTestServer* internalWebServer;
@synthesize internalWebServer = _internalWebServer;

// networkAddress
//JBNetworkAddress* _networkAddress;
//@property (nonatomic, retain) JBNetworkAddress* networkAddress;
@synthesize networkAddress = _networkAddress;


@end




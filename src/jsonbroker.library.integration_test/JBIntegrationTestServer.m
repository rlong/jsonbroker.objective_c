// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBAuthRequestHandler.h"
#import "JBHttpSecurityManager.h"
#import "JBIntegrationTestServer.h"
#import "JBLog.h"
#import "JBOpenRequestHandler.h"
#import "JBRootRequestHandler.h"
#import "JBSecurityConfiguration.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBIntegrationTestServer ()


// openServicesRequestHandler
//JBServicesRequestHandler* _openServicesRequestHandler;
@property (nonatomic, retain) JBServicesRequestHandler* openServicesRequestHandler;
//@synthesize openServicesRequestHandler = _openServicesRequestHandler;

// authServicesRequestHandler
//JBServicesRequestHandler* _authServicesRequestHandler;
@property (nonatomic, retain) JBServicesRequestHandler* authServicesRequestHandler;
//@synthesize authServicesRequestHandler = _authServicesRequestHandler;


// webServer
//JBWebServer* _webServer;
@property (nonatomic, retain) JBWebServer* webServer;
//@synthesize webServer = _webServer;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBIntegrationTestServer


-(void)addService:(id<JBDescribedService>)service {
    
    [_openServicesRequestHandler addService:service];
    [_authServicesRequestHandler addService:service];
    
}


-(void)start {
    
    if( nil != _webServer ) {
        Log_warn( @"nil != _webServer" );
        return;
    }

    
    JBRootRequestHandler* rootProcessor = [[JBRootRequestHandler alloc] init];
    [rootProcessor autorelease];

    // open ... 
    {

        _openServicesRequestHandler = [[JBServicesRequestHandler alloc] init];
        
        
        JBOpenRequestHandler* openRequestHandler = [[JBOpenRequestHandler alloc] init];
        [openRequestHandler autorelease];
        [openRequestHandler addRequestHandler:_openServicesRequestHandler];

        [rootProcessor addRequestHandler:openRequestHandler];

    }
    
    // auth ...
    {
        
        _authServicesRequestHandler = [[JBServicesRequestHandler alloc] init];

        id<JBServerSecurityConfiguration> securityConfiguration = [JBSecurityConfiguration TEST];
        
        JBHttpSecurityManager* httpSecurityManager = [[JBHttpSecurityManager alloc] initWithSecurityConfiguration:securityConfiguration];
        [httpSecurityManager autorelease];
        
        JBAuthRequestHandler* authRequestHandler = [[JBAuthRequestHandler alloc] initWithSecurityManager:httpSecurityManager];
        [authRequestHandler autorelease];
        [authRequestHandler addRequestHandler:_authServicesRequestHandler];
        
        
        [rootProcessor addRequestHandler:authRequestHandler];
                                                    
    }

    
    
    
    _webServer = [[JBWebServer alloc] initWithHttpProcessor:rootProcessor];
    [_webServer start];

    
}

-(void)stop {
    
    Log_enteredMethod();
    
    if( nil != _webServer ) {
        [_webServer stop];
    }

}



#pragma mark -
#pragma mark instance lifecycle

-(void)dealloc {
	
	[self setOpenServicesRequestHandler:nil];
    [self setAuthServicesRequestHandler:nil];

    [self stop];
    [self setWebServer:nil];
	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields

// openServicesRequestHandler
//JBServicesRequestHandler* _openServicesRequestHandler;
//@property (nonatomic, retain) JBServicesRequestHandler* openServicesRequestHandler;
@synthesize openServicesRequestHandler = _openServicesRequestHandler;

// authServicesRequestHandler
//JBServicesRequestHandler* _authServicesRequestHandler;
//@property (nonatomic, retain) JBServicesRequestHandler* authServicesRequestHandler;
@synthesize authServicesRequestHandler = _authServicesRequestHandler;


// webServer
//JBWebServer* _webServer;
//@property (nonatomic, retain) JBWebServer* webServer;
@synthesize webServer = _webServer;



@end

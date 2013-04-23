// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


#import "JBServicesRequestHandler.h"
#import "JBWebServer.h"


@interface JBIntegrationTestServer : NSObject {
    
    // openServicesRequestHandler
    JBServicesRequestHandler* _openServicesRequestHandler;
    //@property (nonatomic, retain) JBServicesRequestHandler* openServicesRequestHandler;
    //@synthesize openServicesRequestHandler = _openServicesRequestHandler;
   
    
    // authServicesRequestHandler
    JBServicesRequestHandler* _authServicesRequestHandler;
    //@property (nonatomic, retain) JBServicesRequestHandler* authServicesRequestHandler;
    //@synthesize authServicesRequestHandler = _authServicesRequestHandler;

    
    // webServer
    JBWebServer* _webServer;
    //@property (nonatomic, retain) JBWebServer* webServer;
    //@synthesize webServer = _webServer;
    
    

}

-(void)addService:(id<JBDescribedService>)service;

-(void)start;
-(void)stop;



@end

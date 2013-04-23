// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBIntegrationTestServer.h"
#import "JBNetworkAddress.h"
#import "JBSecurityConfiguration.h"
#import "JBService.h"
#import "JBServicesRequestHandler.h"
#import "JBSubject.h"
#import "JBWebServer.h"


@interface JBIntegrationTestUtilities : NSObject {
    
    
    // internalWebServer
    JBIntegrationTestServer* _internalWebServer;
    //@property (nonatomic, retain) JBIntegrationTestServer* internalWebServer;
    //@synthesize internalWebServer = _internalWebServer;
    
    // networkAddress
    JBNetworkAddress* _networkAddress;
    //@property (nonatomic, retain) JBNetworkAddress* networkAddress;
    //@synthesize networkAddress = _networkAddress;

    
}

+(JBIntegrationTestUtilities*)getInstance;

-(bool)configuredForExternalServer;
-(bool)configuredForInternalServer;


-(id<JBService>)wrapService:(id<JBDescribedService>)service;


@end




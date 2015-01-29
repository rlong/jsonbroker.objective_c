//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@protocol JBDescribedService;
@class JBOpenRequestHandler;
@class JBServicesRequestHandler;
@class JBWebServer;
@protocol JBRequestHandler;


@interface JBSampleWebServer : NSObject {
    
    // openRequestHandler
    JBOpenRequestHandler* _openRequestHandler;
    //@property (nonatomic, retain) JBOpenRequestHandler* openRequestHandler;
    //@synthesize openRequestHandler = _openRequestHandler;
    
    // openServices
    JBServicesRequestHandler* _openServices;
    //@property (nonatomic, retain) JBServicesRequestHandler* openServices;
    //@synthesize openServices = _openServices;
    
    // webServer
    JBWebServer* _webServer;
    //@property (nonatomic, retain) JBWebServer* webServer;
    //@synthesize webServer = _webServer;

    
}

-(void)addOpenRequestHandler:(id<JBRequestHandler>)requestHandler;
-(void)addOpenService:(id<JBDescribedService>)describedService;

-(void)start;
-(void)stop;

@end

//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBEchoConnectRequestHandler.h"
#import "JBFileRequestHandler.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBNetworkUtilities.h"
#import "JBOpenRequestHandler.h"
#import "JBRootRequestHandler.h"
#import "JBSampleWebServer.h"
#import "JBServicesRequestHandler.h"
#import "JBWebServer.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBSampleWebServer ()

// openRequestHandler
//JBOpenRequestHandler* _openRequestHandler;
@property (nonatomic, retain) JBOpenRequestHandler* openRequestHandler;
//@synthesize openRequestHandler = _openRequestHandler;

// openServices
//JBServicesRequestHandler* _openServices;
@property (nonatomic, retain) JBServicesRequestHandler* openServices;
//@synthesize openServices = _openServices;


// webServer
//JBWebServer* _webServer;
@property (nonatomic, retain) JBWebServer* webServer;
//@synthesize webServer = _webServer;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBSampleWebServer



-(void)addOpenRequestHandler:(id<JBRequestHandler>)requestHandler {
    
    [_openRequestHandler addRequestHandler:requestHandler];
    
}


-(void)addOpenService:(id<JBDescribedService>)describedService {
    
    [_openServices addService:describedService];
    
}


-(JBRootRequestHandler*)buildRootRequestHandler {
    
    
    NSString* rootFolder = [[NSBundle mainBundle] pathForResource:@"assets" ofType:nil];

    
    JBFileRequestHandler* fileProcessor = [[JBFileRequestHandler alloc] initWithRootFolder:rootFolder];
    JBAutorelease( fileProcessor );
    
   
    JBRootRequestHandler* answer = [[JBRootRequestHandler alloc] initWithDefaultProcessor:fileProcessor];
    JBAutorelease( answer );
    
    return answer;
}


-(void)setup {
    
    JBRootRequestHandler* rootRequestHandler  = [self buildRootRequestHandler];
    
    {
        [rootRequestHandler addRequestHandler:_openRequestHandler];
    }
    
    {
        JBEchoConnectRequestHandler* echoConnectRequestHandler = [[JBEchoConnectRequestHandler alloc] init];
        {
            [_openRequestHandler addRequestHandler:echoConnectRequestHandler];
        }
        JBRelease( echoConnectRequestHandler );
        
    }
    
    uint32_t port = 8080;
    
    JBWebServer* webserver = [[JBWebServer alloc] initWithPort:port httpProcessor:rootRequestHandler];
    {
        [self setWebServer:webserver];
    }
    JBRelease( webserver );
    
    
}

-(void)start {
    
    
    [_webServer start];
    
    JBIPAddress* wifiIpAddress = [JBNetworkUtilities getWifiIpAddress];
    Log_infoFormat( @"HTTP server running ... http://%@:8080/index.html", [wifiIpAddress toString] );
    
}


-(void)stop {
    
    [_webServer stop];
}


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
    
    JBSampleWebServer* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_openRequestHandler = [[JBOpenRequestHandler alloc] init];
        answer->_openServices = [[JBServicesRequestHandler alloc] init];
        
        [answer->_openRequestHandler addRequestHandler:answer->_openServices];
        
        [answer setup];
        
    }
    
    return answer;
    
}



-(void)dealloc {
    
    [self setOpenRequestHandler:nil];
    [self setOpenServices:nil];
    [self setWebServer:nil];
    
    JBSuperDealloc();
    
}


#pragma mark -
#pragma mark fields


// openRequestHandler
//JBOpenRequestHandler* _openRequestHandler;
//@property (nonatomic, retain) JBOpenRequestHandler* openRequestHandler;
@synthesize openRequestHandler = _openRequestHandler;


// openServices
//JBServicesRequestHandler* _openServices;
//@property (nonatomic, retain) JBServicesRequestHandler* openServices;
@synthesize openServices = _openServices;


// webServer
//JBWebServer* _webServer;
//@property (nonatomic, retain) JBWebServer* webServer;
@synthesize webServer = _webServer;

@end

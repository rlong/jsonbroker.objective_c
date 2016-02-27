// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBIntegrationTestUtilities.h"
#import "JBLog.h"
#import "JBMetaProxy.h"
#import "JBMetaProxyIntegrationTest.h"
#import "JBServicesRegistery.h"
#import "JBTestService.h"

@implementation JBMetaProxyIntegrationTest


-(void)test1 {
    
    Log_enteredMethod();
}


+(JBMetaProxy*)buildProxy {
    
    JBServicesRegistery *servicesRegistery =  [[JBServicesRegistery alloc] init];
    [servicesRegistery autorelease];
    
    JBTestService* testService = [[JBTestService alloc] init];
    [servicesRegistery addService:testService];
    
    JBMetaProxy* answer = [[JBMetaProxy alloc] initWithService:servicesRegistery];
    [answer autorelease];
    
    return answer;


}


-(void)testGetInterfaceVersion {
    
    Log_enteredMethod();
    
    JBMetaProxy* proxy = [JBMetaProxyIntegrationTest buildProxy];
    
    NSArray* version = [proxy getVersion:[JBTestService SERVICE_NAME]];
    XCTAssertNotNil( version, @"version = %p", version);
    
    NSNumber* majorVersion = [version objectAtIndex:0];
    XCTAssertNotNil( majorVersion, @"majorVersion = %p", majorVersion);
    XCTAssertTrue( 1 == [majorVersion intValue], @"[majorVersion intValue] = %d", [majorVersion intValue]);
    
    NSNumber* minorVersion = [version objectAtIndex:1];
    XCTAssertNotNil( minorVersion, @"minorVersion = %p", minorVersion);
    XCTAssertTrue( 0 == [minorVersion intValue], @"[minorVersion intValue] = %d", [minorVersion intValue]);
    
    
    
}


-(void)testGetInterfaceVersionFromNonExistingService { 
    
    Log_enteredMethod();
        
    JBMetaProxy* proxy = [JBMetaProxyIntegrationTest buildProxy];
    
    NSArray* version = [proxy getVersion:@"module.non-existing-service"];
    XCTAssertNil( version, @"version = %p", version);
    
    
}

@end






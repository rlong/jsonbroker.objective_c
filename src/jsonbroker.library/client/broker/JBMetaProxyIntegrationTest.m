// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBMetaProxy.h"
#import "JBMetaProxyIntegrationTest.h"
#import "JBTestService.h"

#import "JBLog.h"
#import "JBIntegrationTestUtilities.h"

@implementation JBMetaProxyIntegrationTest


-(void)test1 {
    
    Log_enteredMethod();
}

-(void)testGetInterfaceVersion {
    
    Log_enteredMethod();
    
    
    id<JBService> openHttpProxy = [JBIntegrationTestUtilities buildOpenHttpProxy];
    
    JBMetaProxy* proxy = [[JBMetaProxy alloc] initWithService:openHttpProxy];
    [proxy autorelease];
    
    NSArray* version = [proxy getVersion:[JBTestService SERVICE_NAME]];
    STAssertNotNil( version, @"version = %p", version);
    
    NSNumber* majorVersion = [version objectAtIndex:0];
    STAssertNotNil( majorVersion, @"majorVersion = %p", majorVersion);
    STAssertTrue( 1 == [majorVersion intValue], @"[majorVersion intValue] = %d", [majorVersion intValue]);
    
    NSNumber* minorVersion = [version objectAtIndex:1];
    STAssertNotNil( minorVersion, @"minorVersion = %p", minorVersion);
    STAssertTrue( 0 == [minorVersion intValue], @"[minorVersion intValue] = %d", [minorVersion intValue]);
    
    
    
}


-(void)testGetInterfaceVersionFromNonExistingService { 
    
    Log_enteredMethod();
    
    
    id<JBService> openHttpProxy = [JBIntegrationTestUtilities buildOpenHttpProxy];
    
    JBMetaProxy* proxy = [[JBMetaProxy alloc] initWithService:openHttpProxy];
    [proxy autorelease];
    
    NSArray* version = [proxy getVersion:@"module.non-existing-service"];
    STAssertNil( version, @"version = %p", version);
    
    
}

@end






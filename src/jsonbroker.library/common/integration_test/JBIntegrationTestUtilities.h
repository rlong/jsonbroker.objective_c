// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBNetworkAddress.h"
#import "JBSecurityConfiguration.h"
#import "JBService.h"
#import "JBSubject.h"


enum JBIntegrationTestUtilities_TestType { TestType_CO_LOCATED, TestType_EXTERNAL };
enum JBIntegrationTestUtilities_Target { Target_JAVA_WINDOWS_XP, Target_CSHARP_WINDOWS_XP, Target_OBJ_OSX };

@interface JBIntegrationTestUtilities : NSObject {
    
}

+(JBNetworkAddress*)getNetworkAddress;

+(enum JBIntegrationTestUtilities_TestType)getTestType;
+(enum JBIntegrationTestUtilities_Target)getTarget;


+(id<JBService>)buildOpenHttpProxy;
+(id<JBService>)buildAuthenticatingHttpProxy;


+(id<JBService>)wrapAuthenticatedService:(id<JBService>)service;
+(id<JBService>)wrapOpenService:(id<JBService>)service;



@end




// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBHttpDispatcher.h"
#import "JBSecurityConfiguration.h"
#import "JBServiceHttpProxy.h"

#import "JBIntegrationTestUtilities.h"
#import "JBJsonBrokerException.h"
#import "JBLog.h"

@implementation JBIntegrationTestUtilities



+(enum JBIntegrationTestUtilities_TestType)getTestType {
    return TestType_EXTERNAL;
}

+(enum JBIntegrationTestUtilities_Target)getTarget {
    return Target_OBJ_OSX;
    
}

+(JBNetworkAddress*)getNetworkAddress {
  
    JBNetworkAddress* answer;
    
    enum JBIntegrationTestUtilities_Target target = [self getTarget];
    
    if( Target_OBJ_OSX == target ) {
        
        answer = [[JBNetworkAddress alloc] initWithIp4Address:@"127.0.0.1" port:8081]; // localhost / OSX
        [answer autorelease];
    } else if( Target_JAVA_WINDOWS_XP == target || Target_CSHARP_WINDOWS_XP == target ) {

        
        JBJsonBrokerException* e = [[JBJsonBrokerException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"targets not supported"];
        [e autorelease];
        @throw  e;

    } else {
        JBJsonBrokerException* e = [[JBJsonBrokerException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unkown target"];
        [e autorelease];
        @throw  e;
    }
    
    return answer;
    
}


                   


+(id<JBService>)buildOpenHttpProxy {

    
    JBNetworkAddress* networkAddress = [self getNetworkAddress];
    
    JBHttpDispatcher* httpDispatcher = [[JBHttpDispatcher alloc] initWithNetworkAddress:networkAddress];
    [httpDispatcher autorelease];
    
    id<JBService> answer = [[JBServiceHttpProxy alloc] initWithHttpDispatcher:httpDispatcher authenticator:nil];
    [answer autorelease];
    
    return answer;

}


+(id<JBService>)buildAuthenticatingHttpProxy {
    
    JBNetworkAddress* networkAddress = [self getNetworkAddress];
    
    JBHttpDispatcher* httpDispatcher = [[JBHttpDispatcher alloc] initWithNetworkAddress:networkAddress];
    [httpDispatcher autorelease];
    
    JBAuthenticator* authenticator = [[JBAuthenticator alloc] initWithAuthInt:false securityConfiguration:[JBSecurityConfiguration TEST]];
    [authenticator autorelease];
    
    id<JBService> answer = [[JBServiceHttpProxy alloc] initWithHttpDispatcher:httpDispatcher authenticator:authenticator];
    [answer autorelease];
    
    return answer;
    
}


+(id<JBService>)wrapOpenService:(id<JBService>)service {
    if( TestType_CO_LOCATED == [self getTestType]) {
        return service;
    }
    
    return [self buildOpenHttpProxy];
    
}

+(id<JBService>)wrapAuthenticatedService:(id<JBService>)service {
    if( TestType_CO_LOCATED == [self getTestType]) {
        return service;
    }
    
    return [self buildAuthenticatingHttpProxy];
    
}



@end




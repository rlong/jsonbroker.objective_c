//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBLog.h"
#import "JBServiceHelper.h"
#import "JBTestService.h"


@implementation JBTestService

static NSString* _SERVICE_NAME = @"jsonbroker.TestService"; 
static JBServiceDescription* _SERVICE_DESCRIPTION = nil; 


+(void)initialize {
	
    _SERVICE_DESCRIPTION = [[JBServiceDescription alloc] initWithServiceName:_SERVICE_NAME];
	
}


+(NSString*)SERVICE_NAME {
    return _SERVICE_NAME;
}


-(void)ping {
	Log_enteredMethod();
}

-(void)raiseError { 
    
	Log_enteredMethod();
    BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"[jsonbroker.TestService raiseError] called "];
    [e setErrorDomain:@"jsonbroker.TestService.RAISE_ERROR"];
    [e autorelease]; 
    @throw e;
    
                      
}

#pragma mark -
#pragma mark <DescribedService> implementation 

-(JBBrokerMessage*)process:(JBBrokerMessage*)request {
	
	NSString* methodName = [request methodName];
	
	if( [@"ping" isEqualToString:methodName] ) { 
		
		[self ping];
		
		return [JBBrokerMessage buildResponse:request];

	}
    
    if( [@"raiseError" isEqualToString:methodName] ) { 
		
		[self raiseError];
		
		return [JBBrokerMessage buildResponse:request];
        
	}
	
    @throw [JBServiceHelper methodNotFound:self request:request];
	
	
}


-(JBServiceDescription*)serviceDescription {
    return _SERVICE_DESCRIPTION;
}




@end

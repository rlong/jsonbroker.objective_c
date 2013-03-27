//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBServiceHelper.h"

@implementation JBServiceHelper



+(BaseException*)methodNotFound:(id)originator request:(JBBrokerMessage*)request {
    
    
    NSString* methodName = [request methodName];
    
	NSString* technicalError = [NSString stringWithFormat:@"Unknown methodName; methodName = '%@'", methodName];
	
	BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
    [e setErrorDomain:@"jsonbroker.ServiceHelper.METHOD_NOT_FOUND"];
	[e autorelease];
    
    return e;

}


@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJsonBrokerException.h"

@implementation JBJsonBrokerException

-(NSString*)domain {
    return @"jsonbroker";
}


#pragma mark instance setup/teardown 

-(id)initWithOriginator:(NSString*)originator faultMessage:(NSString *)faultMessage {
    
    return [super initWithOriginator:originator faultMessage:faultMessage];
    
}


-(id)initWithOriginator:(id)originatingObject line:(int)line faultMessage:(NSString *)faultMessage {

    return [super initWithOriginator:originatingObject line:line faultMessage:faultMessage];
	
}



-(id)initWithOriginator:(id)originatingObject line:(int)line faultStringFormat:(NSString *)faultStringFormat, ... {
    
    NSString* className = NSStringFromClass([originatingObject class]);
    NSString* originator = [NSString stringWithFormat:@"%@:%x", className, line];
    
	NSString* technicalError = nil;
	
	va_list vaList;
	va_start(vaList, faultStringFormat);
	{
		technicalError = [[NSString alloc] initWithFormat:faultStringFormat arguments:vaList];
	}
	va_end(vaList);
    
    
    JBJsonBrokerException* answer = [self initWithOriginator:originator faultMessage:technicalError];
    
	return answer;
}




-(id)initWithOriginator:(id)originatingObject line:(int)line callTo:(NSString*)methodName failedWithErrno:(int)value {
    
    return [super initWithOriginator:originatingObject line:line callTo:methodName failedWithErrno:value];
    
}

-(id)initWithOriginator:(id)originatingObject line:(int)line callTo:(NSString*)methodName failedWithError:(NSError*)error {
    
    return [super initWithOriginator:originatingObject line:line callTo:methodName failedWithError:error];
    
    
}

-(id)initWithOriginator:(id)originatingObject line:(int)line cause:(NSException*)cause {
    return [super initWithOriginator:originatingObject line:line cause:cause];
}


@end

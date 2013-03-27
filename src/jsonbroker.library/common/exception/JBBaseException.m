// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"

@implementation JBBaseException




+(JBBaseException*)baseExceptionWithOriginator:(id)originatingObject line:(int)line faultString:(NSString *)faultString {
    

    JBBaseException* answer = [[JBBaseException alloc] initWithOriginator:originatingObject line:line faultMessage:faultString];
    [answer autorelease];
    
    return answer;

    
}


+(JBBaseException*)baseExceptionWithOriginator:(id)originatingObject line:(int)line faultStringFormat:(NSString *)format, ... {
    
    
    JBBaseException* answer;
    
    va_list vaList;
	va_start(vaList, format);
	{
        answer = [[JBBaseException alloc] initWithOriginator:originatingObject line:line faultStringFormat:format arguments:vaList];
        [answer autorelease];
	}
	va_end(vaList);

    return answer;
    
}


+(JBBaseException*)baseExceptionWithOriginator:(id)originatingObject line:(int)line callTo:(NSString*)methodName failedWithError:(NSError*)error {
    
    JBBaseException* answer = [[JBBaseException alloc] initWithOriginator:originatingObject line:line callTo:methodName failedWithError:error];
    [answer autorelease];
    
    return answer;
    
}




@end

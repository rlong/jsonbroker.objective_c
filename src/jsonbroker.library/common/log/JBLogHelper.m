//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBLog.h"
#import "JBLogHelper.h"
#import "JBSimpleLogConsumer.h"

@implementation JBLogHelper



+(JBSimpleLogConsumer*)setupSimpleLogConsumer {
    
    JBSimpleLogConsumer* answer = [[JBSimpleLogConsumer alloc] init];
    {
        [JBLog setLogConsumer:answer forCaller:__func__];
    }
    [answer release];
    
    return answer;

}

@end

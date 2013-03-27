// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBLog.h"
#import "JBStreamHelper.h"


#define BUFFER_SIZE 8*1024

@implementation JBStreamHelper


static NSString* _ERROR_DOMAIN_BROKEN_PIPE = @"jsonbroker.StreamHelper.BROKEN_PIPE";

+(NSString*)ERROR_DOMAIN_BROKEN_PIPE {
    return _ERROR_DOMAIN_BROKEN_PIPE;
}


+(void)closeStream:(NSStream*)stream swallowErrors:(BOOL)swallowErrors caller:(id)caller { 
    
    if( nil == stream ) { 
        return;
    }
    
    @try {
        [stream close];
    }
    @catch (NSException *exception) {
        
        if( swallowErrors ) { 
            Log_warnException( exception );
        } else {
            
            NSString* callerClassName = NSStringFromClass([caller class]);
            
            BaseException* e = [[BaseException alloc] initWithOriginator:[JBStreamHelper class] line:__LINE__ cause:exception];
            [e addStringContext:callerClassName withName:@"callerClassName"];
            [e autorelease];            
            @throw e;
            
        }
    }
    
    
}




@end

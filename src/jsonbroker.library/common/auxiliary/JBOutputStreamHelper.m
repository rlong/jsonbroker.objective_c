// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBLog.h"
#import "JBOutputStreamHelper.h"
#import "JBStreamHelper.h"

@implementation JBOutputStreamHelper

+(long)writeTo:(NSOutputStream*)outputStream buffer:(const uint8_t *)buffer maxLength:(NSUInteger)length {
    
    long answer = [outputStream write:buffer maxLength:length];
    
    // error
    if( 0 > answer ) {
        
        // More information about the error can be obtained with streamError
        NSError* error = [outputStream streamError];
        
        JBBaseException* e = [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSOutputStream write:maxLength:]" failedWithError:error];
        
        if( EPIPE == [error code] ) {
            [e setErrorDomain:[JBStreamHelper ERROR_DOMAIN_BROKEN_PIPE]];
        }
        
        @throw  e;
    }
    
    return answer;
    
    
}

@end

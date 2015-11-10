// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBLog.h"
#import "JBOutputStreamHelper.h"
#import "JBStreamHelper.h"

@implementation JBOutputStreamHelper


+(void)writeTo:(NSOutputStream*)outputStream buffer:(const uint8_t *)buffer bufferLength:(NSUInteger)bufferLength {
    

    NSUInteger bufferRemaining = bufferLength;
    NSUInteger bufferOffset = 0;
    
    while( 0 < bufferRemaining ) {

        long numBytesWritten = [outputStream write:buffer+bufferOffset maxLength:bufferRemaining];
        
        // error
        if( 0 > numBytesWritten ) {
            
            // More information about the error can be obtained with streamError
            NSError* error = [outputStream streamError];
            
            JBBaseException* e = [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSOutputStream write:maxLength:]" failedWithError:error];
            
            if( EPIPE == [error code] ) {
                [e setErrorDomain:[JBStreamHelper ERROR_DOMAIN_BROKEN_PIPE]];
            }
            
            @throw  e;
        }
        
        bufferRemaining -= numBytesWritten;
        bufferOffset += numBytesWritten;
        
        if( 0 < bufferRemaining ) {
            Log_debugInt( bufferRemaining );
        }

    }
}

@end

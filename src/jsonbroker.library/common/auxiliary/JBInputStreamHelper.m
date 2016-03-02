// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBInputStreamHelper.h"
#import "JBLog.h"
#import "JBOutputStreamHelper.h"
#import "JBStreamHelper.h"



#define BUFFER_SIZE 8*1024

@implementation JBInputStreamHelper


+(NSData*)readDataFromStream:(NSInputStream*)inputStream count:(int)count {
    
    return [self readMutableDataFromStream:inputStream count:count];
    
}

+(NSMutableData*)readMutableDataFromStream:(NSInputStream*)inputStream count:(int)count {
    
    NSMutableData* answer = [NSMutableData dataWithLength:count];
    void* mutableBytes = [answer mutableBytes];
    
    long bytesRead = [inputStream read:mutableBytes maxLength:count];
    
    if( 0 > bytesRead ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"0 > bytesRead; bytesRead = %ld", bytesRead];
        @throw  e;
    }
    
    if( bytesRead != count ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"bytesRead != count; bytesRead = %ld; count = %d", bytesRead, count];
        @throw  e;
    }
    
    return answer;
    
}



+(void)seek:(NSInputStream*)inputStream to:(long long)seekPosition {
    
    
    if( 0 == seekPosition ) {
        return;
    }
    
    if( Log_isDebugEnabled() ) {
        Log_debugInt( [[inputStream propertyForKey:NSStreamFileCurrentOffsetKey] longValue] );
    }
    
    
    NSNumber* offset = [NSNumber numberWithLongLong:seekPosition];
    
    bool accepted = [inputStream setProperty:offset forKey:NSStreamFileCurrentOffsetKey];
    
    if( !accepted ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"!accepted; seekPosition = %ld", seekPosition];
        @throw  e;
    }
    
}



+(void)write:(long long)numOctets inputStream:(NSInputStream*)inputStream outputData:(NSMutableData*)outputData {
    
    UInt8 buffer[0x1000];
    while( numOctets > 0 ) { 
        long amountToRead = 0x1000;
        
        if( amountToRead > numOctets ) { 
            amountToRead = (long)numOctets;
        }
        
        long bytesRead = [inputStream read:buffer maxLength:amountToRead];
        if( 0 == bytesRead ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"0 == bytesRead"];
            @throw  e;
        }
        [outputData appendBytes:buffer length:bytesRead];
        numOctets -= bytesRead;
    }
    
}




+(void)writeFrom:(NSInputStream*)inputStream toOutputStream:(NSOutputStream*)outputStream count:(long long)count {
    
    
    uint8_t buffer[BUFFER_SIZE];
    
    
    long long bytesRemaining = count;
    
    while( 0 < bytesRemaining ) {
        
        
        int bytesToRead = BUFFER_SIZE;
        
        if( bytesToRead > bytesRemaining ) {
            bytesToRead = (int)bytesRemaining;
        }
        
        long bytesRead = [inputStream read:buffer maxLength:bytesToRead];
        
        // error
        if( 0 > bytesRead ) {
            
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"0 > bytesRead; bytesRead = %ld; bytesRemaining = %ld", bytesRead, bytesRemaining];
            @throw  e;
            
        }
        if( nil != [inputStream streamError] ) {
            @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSInputStream read:maxLength]" failedWithError:[inputStream streamError]];
        }
        if( 0 == bytesRead && 0 != bytesRemaining ) {
            
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"0 == bytesRead && 0 != bytesRemaining; bytesRemaining = %ld; [inputStream streamStatus] = %d", bytesRemaining, [inputStream streamStatus]];
            @throw  e;
        }
        
        bytesRemaining -= bytesRead;
        
        [JBOutputStreamHelper writeTo:outputStream buffer:buffer bufferLength:bytesRead];
        
    }
}

+(void)writeFrom:(NSInputStream*)inputStream toFileDescriptor:(int)fd count:(long long)count {
    
    
    
    uint8_t buffer[BUFFER_SIZE];
    
    long long bytesRemaining = count;
    
    while( 0 < bytesRemaining ) {
        
        
        int bytesToRead = BUFFER_SIZE;
        
        if( bytesToRead > bytesRemaining ) {
            bytesToRead = (int)bytesRemaining;
        }
        
        long bytesRead = [inputStream read:buffer maxLength:bytesToRead];
        
        // error
        if( 0 > bytesRead ) {
            
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"0 > bytesRead; bytesRead = %ld; bytesRemaining = %ld", bytesRead, bytesRemaining];
            @throw  e;
            
        }
        if( 0 == bytesRead && 0 != bytesRemaining ) {
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"0 == bytesRead && 0 != bytesRemaining; bytesRemaining = %ld", bytesRemaining];
            @throw  e;
        }
        
        
        bytesRemaining -= bytesRead;
        
        long bytesWritten = write( fd, buffer, bytesRead );

        // error
        if( -1 == bytesWritten ) {

            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"write" failedWithErrno:errno];
            
            if( EPIPE == errno ) {
                [e setErrorDomain:[JBStreamHelper ERROR_DOMAIN_BROKEN_PIPE]];
            }
            
            @throw e;

        }
        if( 0 != bytesRead && 0 == bytesWritten ) {
            
            
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"0 != bytesRead && 0 == bytesWritten; bytesRead = %ld; bytesRemaining = %ld", bytesRead, bytesRemaining];
            @throw  e;
        }
    }


}


@end

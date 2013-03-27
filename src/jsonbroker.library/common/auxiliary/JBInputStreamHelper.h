// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>



@interface JBInputStreamHelper : NSObject

+(NSData*)readDataFromStream:(NSInputStream*)inputStream count:(int)count;

+(void)seek:(NSInputStream*)inputStream to:(long long)seekPosition;

+(void)write:(long long)numOctets inputStream:(NSInputStream*)inputStream outputData:(NSMutableData*)outputData;



+(void)writeFrom:(NSInputStream*)inputStream toOutputStream:(NSOutputStream*)outputStream count:(long long)count;

+(void)writeFrom:(NSInputStream*)inputStream toFileDescriptor:(int)fd count:(long long)count;

@end

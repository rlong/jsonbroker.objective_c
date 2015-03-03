// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@interface JBOutputStreamHelper : NSObject

+(void)writeTo:(NSOutputStream*)outputStream buffer:(const uint8_t *)buffer bufferLength:(NSUInteger)bufferLength;

@end

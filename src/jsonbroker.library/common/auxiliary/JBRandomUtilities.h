// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface JBRandomUtilities : NSObject


+(void)random:(UInt8*)bytes length:(int)length;

// returns a string with 16 hex digits
+(NSString*)generateUuid;

@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBJsonObject.h"

@interface JBJsonObjectHelper : NSObject


// can return nil
+(JBJsonObject*)fromFile:(NSString*)path;

+(JBJsonObject*)buildFromData:(NSData*)jsonData;
+(JBJsonObject*)buildFromString:(NSString*)jsonString;


+(void)write:(JBJsonObject*)object toFile:(NSString*)path;
@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


#import "JBJsonArray.h"

@interface JBJsonArrayHelper : NSObject

// can return nil
+(JBJsonArray*)fromFile:(NSString*)path;

+(JBJsonArray*)fromString:(NSString*)input;

+(NSData*)toData:(JBJsonArray*)array;
+(NSString*)toString:(JBJsonArray*)array;

+(void)write:(JBJsonArray*)array toFile:(NSString*)path;


@end

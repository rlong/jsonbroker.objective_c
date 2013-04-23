// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


#import "JBJsonArray.h"

@interface JBJsonArrayHelper : NSObject

+(JBJsonArray*)fromString:(NSString*)input;

+(NSData*)toData:(JBJsonArray*)array;
+(NSString*)toString:(JBJsonArray*)array;


@end

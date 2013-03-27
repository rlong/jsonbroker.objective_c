// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "JBEntity.h"

@interface JBDataHelper : NSObject



+(NSString*)toUtf8String:(NSData*)data;

// DEPRECATED: use [StringHelper toUtf8Data]
+(NSData*)getUtf8Data:(NSString*)input;

+(NSData*)fromEntity:(id<JBEntity>)entity;

@end

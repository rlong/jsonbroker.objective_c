//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@interface JBWebSocketUtilities : NSObject


+(NSString*)buildSecWebSocketAccept:(NSString*)secWebSocketKey;

@end

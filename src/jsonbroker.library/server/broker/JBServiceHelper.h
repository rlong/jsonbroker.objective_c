//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBBaseException.h"
#import "JBBrokerMessage.h"

@interface JBServiceHelper : NSObject

+(BaseException*)methodNotFound:(id)originator request:(JBBrokerMessage*)request;

@end

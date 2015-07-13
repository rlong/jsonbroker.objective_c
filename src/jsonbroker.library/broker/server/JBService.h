//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBrokerMessage.h"

@protocol JBService <NSObject>


-(JBBrokerMessage*)process:(JBBrokerMessage*)request;


@end

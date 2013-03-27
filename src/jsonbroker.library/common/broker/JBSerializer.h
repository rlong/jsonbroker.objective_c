// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBrokerMessage.h"



@interface JBSerializer : NSObject {

}

+(JBBrokerMessage*)deserialize:(NSData*)data;
	
+(NSData*)serialize:(JBBrokerMessage*)message;



@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@class JBIPAddress;


@interface JBNetworkUtilities : NSObject {
    
	
	
}

+(JBIPAddress*)getWifiIpAddress;

// can return nil
+(NSString*)getWifiNetworkName;

@end

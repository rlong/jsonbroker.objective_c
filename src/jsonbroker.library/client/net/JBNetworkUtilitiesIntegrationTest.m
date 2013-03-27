// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBNetworkUtilities.h"
#import "JBNetworkUtilitiesIntegrationTest.h"


#import "JBLog.h"

@implementation JBNetworkUtilitiesIntegrationTest


-(void)testGetWifiIpAddress {

	
	
	JBIPAddress* networkHost = [JBNetworkUtilities getWifiIpAddress];
    
    Log_debugString([networkHost toString]);

	
}



@end

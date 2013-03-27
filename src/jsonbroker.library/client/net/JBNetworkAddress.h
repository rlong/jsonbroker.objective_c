// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBHostName.h"
#import "JBIPAddress.h"
#import "JBNetworkHost.h"
#import "JBNetworkAddress_Generated.h"

@interface JBNetworkAddress : JBNetworkAddress_Generated {
	
	
    JBNetworkHost* _networkHost;
	//@property (nonatomic, retain) NetworkHost* networkHost;
	//@synthesize networkHost = _networkHost;
    
	
}



-(BOOL)isEqualToNetworkAddress:(JBNetworkAddress*)other;


-(JBHostName*)hostName;
-(JBIPAddress*)ipAddress;

-(NSString*)toString;
-(NSString*)label;


#pragma mark -
#pragma mark instance lifecycle


-(id)init;
-(id)initWithIp4Address:(NSString*)ip4Address port:(int)port;
-(id)initWithJsonObject:(JBJsonObject*)network_address;


#pragma mark -
#pragma mark fields

//NetworkHost* _networkHost;
@property (nonatomic, retain) JBNetworkHost* networkHost;
//@synthesize networkHost = _networkHost;



//NSString* _toString;
@property (nonatomic, readonly, getter=toString) NSString* toString;
//@synthesize toString = _toString;


@end

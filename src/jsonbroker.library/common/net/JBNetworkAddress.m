// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBHostName.h"
#import "JBIPAddress.h"
#import "JBJsonObject.h"
#import "JBNetworkAddress.h"
#import "JBNetworkHost.h"
#import "JBObjectTracker.h"

#import "JBLog.h"

@implementation JBNetworkAddress


-(JBHostName*)hostName {
    return [_networkHost hostName];
}

-(JBIPAddress*)ipAddress {
    return [_networkHost ipAddress];
}


-(NSString*)toString {
    
    JBIPAddress* ipAddress = [_networkHost ipAddress];
	
	return [NSString stringWithFormat:@"%@:%d", [ipAddress toString], _port];
	
}




-(NSString*)label {
	
    JBHostName* hostName = [_networkHost hostName];
	NSString* answer = [hostName toString];
	if( nil == answer ) {
        JBIPAddress* ipAddress = [_networkHost ipAddress];
		answer = [ipAddress toString];
	}
	return answer;
	
}



-(BOOL)isEqualToNetworkAddress:(JBNetworkAddress*)other {
	
	if( other == self ) {
		return YES;
	}
	
	if( nil == other ) { 
		return NO;
	}
	
	if( _port != [other port] ) {
		return NO;
	}
    
    return [_networkHost isEqualToNetworkHost:[other networkHost]];
	
	
}

-(JBJsonObject*)toJsonObject {

    JBJsonObject* answer = [super toJsonObject];
	
    [answer setObject:[_networkHost toJSONObject] forKey:@"network_host"];
	
	return answer;
}

#pragma mark -
#pragma mark instance lifecycle

-(id)init {
	
	JBNetworkAddress* answer = [super init];
	
	
	[JBObjectTracker allocated:answer];
	
    answer->_networkHost = [[JBNetworkHost alloc] init];
	
	return answer;
}


-(id)initWithIp4Address:(NSString*)ip4Address port:(int)port { 

	JBNetworkAddress* answer = [super init];	
	
	[JBObjectTracker allocated:answer];
	
    answer->_networkHost = [[JBNetworkHost alloc] init];
    [[answer ipAddress] setIp4AddressWithString:ip4Address];
    [answer setPort:port];
	
	return answer;
}

-(id)initWithJsonObject:(JBJsonObject*)network_address {
    
	JBNetworkAddress* answer = [super initWithJsonObject:network_address];
	
	[JBObjectTracker allocated:answer];
	
    JBJsonObject* network_host = [network_address jsonObjectForKey:@"network_host"];
    answer->_networkHost = [[JBNetworkHost alloc] initWithJsonObject:network_host];
	
	return answer;
    

}


-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
    [self setNetworkHost:nil];
    [self setExtension:nil];

	
	[super dealloc];
}

#pragma mark -
#pragma mark fields


//NetworkHost* _networkHost;
//@property (nonatomic, retain) NetworkHost* networkHost;
@synthesize networkHost = _networkHost;

// extension
//id _extension;
//@property (nonatomic, retain) id extension;
@synthesize extension = _extension;



@end

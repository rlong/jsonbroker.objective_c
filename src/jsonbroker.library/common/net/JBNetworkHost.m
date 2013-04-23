// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBNetworkHost.h"
#import "JBObjectTracker.h"

@implementation JBNetworkHost



-(BOOL)isEqualToNetworkHost:(JBNetworkHost*)other {
	
	if( other == self ) {
		return YES;
	}
	
	if( nil == other ) { 
		return NO;
	}
	
	
	if( [_ipAddress ip4Address] != [[other ipAddress] ip4Address] ) {
		return NO;
	}
	
	
	NSString* hostName = [_hostName toString];
	NSString* otherHostName = [[other hostName] toString];
	if( nil == hostName ) {
		if( nil != otherHostName ) {
			return NO;
		}
	} else {
		if( ! [hostName isEqualToString:otherHostName] ) {
			return NO;
		}
	}
	
	// ip address, hostName all match ... 
	return YES;
	
}


-(JBJsonObject*)toJSONObject {
	
    JBJsonObject* answer = [_hostName toJsonObject];
    
    [answer setObject:[_ipAddress toJSONArray] forKey:@"inet_address"];
    
	return answer;
	
	
}


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
	
	JBNetworkHost* answer = [super init];
	
	
	[JBObjectTracker allocated:answer];
	
	answer->_ipAddress = [[JBIPAddress alloc] init];
	answer->_hostName = [[JBHostName alloc] init];
	
	return answer;
}

-(id)initWithJsonObject:(JBJsonObject*)network_host {
    
    JBNetworkHost* answer = [super init];
    
	[JBObjectTracker allocated:answer];
	
    JBJsonArray* inet_address = [network_host jsonArrayForKey:@"inet_address"];
	answer->_ipAddress = [[JBIPAddress alloc] initWithJsonArray:inet_address];
	answer->_hostName = [[JBHostName alloc] initWithJsonObject:network_host];

	return answer;

}

-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	
	[self setIpAddress:nil];
	[self setHostName:nil];
	
	[super dealloc];
}


#pragma mark -
#pragma fields

//IPAddress* _ipAddress;
//@property (nonatomic, retain) IPAddress* ipAddress;
@synthesize ipAddress = _ipAddress;

//HostName* _hostName;
//@property (nonatomic, retain) HostName* hostName;
@synthesize hostName = _hostName;

@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@class JBHostName;
@class JBIPAddress;

@interface JBNetworkHost : NSObject {
    
    JBIPAddress* _ipAddress;
    //@property (nonatomic, retain) IPAddress* ipAddress;
    //@synthesize ipAddress = _ipAddress;
    
    JBHostName* _hostName;
	//@property (nonatomic, retain) HostName* hostName;
	//@synthesize hostName = _hostName;

}


-(BOOL)isEqualToNetworkHost:(JBNetworkHost*)other;


-(JBJsonObject*)toJSONObject;

#pragma mark instance lifecycle

-(id)init;

-(id)initWithJsonObject:(JBJsonObject*)network_host;


#pragma fields


//IPAddress* _ipAddress;
@property (nonatomic, retain) JBIPAddress* ipAddress;
//@synthesize ipAddress = _ipAddress;

//HostName* _hostName;
@property (nonatomic, retain) JBHostName* hostName;
//@synthesize hostName = _hostName;


@end

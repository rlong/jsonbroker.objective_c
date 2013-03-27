// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJsonObject.h"


@interface JBNetworkAddress_Generated  : NSObject {
    
    
	// port
	int _port;
	//@property (nonatomic, assign) int port;
	//@synthesize port = _port;
    
}

-(JBJsonObject*)toJsonObject;

#pragma mark -
#pragma mark instance lifecycle

-(id)init;
-(id)initWithJsonObject:(JBJsonObject*)jsonObject;

#pragma mark -
#pragma mark fields

// port
//int _port;
@property (nonatomic, assign) int port;
//@synthesize port = _port;

@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJsonObject.h"
#import "JBNetworkAddress_Generated.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBNetworkAddress_Generated ()

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation JBNetworkAddress_Generated 


-(JBJsonObject*)toJsonObject {
	JBJsonObject* answer = [[JBJsonObject alloc] init];
	[answer setInt:_port forKey:@"port"];
	return answer;
    
}

#pragma mark -
#pragma mark instance lifecycle

-(id)init {
	return [super init];
}

-(id)initWithJsonObject:(JBJsonObject*)jsonObject {
	
	JBNetworkAddress_Generated* answer = [super init];
	
	[answer setPort:[jsonObject intForKey:@"port"]];
	
	return answer;
	
}


-(void)dealloc {
    
    
    
}


#pragma mark -
#pragma mark fields


//////////////////////////////////////////////////////
// port
//int _port;
//@property (nonatomic, assign) int port;
@synthesize port = _port;

@end

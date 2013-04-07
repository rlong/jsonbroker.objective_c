// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBIPAddress.h"
#import "JBLog.h"

static const uint32_t loopbackIp4Address = (1 << 24) + 127;

@implementation JBIPAddress


+(JBIPAddress*)localhost {
	
	
	JBIPAddress* answer = [[JBIPAddress alloc] initWithAddress:loopbackIp4Address];
	[answer autorelease];
	
	return answer;
	
}

-(BOOL)isLocalhost {
	
	if( loopbackIp4Address == _ip4Address ) {
		return YES;
	}	
	return NO;
}



-(void)setIp4Address:(in_addr_t) ip4Address {
	_ip4Address = ip4Address;
	
	if( nil != _toString ) {
		[_toString release];
	}
	
	int ip1 = _ip4Address & 0xFF;
	int ip2 = ( _ip4Address >> 8 ) & 0xFF;
	int ip3 = ( _ip4Address >> 16 ) & 0xFF;
	int ip4 = ( _ip4Address >> 24 ) & 0xFF;
	
	//TODO: inet_ntoa
	_toString = [[NSString stringWithFormat:@"%d.%d.%d.%d", ip1, ip2, ip3, ip4 ] retain];
	
	
}

-(void)setIp4AddressWithString:(NSString*)ip4Address {
	
	const char* utf8Ip4Address = [ip4Address UTF8String];
	int a,b,c,d;
	sscanf(utf8Ip4Address, "%d.%d.%d.%d", &a, &b, &c, &d );
	
	_ip4Address = d;
	_ip4Address <<= 8;
	
	_ip4Address |= c;
	_ip4Address <<= 8;  
	
	_ip4Address |= b;
	_ip4Address <<= 8;

	_ip4Address |= a;
	
	_toString = [ip4Address retain];
	
	Log_debugString(_toString );
	

}


-(JBJsonArray*)toJSONArray {

	JBJsonArray* answer = [[JBJsonArray alloc] initWithCapacity:4];
	[answer autorelease];

	NSNumber* a = [NSNumber numberWithInt:_ip4Address & 0xFF];
	NSNumber* b = [NSNumber numberWithInt:( _ip4Address >> 8 ) & 0xFF];
	NSNumber* c = [NSNumber numberWithInt:( _ip4Address >> 16 ) & 0xFF];
	NSNumber* d = [NSNumber numberWithInt:( _ip4Address >> 24 ) & 0xFF];
	
	[answer add:a]; // LSB
	[answer add:b]; 
	[answer add:c]; 
	[answer add:d]; // MSB

	return answer;
	
	
}


#pragma mark instance lifecycle


-(id)initWithAddress:(in_addr_t)ip4Address {
	id answer = [super init];
	
	[self setIp4Address:ip4Address];
	
	return answer;
}

-(id)initWithJsonArray:(JBJsonArray*)jsonArray {
    
    
    int a = [jsonArray getInt:0];
    int b = [jsonArray getInt:1];
    int c = [jsonArray getInt:2];
    int d = [jsonArray getInt:3];
    
    in_addr_t ip4Address = d;
    ip4Address <<= 8;
	
	ip4Address |= c;
	ip4Address <<= 8;
	
	ip4Address |= b;
	ip4Address <<= 8;
    
	ip4Address |= a;

	id answer = [super init];
	
	[self setIp4Address:ip4Address];
	
	return answer;

}

-(void)dealloc {
	
	if( nil != _toString ) {
		[_toString release];
		_toString = nil;
	}
	
	[super dealloc];
}

#pragma mark fields


//in_addr_t _ip4Address; 
//@property (nonatomic, setter=setIp4Address:)in_addr_t ip4Address;
@synthesize ip4Address = _ip4Address;

//NSString* _toString;
//@property (nonatomic, readonly) NSString* toString;
@synthesize toString = _toString;


@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#include <sys/socket.h>
#include <netdb.h>


#import "JBNetworkAddress.h"
#import "JBGethostbyaddrRequest.h"
#import "JBGethostbyaddrRequestIntegrationTest.h"
#import "JBLog.h"


@implementation JBGethostbyaddrRequestIntegrationTest



-(void)dumpAddrinfo:(struct addrinfo*)info {
    Log_debugPointer(info);
    Log_debugInt(info->ai_flags);
	
	if( PF_LOCAL == info->ai_family ) {
        Log_debug(@"PF_LOCAL == info->ai_family");
	} else 	if( PF_UNIX == info->ai_family ) {
		Log_debug(@"PF_UNIX == info->ai_family");
	} else 	if( PF_INET == info->ai_family ) {
		Log_debug(@"PF_INET == info->ai_family");
	} else 	if( PF_ROUTE == info->ai_family ) {
		Log_debug(@"PF_ROUTE == info->ai_family");
	} else 	if( PF_KEY == info->ai_family ) {
		Log_debug(@"PF_KEY == info->ai_family");
	} else 	if( PF_INET6 == info->ai_family ) {
		Log_debug(@"PF_INET6 == info->ai_family");
	} else 	if( PF_SYSTEM == info->ai_family ) {
		Log_debug(@"PF_SYSTEM == info->ai_family");
	} else 	if( PF_NDRV == info->ai_family ) {
		Log_debug(@"PF_NDRV == info->ai_family");
	} else {
	}
    
    Log_debugInt(info->ai_family);
    Log_debugInt(info->ai_socktype);
    Log_debugInt(info->ai_protocol);
    Log_debugInt(info->ai_addrlen);
    Log_debugInt(info->ai_addr->sa_len);
    Log_debugInt(info->ai_addr->sa_family);
	
	
	NSString* sa_data = [NSString stringWithCString:info->ai_addr->sa_data encoding:NSUTF8StringEncoding];
    Log_debugString(sa_data);
	
	struct sockaddr_in* sin = (struct sockaddr_in *) info->ai_addr;
	uint32_t ip4Address = sin->sin_addr.s_addr;
    Log_debugInt( ip4Address);
    Log_debugInt( ip4Address&0xFF);
	
	

}

-(void)testGetaddrinfo {
	
	// derived from the man page for getaddrinfo ... 	
	struct addrinfo hints, *res, *res0;
	int error;
	int s;
	
	memset(&hints, 0, sizeof(hints));
	
	hints.ai_family = PF_INET;
	hints.ai_socktype = SOCK_STREAM;
	
	error = getaddrinfo("localhost", NULL, &hints, &res0);
	
	if (error) {
		
        Log_warnFormat(@"error = %d; gai_strerror(error) = '%s'", error, gai_strerror(error));
		return;
	}
	
	
	s = -1;
	for (res = res0; res; res = res->ai_next) {
		
		[self dumpAddrinfo:res];
		
	}
	freeaddrinfo(res0);
	
}

-(void)testBitShifting {
	uint32_t x = 0xFFFF0000;
	XCTAssertTrue( 0 == (x & 0xFF), @"" );
	XCTAssertTrue( 0 == ((x >> 8) & 0xFF), @"" );
	XCTAssertTrue( 0xFF == ((x >> 16) & 0xFF), @"" );
	XCTAssertTrue( 0xFF == ((x >> 24) & 0xFF), @"" );
	XCTAssertTrue( 0x1 == ((x >> 31) & 0xFF), @"" );
}


-(uint32_t)getByte:(int)byteNumber fromAddress:(JBIPAddress*)ipAddress {
	
	
	int shift = byteNumber * 8;
	
	return ( ([ipAddress ip4Address] >> shift ) & 0xFF );
}


-(void)testLocalhostByName {
	
	JBIPAddress* ipAddress = [[JBIPAddress alloc] init];
	JBGethostbyaddrRequest* gethostbyaddrRequest = [[JBGethostbyaddrRequest alloc] initWithDnsName:@"localhost" ipAddress:ipAddress];
	[gethostbyaddrRequest asyncExecute];
	
	
	XCTAssertTrue( 127 == [self getByte:0 fromAddress:ipAddress], @"actual = %d", [self getByte:0 fromAddress:ipAddress] );
	XCTAssertTrue( 0 == [self getByte:1 fromAddress:ipAddress], @"actual = %d", [self getByte:1 fromAddress:ipAddress] );
	XCTAssertTrue( 0 == [self getByte:2 fromAddress:ipAddress], @"actual = %d", [self getByte:2 fromAddress:ipAddress] );
	XCTAssertTrue( 1 == [self getByte:3 fromAddress:ipAddress], @"actual = %d", [self getByte:3 fromAddress:ipAddress] );
}

-(void)testLocalhostByAddress {

	JBIPAddress* ipAddress = [[JBIPAddress alloc] init];	
	JBGethostbyaddrRequest* gethostbyaddrRequest = [[JBGethostbyaddrRequest alloc] initWithDnsName:@"127.0.0.1" ipAddress:ipAddress];
	[gethostbyaddrRequest asyncExecute];
	
	XCTAssertTrue( 127 == [self getByte:0 fromAddress:ipAddress], @"" );
	XCTAssertTrue( 0 == [self getByte:1 fromAddress:ipAddress], @"" );
	XCTAssertTrue( 0 == [self getByte:2 fromAddress:ipAddress], @"" );
	XCTAssertTrue( 1 == [self getByte:3 fromAddress:ipAddress], @"" );
}

-(void)testBigHostByAddress {
	
	JBIPAddress* ipAddress = [[JBIPAddress alloc] init];	
	JBGethostbyaddrRequest* gethostbyaddrRequest = [[JBGethostbyaddrRequest alloc] initWithDnsName:@"255.1.2.3" ipAddress:ipAddress];
	[gethostbyaddrRequest asyncExecute];
	
	XCTAssertTrue( 255 == [self getByte:0 fromAddress:ipAddress], @"actual = %d", [self getByte:0 fromAddress:ipAddress] );
	XCTAssertTrue( 1 == [self getByte:1 fromAddress:ipAddress], @"actual = %d", [self getByte:1 fromAddress:ipAddress] );
	XCTAssertTrue( 2 == [self getByte:2 fromAddress:ipAddress], @"actual = %d", [self getByte:2 fromAddress:ipAddress] );
	XCTAssertTrue( 3 == [self getByte:3 fromAddress:ipAddress], @"actual = %d", [self getByte:3 fromAddress:ipAddress] );
}

-(void)testEtcHosts {
	
	JBIPAddress* ipAddress = [[JBIPAddress alloc] init];	
	JBGethostbyaddrRequest* gethostbyaddrRequest = [[JBGethostbyaddrRequest alloc] initWithDnsName:@"hal.vmnet8" ipAddress:ipAddress];
	[gethostbyaddrRequest asyncExecute];
	
	XCTAssertTrue( 172 == [self getByte:0 fromAddress:ipAddress], @"[self getByte:0 fromAddress:networkHost] = %d", [self getByte:0 fromAddress:ipAddress] );
	XCTAssertTrue( 16 == [self getByte:1 fromAddress:ipAddress], @"" );
	XCTAssertTrue( 74 == [self getByte:2 fromAddress:ipAddress], @"" );
	XCTAssertTrue( 1 == [self getByte:3 fromAddress:ipAddress], @"" );
}


@end

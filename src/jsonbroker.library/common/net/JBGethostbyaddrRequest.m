// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#include <sys/socket.h>
#include <netdb.h>


#import "JBGethostbyaddrRequest.h"
#import "JBLog.h"
#import "JBTimeUtilities.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBGethostbyaddrRequest () 

//NSString* _dnsName; 
@property (nonatomic, retain) NSString* dnsName;
//@synthesize dnsName = _dnsName;

//IPAddress* _ipAddress; 
@property (nonatomic, retain) JBIPAddress* ipAddress;
//@synthesize ipAddress = _ipAddress;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation JBGethostbyaddrRequest


-(void)postSuccessNotification {
	
	Log_enteredMethod();
	
	[[NSNotificationCenter defaultCenter] postNotificationName:GethostbyaddrRequest_GethostbyaddrCompleted_Notification object:self];

}

-(void)execute {
	
	
	[self setState:kGethostbyaddrRequestRunning];

	
	struct timeval start;
	[JBTimeUtilities getTime:&start];

	
	struct addrinfo hints, *res0;
	int error;
	
	res0 = 0;

	/*
	 * setup the hints 
	 */
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = PF_INET;
	hints.ai_socktype = SOCK_STREAM;
	
	Log_debugString(_dnsName );

	const char* addr = [_dnsName cStringUsingEncoding:NSUTF8StringEncoding];
	error = getaddrinfo(addr, NULL, &hints, &res0);
	
	@try {
		if (error) {
			NSString* errorMessage = [NSString stringWithCString:gai_strerror(error) encoding:NSUTF8StringEncoding];
			[self setErrorMessage:errorMessage];
            Log_warn( errorMessage );
			[self setState:kGethostbyaddrRequestFailed];
			
			return;
		}
		struct sockaddr_in* ai_addr = (struct sockaddr_in *) res0->ai_addr;
		in_addr_t s_addr = ai_addr->sin_addr.s_addr;

		[_ipAddress setIp4Address:s_addr];
		
		int ip1 = s_addr & 0xFF;
		int ip2 = ( s_addr >> 8 ) & 0xFF;
		int ip3 = ( s_addr >> 16 ) & 0xFF;
		int ip4 = ( s_addr >> 24 ) & 0xFF;
		
		NSString* ip4Name = [NSString stringWithFormat:@"%d.%d.%d.%d", ip1, ip2, ip3, ip4 ];
        Log_infoString( ip4Name);
		
		
		[self setState:kGethostbyaddrRequestCompleted];

		[self performSelectorOnMainThread:@selector(postSuccessNotification) withObject:self waitUntilDone:NO];
		
		
	}
	@finally {
		if (0 != res0 ) {
			freeaddrinfo( res0 );
		}
		long elapsedTime = [JBTimeUtilities getElapsedTimeSince:&start];
        Log_infoInt( elapsedTime );

	}
	
}

-(void)threadMain:(NSObject*)ignoredObject {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	NSString* threadName = [NSString stringWithFormat:@"GethostbyaddrRequest.%@", _dnsName];
	[[NSThread currentThread] setName:threadName];
	
    Log_debug(@"Starting ... ");
	
	[self execute];
	
    Log_debug(@"... Finished");
	
    [pool release];

}


-(void)asyncExecute {
	
    [NSThread detachNewThreadSelector:@selector(threadMain:) toTarget:self withObject:nil];	
	
}




-(id)initWithDnsName:(NSString*)dnsName ipAddress:(JBIPAddress*)ipAddress {
	
	id answer = [super init];
	
	[self setState:kGethostbyaddrRequestNotRunning];
	
	[self setDnsName:dnsName];
	[self setIpAddress:ipAddress];
	
	return answer;
}


-(void)dealloc {
	
	[self setDnsName:nil];
	[self setIpAddress:nil];
	
	[self setErrorMessage:nil];
	
	[super dealloc];
}

#pragma mark fields

//NSString* _dnsName; 
//@property (nonatomic, retain) NSString* dnsName;
@synthesize dnsName = _dnsName;

//IPAddress* _ipAddress; 
//@property (nonatomic, retain) IPAddress* ipAddress;
@synthesize ipAddress = _ipAddress;

//NSString* _errorMessage;
//@property (nonatomic, retain) NSString* errorMessage;
@synthesize errorMessage = _errorMessage;

//enum GethostbyaddrRequestState _state;
//@property (nonatomic) enum GethostbyaddrRequestState state;
@synthesize state = _state;



@end


// vvv see CAGethostbyaddrRequest.m
// NSString* const GethostbyaddrRequest_GethostbyaddrCompleted_Notification = @"GethostbyaddrRequest_GethostbyaddrCompleted_Notification";
// ^^^ see CAGethostbyaddrRequest.m


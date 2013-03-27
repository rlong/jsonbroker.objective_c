// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <ifaddrs.h>
#import <sys/socket.h>
#include <arpa/inet.h> 

#import "JBBaseException.h"
#import "JBLog.h"
#import "JBNetworkUtilities.h"
#import "JBTimeUtilities.h"

@implementation JBNetworkUtilities


static bool _loggedDeviceType = false;



+(JBIPAddress*)getWifiIpAddress {	
	
	struct ifaddrs* interfaces = NULL;
	struct ifaddrs* addressIterator = NULL;
	struct ifaddrs* en0 = NULL;
	struct ifaddrs* en1 = NULL;
	
	int success = 0;
	
	// find the network adapters ... 
	
	success = getifaddrs(&interfaces); // retrieve the current interfaces - returns 0 on success
	if (success == 0)
	{
		// Loop through linked list of interfaces
		addressIterator = interfaces;
		while(addressIterator != NULL)
		{
			if(addressIterator->ifa_addr->sa_family == AF_INET)
			{
				if( 0 == strcmp( "en0", addressIterator->ifa_name ) ) {
					en0 = addressIterator;
				} else if ( 0 == strcmp( "en1", addressIterator->ifa_name ) ) {
					en1 = addressIterator;
				}
			}
			
			addressIterator = addressIterator->ifa_next;
		}
	} else {
		NSString* technicalError = [NSString stringWithFormat:@"%s (errno = %d)", strerror(errno), errno];
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        
		[e addIntContext:success withName:@"success"];
		[e autorelease];
		
		freeifaddrs(interfaces); // free up the memory ... 
		@throw e;
	}
	
	// find the WIFI adapter  from the available network adapters ... 
	
	struct ifaddrs* wifi = NULL;
	if( NULL != en1 ) {

        if( !_loggedDeviceType ) {
            Log_debug( @"NULL != en1. running on OSX");
            _loggedDeviceType = true;
        }
        
		wifi = en1;
	} else if ( NULL != en0 ) {
        
        if( !_loggedDeviceType ) {
            Log_debug( @"NULL == en1 && NULL != en0. running on iOS device" );
            _loggedDeviceType = true;
        }
        
		wifi = en0;
        
	} else { // both are NULL ... no WIFI ? WTF !
        
        Log_warn( @"NULL == en1 && NULL != en0. WiFi is not active" );
		
		JBIPAddress* answer = [JBIPAddress localhost];
		
		freeifaddrs(interfaces); // free up the memory ... 
		return answer;
		
        
	}
	
	// shunt the ip address into the parameter to this method
	
	struct sockaddr_in *sockAddrIn = (struct sockaddr_in *)wifi->ifa_addr;
	struct in_addr sin_addr = sockAddrIn->sin_addr;
    
	JBIPAddress* answer = [[JBIPAddress alloc] initWithAddress:sin_addr.s_addr];
	[answer autorelease];
	
	freeifaddrs(interfaces);
	
	return answer;
	
	
	
	
}


@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBHostName.h"
#import "JBObjectTracker.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBHostName () 

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation JBHostName

-(NSString*)toString {

	
	if( nil != [self applicationName] ) {
		return [self applicationName];
	}
	
	if( nil != [self zeroconfName] ) {
		return [self zeroconfName];
	}
	
	if( nil != [self dnsName] ) {
		return [self dnsName];
	}
	
	return nil;
	
}



#pragma mark instance lifecycle


-(void)dealloc {
	
	[super dealloc];
	
}



#pragma mark fields



@end

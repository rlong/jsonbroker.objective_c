// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBJsonObject.h"


@interface JBHostName_Generated  : NSObject {
    
    
	//////////////////////////////////////////////////////
	// applicationName
	NSString* _applicationName;
	//@property (nonatomic, retain) NSString* applicationName;
	//@synthesize applicationName = _applicationName;
    
	//////////////////////////////////////////////////////
	// zeroconfName
	NSString* _zeroconfName;
	//@property (nonatomic, retain) NSString* zeroconfName;
	//@synthesize zeroconfName = _zeroconfName;
    
	//////////////////////////////////////////////////////
	// dnsName
	NSString* _dnsName;
	//@property (nonatomic, retain) NSString* dnsName;
	//@synthesize dnsName = _dnsName;
    
}

-(JBJsonObject*)toJsonObject;

#pragma mark -
#pragma mark instance lifecycle

-(id)init;
-(id)initWithJsonObject:(JBJsonObject*)jsonObject;

#pragma mark -
#pragma mark fields

// applicationName
//NSString* _applicationName;
@property (nonatomic, retain) NSString* applicationName;
//@synthesize applicationName = _applicationName;

// zeroconfName
//NSString* _zeroconfName;
@property (nonatomic, retain) NSString* zeroconfName;
//@synthesize zeroconfName = _zeroconfName;

// dnsName
//NSString* _dnsName;
@property (nonatomic, retain) NSString* dnsName;
//@synthesize dnsName = _dnsName;

@end

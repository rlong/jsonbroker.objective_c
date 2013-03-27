// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBIPAddress.h"

enum GethostbyaddrRequestState { kGethostbyaddrRequestNotRunning, kGethostbyaddrRequestRunning, kGethostbyaddrRequestFailed, kGethostbyaddrRequestCompleted };


@interface JBGethostbyaddrRequest : NSObject {
	
	NSString* _dnsName; 
	//@property (nonatomic, retain) NSString* dnsName;
	//@synthesize dnsName = _dnsName;
	
	JBIPAddress* _ipAddress; 
	//@property (nonatomic, retain) IPAddress* ipAddress;
	//@synthesize ipAddress = _ipAddress;
	
	
	NSString* _errorMessage;
	//@property (nonatomic, retain) NSString* errorMessage;
	//@synthesize errorMessage = _errorMessage;
	
	
	enum GethostbyaddrRequestState _state;
	//@property (nonatomic) enum GethostbyaddrRequestState state;
	//@synthesize state = _state;
	
}


-(void)asyncExecute;


-(id)initWithDnsName:(NSString*)dnsName ipAddress:(JBIPAddress*)ipAddress;


#pragma mark fields

//NSString* _errorMessage;
@property (nonatomic, retain) NSString* errorMessage;
//@synthesize errorMessage = _errorMessage;

//enum GethostbyaddrRequestState _state;
@property (nonatomic) enum GethostbyaddrRequestState state;
//@synthesize state = _state;


@end


extern NSString* const GethostbyaddrRequest_GethostbyaddrCompleted_Notification;




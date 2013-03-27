//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJsonObject.h"
#import "JBNotificationPoster.h"
#import "JBObjectTracker.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBNotificationPoster () 

//id<CallbackAdapter> _callbackAdapter;
@property (nonatomic, retain) id<JBJavascriptCallbackAdapter> callbackAdapter;
//@synthesize callbackAdapter = _callbackAdapter;

//JSONObject* _metaInformation;
@property (nonatomic, retain) JBJsonObject* metaInformation;
//@synthesize metaInformation = _metaInformation;


//NSString* _serviceName;
@property (nonatomic, retain) NSString* serviceName;
//@synthesize serviceName = _serviceName;




@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBNotificationPoster

-(void)postNotificationName:(NSString*)notificationName associativeParamaters:(JBJsonObject*)associativeParamaters {
	
	
	JBBrokerMessage* notification = [[JBBrokerMessage alloc] init];
	[notification autorelease];
	
	[notification setMessageType:[JBBrokerMessageType notification]];
	
	[notification setServiceName:_serviceName];
	
	[notification setMethodName:notificationName];

	if( nil == associativeParamaters ) { 
		associativeParamaters = [[JBJsonObject alloc] init];
		[associativeParamaters autorelease];
	}
	
	[notification setAssociativeParamaters:associativeParamaters];
	
	[_callbackAdapter onNotification:notification];
	
	
	
}

#pragma mark instance lifecycle 

-(id)initWithCallbackAdapter:(id<JBJavascriptCallbackAdapter>)callbackAdapter serviceName:(NSString*)serviceName metaInformation:(JBJsonObject*)metaInformation {
	
	JBNotificationPoster* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	[answer setCallbackAdapter:callbackAdapter];
	[answer setServiceName:serviceName];
	[answer setMetaInformation:metaInformation];
	
	return answer;
	
}

-(void)dealloc { 
	
	[JBObjectTracker deallocated:self];
	
	
	[self setCallbackAdapter:nil];
	[self setMetaInformation:nil];
	[self setServiceName:nil];
	
	[super dealloc];
	
}

#pragma mark fields


//id<CallbackAdapter> _callbackAdapter;
//@property (nonatomic, retain) id<CallbackAdapter> callbackAdapter;
@synthesize callbackAdapter = _callbackAdapter;


//JSONObject* _metaInformation;
//@property (nonatomic, retain) JSONObject* metaInformation;
@synthesize metaInformation = _metaInformation;


//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;


@end

//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBNotificationPoster2.h"
#import "JBObjectTracker.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBNotificationPoster2 () 

//id<CallbackAdapter> _callbackAdapter;
@property (nonatomic, retain) id<JBJavascriptCallbackAdapter> callbackAdapter;
//@synthesize callbackAdapter = _callbackAdapter;

//NSString* _serviceName;
@property (nonatomic, retain) NSString* serviceName;
//@synthesize serviceName = _serviceName;

//NSString* _methodName;
@property (nonatomic, retain) NSString* methodName;
//@synthesize methodName = _methodName;




@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBNotificationPoster2



-(void)postNotificationWithAssociativeParamaters:(JBJsonObject*)associativeParamaters {
    
    JBBrokerMessage* notification = [[JBBrokerMessage alloc] init];
	[notification autorelease];
	
	[notification setMessageType:[JBBrokerMessageType notification]];
	
	[notification setServiceName:_serviceName];
	
	[notification setMethodName:_methodName];
    
	[notification setAssociativeParamaters:associativeParamaters];
	
	[_callbackAdapter onNotification:notification];

}


#pragma mark instance lifecycle 

-(id)initWithCallbackAdapter:(id<JBJavascriptCallbackAdapter>)callbackAdapter serviceName:(NSString*)serviceName methodName:(NSString*)methodName {
	
	JBNotificationPoster2* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	[answer setCallbackAdapter:callbackAdapter];
	[answer setServiceName:serviceName];
    [answer setMethodName:methodName];
	
	return answer;
	
}

-(void)dealloc { 
	
	[JBObjectTracker deallocated:self];
	
	
	[self setCallbackAdapter:nil];
	[self setServiceName:nil];
    [self setMethodName:nil];
	
	[super dealloc];
	
}



#pragma mark fields


//id<CallbackAdapter> _callbackAdapter;
//@property (nonatomic, retain) id<CallbackAdapter> callbackAdapter;
@synthesize callbackAdapter = _callbackAdapter;

//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;

//NSString* _methodName;
//@property (nonatomic, retain) NSString* methodName;
@synthesize methodName = _methodName;

@end

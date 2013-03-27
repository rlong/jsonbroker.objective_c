//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJavascriptCallbackAdapter.h"
#import "JBJsonObject.h"

@interface JBNotificationPoster : NSObject {

	
	id<JBJavascriptCallbackAdapter> _callbackAdapter;
	//@property (nonatomic, retain) id<CallbackAdapter> callbackAdapter;
	//@synthesize callbackAdapter = _callbackAdapter;
	
	JBJsonObject* _metaInformation;
	//@property (nonatomic, retain) JSONObject* metaInformation;
	//@synthesize metaInformation = _metaInformation;
	
	NSString* _serviceName;
	//@property (nonatomic, retain) NSString* serviceName;
	//@synthesize serviceName = _serviceName;
	
	
}

-(void)postNotificationName:(NSString*)notificationName associativeParamaters:(JBJsonObject*)associativeParamaters;

#pragma mark instance lifecycle 


-(id)initWithCallbackAdapter:(id<JBJavascriptCallbackAdapter>)callbackAdapter serviceName:(NSString*)serviceName metaInformation:(JBJsonObject*)metaInformation;


@end


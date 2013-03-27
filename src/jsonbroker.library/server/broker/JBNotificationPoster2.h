//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJavascriptCallbackAdapter.h"

@interface JBNotificationPoster2 : NSObject {

    id<JBJavascriptCallbackAdapter> _callbackAdapter;
    //@property (nonatomic, retain) id<CallbackAdapter> callbackAdapter;
    //@synthesize callbackAdapter = _callbackAdapter;
    
    NSString* _serviceName;
	//@property (nonatomic, retain) NSString* serviceName;
	//@synthesize serviceName = _serviceName;

    NSString* _methodName;
	//@property (nonatomic, retain) NSString* methodName;
	//@synthesize methodName = _methodName;


}


-(void)postNotificationWithAssociativeParamaters:(JBJsonObject*)associativeParamaters;

#pragma mark instance lifecycle 

-(id)initWithCallbackAdapter:(id<JBJavascriptCallbackAdapter>)callbackAdapter serviceName:(NSString*)serviceName methodName:(NSString*)methodName;

@end

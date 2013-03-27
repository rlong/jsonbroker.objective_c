//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBBrokerMessage.h"

@interface JBJavascriptCallbackAdapterHelper : NSObject {

}

+(NSString*)buildJavascriptFault:(JBBrokerMessage*)request fault:(NSException*)fault;
+(NSString*)buildJavascriptNotification:(JBBrokerMessage*)notification;
+(NSString*)buildJavascriptResponse:(JBBrokerMessage*)response;
+(NSString*)buildJavascriptForwardRequest:(JBBrokerMessage*)request;





@end

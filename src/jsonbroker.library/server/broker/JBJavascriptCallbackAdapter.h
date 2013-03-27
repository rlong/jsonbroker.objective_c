//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBBrokerMessage.h"


@protocol JBJavascriptCallbackAdapter 
	
	-(void)onFault:(NSException*)fault request:(JBBrokerMessage*)request;
	
	
	-(void)onNotification:(JBBrokerMessage*)notification;
	
	
	-(void)onResponse:(JBBrokerMessage*)response;
	

@end



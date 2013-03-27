//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//
#import "JBJavascriptCallbackAdapterHelper.h"
#import "JBFaultSerializer.h"
#import "JBJsonObjectHandler.h"
#import "JBJsonStringOutput.h"


@implementation JBJavascriptCallbackAdapterHelper




+(NSString*)buildJavascriptFault:(JBBrokerMessage*)request fault:(NSException*)fault {
	
	
	JBJsonStringOutput* jsonWriter = [[JBJsonStringOutput alloc] init];
	
	[jsonWriter appendString:@"jsonbroker.forwardFault(\"fault\","];
	
	JBJsonObjectHandler* jsonObjectHandler = [JBJsonObjectHandler getInstance];
	[jsonObjectHandler writeValue:[request metaData] writer:jsonWriter];
	
	[jsonWriter appendString:@",\""];
	[jsonWriter appendString:[request serviceName]];
	[jsonWriter appendString:@"\",1,0,\""];
	[jsonWriter appendString:[request methodName]];
	[jsonWriter appendString:@"\","];
	[jsonObjectHandler writeValue:[JBFaultSerializer toJSONObject:fault] writer:jsonWriter];
	[jsonWriter appendString:@");"];
	NSString* answer = [jsonWriter toString];
	
	[jsonWriter release];
	
	return answer;
	
}

+(NSString*)buildJavascriptNotification:(JBBrokerMessage*)notification  {
	
	
	JBJsonStringOutput* jsonWriter = [[JBJsonStringOutput alloc] init];
	
	[jsonWriter appendString:@"jsonbroker.onNotification("];

	JBJsonObjectHandler* jsonObjectHandler = [JBJsonObjectHandler getInstance];
	[jsonObjectHandler writeValue:[notification metaData] writer:jsonWriter];
	
	[jsonWriter appendString:@",\""];
	[jsonWriter appendString:[notification serviceName]];
	[jsonWriter appendString:@"\",1,0,\""];
	[jsonWriter appendString:[notification methodName]];
	[jsonWriter appendString:@"\","];
	[jsonObjectHandler writeValue:[notification associativeParamaters] writer:jsonWriter];
    
	JBJsonArray* parameters = [notification paramaters];
	
	for( int i = 0, count = [parameters count]; i < count; i++ ) {
		
		[jsonWriter appendChar:','];

		id blob = [parameters objectAtIndex:i];
		JBJsonHandler* handler = [JBJsonHandler getHandlerForObject:blob];
		[handler writeValue:blob writer:jsonWriter];
	}
	
	[jsonWriter appendString:@");"];
	
	NSString* answer = [jsonWriter toString];
	
	[jsonWriter release];
	
	return answer;
	
}


+(NSString*)buildJavascriptResponse:(JBBrokerMessage*)response  {
	
	
	JBJsonStringOutput* jsonWriter = [[JBJsonStringOutput alloc] init];
	
	[jsonWriter appendString:@"jsonbroker.forwardResponse(\"response\","];
	
	JBJsonObjectHandler* jsonObjectHandler = [JBJsonObjectHandler getInstance];
	[jsonObjectHandler writeValue:[response metaData] writer:jsonWriter];
	
	[jsonWriter appendString:@",\""];
	[jsonWriter appendString:[response serviceName]];
	[jsonWriter appendString:@"\",1,0,\""];
	[jsonWriter appendString:[response methodName]];
	[jsonWriter appendString:@"\","];
	[jsonObjectHandler writeValue:[response associativeParamaters] writer:jsonWriter];
    
	JBJsonArray* parameters = [response paramaters];
	
	for( int i = 0, count = [parameters count]; i < count; i++ ) {
		
		[jsonWriter appendChar:','];
		id blob = [parameters objectAtIndex:i];
		JBJsonHandler* handler = [JBJsonHandler getHandlerForObject:blob];
		[handler writeValue:blob writer:jsonWriter];
	}
	
	[jsonWriter appendString:@");"];
	NSString* answer = [jsonWriter toString];
	
	[jsonWriter release];
	
	return answer;
	
}


+(NSString*)buildJavascriptForwardRequest:(JBBrokerMessage*)request  {
    
    NSMutableString* answer = [NSMutableString stringWithString:@"jsonbroker.forwardRequest( "];
    [answer appendString:[request toString]];
    
    [answer appendString:@" );"];
    
    return answer;
}




@end

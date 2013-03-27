// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



@interface JBBrokerMessageType : NSObject {
	
	
	NSString* _identifier;
	//@property (nonatomic, retain) NSString* identifier;
	//@synthesize identifier = _identifier;
	
	
}


+(JBBrokerMessageType*)fault;
+(JBBrokerMessageType*)metaRequest;
+(JBBrokerMessageType*)metaResponse;
+(JBBrokerMessageType*)notification;
+(JBBrokerMessageType*)oneway;
+(JBBrokerMessageType*)request;
+(JBBrokerMessageType*)response;

+(JBBrokerMessageType*)lookup:(NSString*)identifier;

#pragma mark -
#pragma mark fields

//NSString* _identifier;
@property (nonatomic, retain) NSString* identifier;
//@synthesize identifier = _identifier;


@end



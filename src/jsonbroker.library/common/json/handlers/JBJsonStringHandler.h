// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonHandler.h"


@interface JBJsonStringHandler : JBJsonHandler {

	
}

+(JBJsonStringHandler*)getInstance;


#ifdef REMOTE_GATEWAY_CLIENT

// major hack to handle older builds of 'RemoteGateway'
+(void)doNotEscapeForwardSlashForOldRemoteGateway;

#endif



+(NSString*)readString:(JBJsonInput*)reader;
+(void)writeString:(NSString*)value writer:(id<JBJsonOutput>)writer;

@end

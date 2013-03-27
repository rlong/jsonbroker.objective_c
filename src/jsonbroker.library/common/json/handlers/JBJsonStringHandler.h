// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonHandler.h"


@interface JBJsonStringHandler : JBJsonHandler {

	
}

+(JBJsonStringHandler*)getInstance;


+(NSString*)readString:(JBJsonInput*)reader;
+(void)writeString:(NSString*)value writer:(id<JBJsonOutput>)writer;

@end

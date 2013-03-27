// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonHandler.h"


@interface JBJsonNumberHandler : JBJsonHandler {

	
}

+(JBJsonNumberHandler*)getInstance;

+(NSNumber*)readNumber:(JBJsonInput*)reader;
+(void)writeNumber:(NSNumber*)value writer:(id<JBJsonOutput>)writer;


@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonHandler.h"


@interface JBJsonNullHandler : JBJsonHandler {

}

+(JBJsonNullHandler*)getInstance; 

+(id)readNull:(JBJsonInput*)reader;
+(void)writeNullTo:(id<JBJsonOutput>)writer;

@end

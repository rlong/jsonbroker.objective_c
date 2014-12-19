// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@class JBJsonInput;
#import "JBJsonOutput.h"

@interface JBJsonHandler : NSObject {

}




+(JBJsonHandler*)getHandlerForObject:(id)object;
+(JBJsonHandler*)getHandlerForTokenBeginning:(char)tokenBeginning;
-(void)writeValue:(id)value writer:(id<JBJsonOutput>)writer;
-(id)readValue:(JBJsonInput*)reader;


@end

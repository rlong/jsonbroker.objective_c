// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBJsonHandler.h"

@interface JBJsonBooleanHandler : JBJsonHandler


+(JBJsonBooleanHandler*)getInstance;

+(bool)readBoolean:(JBJsonInput*)reader;
+(void)writeBoolean:(bool)value writer:(id<JBJsonOutput>)writer;

@end

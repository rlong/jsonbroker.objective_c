// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


/* template implementation */ 
@interface JBDefaults : NSObject


-(bool)getBoolWithName:(NSString*)name defaultValue:(bool)defaultValue;

-(int)getIntWithName:(NSString*)name defaultValue:(int)defaultValue;

-(id)initWithScope:(NSString*)scope;

@end

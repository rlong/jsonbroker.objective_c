// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBDefaults.h"

@implementation JBDefaults


-(bool)getBoolWithName:(NSString*)name defaultValue:(bool)defaultValue {
    
    return defaultValue;
    
}

-(int)getIntWithName:(NSString*)name defaultValue:(int)defaultValue {
    
    return defaultValue;
    
}


-(id)initWithScope:(NSString*)scope {
    
    JBDefaults* answer  = [super init];
    
    return answer;
    
}

@end

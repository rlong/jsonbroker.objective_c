// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBJsonObject.h"


/* simply uses environment variables */
@interface JBDefaults : NSObject {
    
    
    // environment
    JBJsonObject* _environment;
    //@property (nonatomic, retain) JBJsonObject* environment;
    //@synthesize environment = _environment;

    
    
}


-(bool)boolWithName:(NSString*)name defaultValue:(bool)defaultValue;



-(int)intWithName:(NSString*)name defaultValue:(int)defaultValue;

-(JBJsonObject*)jsonObjectWithName:(NSString*)name defaultValue:(JBJsonObject*)defaultValue;

+(JBDefaults*)getDefaultsForScope:(NSString*)scope;


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithEnvironment:(JBJsonObject*) environment;
//-(id)initWithScope:(NSString*)scope;

@end

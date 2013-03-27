//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>

#import "JBLogEntry.h"

@interface JBSimpleLogEntry : NSObject <JBLogEntry> {
    
    
    // threadName
	NSString* _threadName;
	//@property (nonatomic, retain) NSString* threadName;
	//@synthesize threadName = _threadName;
    
    // level
	NSString* _level;
	//@property (nonatomic, retain) NSString* level;
	//@synthesize level = _level;

    
    // function
	NSString* _function;
	//@property (nonatomic, retain) NSString* function;
	//@synthesize function = _function;
    
    // message
	NSString* _message;
	//@property (nonatomic, retain) NSString* message;
	//@synthesize message = _message;
    
	// toString
	NSString* _toString;
	//@property (nonatomic, readonly, getter=toString) NSString* toString;
	//@synthesize toString = _toString;


    
}


-(NSString*)toString;

#pragma mark instance lifecycle

-(id)initWithLevel:(NSString*)level function:(const char *)function message:(NSString*)message;

#pragma mark fields

// toString
//NSString* _toString;
@property (nonatomic, readonly, getter=toString) NSString* toString;
//@synthesize toString = _toString;

@end

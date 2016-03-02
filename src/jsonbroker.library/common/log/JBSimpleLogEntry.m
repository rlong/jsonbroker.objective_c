//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBSimpleLogEntry.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@interface JBSimpleLogEntry () 



// threadName
//NSString* _threadName;
@property (nonatomic, retain) NSString* threadName;
//@synthesize threadName = _threadName;


// level
//NSString* _level;
@property (nonatomic, retain) NSString* level;
//@synthesize level = _level;

// function
//NSString* _function;
@property (nonatomic, retain) NSString* function;
//@synthesize function = _function;

// message
//NSString* _message;
@property (nonatomic, retain) NSString* message;
//@synthesize message = _message;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation JBSimpleLogEntry

-(NSString*)toString {
    
    if( nil != _toString ) { 
        return _toString;
    }
    
    _toString = [NSString stringWithFormat:@"%@ %@ %@ %@", _threadName, _level, _function, _message];
    return _toString;
}

#pragma mark instance lifecycle

-(id)initWithLevel:(NSString*)level function:(const char *)function message:(NSString*)message { 
    

    JBSimpleLogEntry* answer = [super init];
    
    if( nil != answer ) { 
        
        NSString* currentThreadName = [[NSThread currentThread] name];
        [answer setThreadName:currentThreadName];
        [answer setLevel:level];
        [answer setFunction:[NSString stringWithUTF8String:function]];
        [answer setMessage:message];
        answer->_toString = nil;
    }
    
    return answer;
}

-(void)dealloc {

	[self setThreadName:nil];
	[self setLevel:nil];
	[self setFunction:nil];
	[self setMessage:nil];
    if( nil != _toString ) {
        _toString = nil;
    }
	
	
}

#pragma mark fields


// threadName
//NSString* _threadName;
//@property (nonatomic, retain) NSString* threadName;
@synthesize threadName = _threadName;

// level
//NSString* _level;
//@property (nonatomic, retain) NSString* level;
@synthesize level = _level;


// function
//NSString* _function;
//@property (nonatomic, retain) NSString* function;
@synthesize function = _function;


// message
//NSString* _message;
//@property (nonatomic, retain) NSString* message;
@synthesize message = _message;

// toString
//NSString* _toString;
//@property (nonatomic, readonly, getter=toString) NSString* toString;
@synthesize toString = _toString;


@end

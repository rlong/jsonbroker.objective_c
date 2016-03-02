//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBSimpleLogConsumer.h"

#import "JBSimpleLogEntry.h"


#define LOG_CAPACITY 50

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@interface JBSimpleLogConsumer () 

//NSMutableArray *_logEntries;
@property (nonatomic, retain) NSMutableArray *logEntries;
//@synthesize logEntries = _logEntries;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation JBSimpleLogConsumer


+(int)advance:(int)cursor {
	int answer = cursor + 1;
	if( answer == LOG_CAPACITY ) {
		answer = 0;
	}
	return answer;
}


-(NSArray*)getRecentLogEntries {
    
    @synchronized(self) {
        
        NSMutableArray* answer = [NSMutableArray arrayWithCapacity:[_logEntries count]];
        
        for( int i = _start, endIndex = _next; i != endIndex; i = [JBSimpleLogConsumer advance:i] ) {
            JBSimpleLogEntry* logEntry = [_logEntries objectAtIndex:i];
            [answer addObject:[logEntry toString]];
        }
        
        return answer;
    }
    
                              
}


-(void)reset {

    @synchronized(self) {
        [_logEntries removeAllObjects];
        _start = 0;
        _next = 0;
    }
}


#pragma mark <LogConsumer> implementation 



-(void)addLogEntry:(JBSimpleLogEntry*)logEntry {
    
	if( [_logEntries count] != LOG_CAPACITY ) { // not at full capacity
        
		[_logEntries addObject:logEntry];

        // just hit capacity
        if( [_logEntries count] == LOG_CAPACITY ) {
            _start = [JBSimpleLogConsumer advance:_start];
        }
        
	} else {
		[_logEntries replaceObjectAtIndex:_next withObject:logEntry];
		_start = [JBSimpleLogConsumer advance:_start];
        
    }
    _next = [JBSimpleLogConsumer advance:_next];

}

-(void)logMessage:(NSString*)message forFunction:(const char *)function atLevel:(NSString*)level {
    
    if( [@"DBG" isEqualToString:level] ) { 
        return;
    }
    
    JBSimpleLogEntry* entry = [[JBSimpleLogEntry alloc] initWithLevel:level function:function message:message];
    {
        @synchronized(self) {
            [self addLogEntry:entry];
        }
    }
	
}

#pragma mark instance lifecycle


-(id)init {
	
	JBSimpleLogConsumer* answer = [super init];
    
    if( nil != answer ) { 
        answer->_logEntries = [[NSMutableArray alloc] initWithCapacity:LOG_CAPACITY];
        answer->_start = 0;
        answer->_next = 0;
    }
	
	return answer;
	
}

-(void)dealloc {
	
	
	[self setLogEntries:nil];
}



#pragma mark fields

//NSMutableArray *_logEntries;
//@property (nonatomic, retain) NSMutableArray *logEntries;
@synthesize logEntries = _logEntries;


@end

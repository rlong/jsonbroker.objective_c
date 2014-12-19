// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonArray.h"
#import "JBJsonObject.h"
#import "JBJsonStack.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBJsonStack ()

// stack
//NSMutableArray* _stack;
@property (nonatomic, retain) NSMutableArray* stack;
//@synthesize stack = _stack;

// currentObject
//JBJsonObject* _currentObject;
@property (nonatomic, readwrite, retain) JBJsonObject* currentObject;
//@synthesize currentObject = _currentObject;

// currentArray
//JBJsonArray* _currentArray;
@property (nonatomic, readwrite, retain) JBJsonArray* currentArray;
//@synthesize currentArray = _currentArray;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBJsonStack


-(id)pop {
    
    
    id popped = [_stack lastObject];
    [popped retain];
    {
        [_stack removeLastObject];
    }
    [popped autorelease];
    
    [self setCurrentObject:nil];
    [self setCurrentArray:nil];
    
    if( 0 != [_stack count] ) {
        
        id current = [_stack lastObject];
        if( [current isKindOfClass:[JBJsonObject class]] ) {
            [self setCurrentObject:current];
        } else {
            [self setCurrentArray:current];
        }
    }
    
    return popped;
    
}

-(void)pushJsonObject:(JBJsonObject*)top {
    
    [_stack addObject:top];
    [self setCurrentObject:top];
    [self setCurrentArray:nil];
    
}

-(void)pushJsonArray:(JBJsonArray*)top {

    [_stack addObject:top];
    [self setCurrentObject:nil];
    [self setCurrentArray:top];
}



#pragma mark -
#pragma mark instance lifecycle


-(id)init {
    
    JBJsonStack* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_stack = [[NSMutableArray alloc] init];
    }
    
    return answer;
}

-(void)dealloc {
	
	[self setStack:nil];
    [self setCurrentObject:nil];
	[self setCurrentArray:nil];

	[super dealloc];
	
}

#pragma mark -
#pragma mark fields

// stack
//NSMutableArray* _stack;
//@property (nonatomic, retain) NSMutableArray* stack;
@synthesize stack = _stack;

// currentObject
//JBJsonObject* _currentObject;
//@property (nonatomic, retain) JBJsonObject* currentObject;
@synthesize currentObject = _currentObject;

// currentArray
//JBJsonArray* _currentArray;
//@property (nonatomic, retain) JBJsonArray* currentArray;
@synthesize currentArray = _currentArray;


@end

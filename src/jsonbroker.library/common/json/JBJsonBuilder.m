// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBJsonBuilder.h"
#import "JBLog.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBJsonBuilder ()

// stack
//JBJsonStack* _stack;
@property (nonatomic, retain) JBJsonStack* stack;
//@synthesize stack = _stack;

// objectDocument
//JBJsonObject* _objectDocument;
//@property (nonatomic, readonly) JBJsonObject* objectDocument;
@property (nonatomic, retain, readwrite) JBJsonObject* objectDocument;
//@synthesize objectDocument = _objectDocument;

// arrayDocument
//JBJsonArray* _arrayDocument;
//@property (nonatomic, readonly) JBJsonArray* arrayDocument;
@property (nonatomic, retain, readwrite) JBJsonArray* arrayDocument;
//@synthesize arrayDocument = _arrayDocument;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


#pragma mark -

@implementation JBJsonBuilder


#pragma mark -
#pragma mark document

-(void)onObjectDocumentStart {
    
    _objectDocument = [[JBJsonObject alloc] init];
    [_stack pushJsonObject:_objectDocument];
    
}

-(void)onObjectDocumentEnd {
    
    [_stack pop];
    
}


-(void)onArrayDocumentStart {
    _arrayDocument = [[JBJsonArray alloc] init];
    [_stack pushJsonArray:_arrayDocument];
}

-(void)onArrayDocumentEnd {
    [_stack pop];
    
}



#pragma mark -
#pragma mark object

-(void)onArrayStartWithKey:(NSString*)key {
    
    Log_debugString(key);
    
    JBJsonArray* jsonArray = [[JBJsonArray alloc] init];
    {
        [[_stack currentObject] setObject:jsonArray forKey:key];
        [_stack pushJsonArray:jsonArray];
    }
    [jsonArray release];
    
}

-(void)onArrayEndWithKey:(NSString*)key {
    
    Log_debugString(key);
    [_stack pop];
    
}


-(void)onBooleanWithKey:(NSString*)key value:(bool)value {
    
    [[_stack currentObject] setBoolean:value forKey:key];
    
}

-(void)onNullWithKey:(NSString*)key {
    
    [[_stack currentObject] setObject:nil forKey:key];
    
}

-(void)onNumberWithKey:(NSString*)key value:(NSNumber*)value {
    
    [[_stack currentObject] setObject:value forKey:key];
    
}


-(void)onObjectStartWithKey:(NSString*)key {
    
    JBJsonObject* jsonObject = [[JBJsonObject alloc] init];
    {
        [[_stack currentObject] setObject:jsonObject forKey:key];
        [_stack pushJsonObject:jsonObject];
    }
    [jsonObject release];

    
}

-(void)onObjectEndWithKey:(NSString*)key {
    
    Log_debugString(key);
    [_stack pop];

}


-(void)onStringWithKey:(NSString*)key value:(NSString*)value {
    
    [[_stack currentObject] setObject:value forKey:key];
    
}


#pragma mark -
#pragma mark array

-(void)onArrayStartWithIndex:(NSUInteger)index {
    
    Log_debugInt(index);
    
    JBJsonArray* jsonArray = [[JBJsonArray alloc] init];
    {
        [[_stack currentArray] add:jsonArray];
        [_stack pushJsonArray:jsonArray];
    }
    [jsonArray release];
    
    
}

-(void)onArrayEndWithIndex:(NSUInteger)index {

    Log_debugInt(index);
    [_stack pop];

}



-(void)onBooleanWithIndex:(NSUInteger)index value:(bool)value {
    
    [[_stack currentArray] addBoolean:value];

}

-(void)onNullWithIndex:(NSUInteger)index {
    
    [[_stack currentArray] add:nil];
    
}

-(void)onNumberWithIndex:(NSUInteger)index value:(NSNumber*)value {
    
    [[_stack currentArray] add:value];
    
}


-(void)onObjectStartWithIndex:(NSUInteger)index {
    
    JBJsonObject* jsonObject = [[JBJsonObject alloc] init];
    {
        [[_stack currentArray] add:jsonObject];
        [_stack pushJsonObject:jsonObject];
    }
    [jsonObject release];

    
}

-(void)onObjectEndWithIndex:(NSUInteger)index {
    
    Log_debugInt(index);
    [_stack pop];

}


-(void)onStringWithIndex:(NSUInteger)index value:(NSString*)value {
    
    [[_stack currentArray] add:value];

}




#pragma mark -
#pragma mark instance lifecycle



-(id)init {
    
    JBJsonBuilder* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_stack = [[JBJsonStack alloc] init];
    }
    
    return answer;
}


-(void)dealloc {
	
	[self setStack:nil];
	[self setObjectDocument:nil];
	[self setArrayDocument:nil];


	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields

// stack
//JBJsonStack* _stack;
//@property (nonatomic, retain) JBJsonStack* stack;
@synthesize stack = _stack;

// objectDocument
//JBJsonObject* _objectDocument;
//@property (nonatomic, readonly) JBJsonObject* objectDocument;
//@property (nonatomic, retain, readwrite) JBJsonObject* objectDocument;
@synthesize objectDocument = _objectDocument;

// arrayDocument
//JBJsonArray* _arrayDocument;
//@property (nonatomic, readonly) JBJsonArray* arrayDocument;
//@property (nonatomic, retain, readwrite) JBJsonArray* arrayDocument;
@synthesize arrayDocument = _arrayDocument;


@end

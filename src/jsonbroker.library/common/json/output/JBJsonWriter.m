// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJsonBooleanHandler.h"
#import "JBJsonNullHandler.h"
#import "JBJsonNumberHandler.h"
#import "JBJsonStringHandler.h"
#import "JBJsonWriter.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBJsonWriter ()

// output
//id<JBJsonOutput> _output;
@property (nonatomic, retain) id<JBJsonOutput> output;
//@synthesize output = _output;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBJsonWriter



#pragma mark -
#pragma mark <JBJsonDocumentHandler> implementation



#pragma mark -
#pragma mark document

-(void)onObjectDocumentStart {
    
    [_output appendChar:'{'];
    _objectStarted = true;
    
    
}

-(void)onObjectDocumentEnd {
    
    [_output appendChar:'}'];
    _objectStarted = false;
    
    
}


-(void)onArrayDocumentStart {
    
    [_output appendChar:'['];
    
    
}

-(void)onArrayDocumentEnd {
    
    [_output appendChar:']'];

}



#pragma mark -
#pragma mark object

-(void)onArrayStartWithKey:(NSString*)key {
    
    if( _objectStarted ) {
        _objectStarted = false;
    } else {
        [_output appendChar:','];
    }
    
    
    [JBJsonStringHandler writeString:key writer:_output];
    [_output appendString:@":["];
    
    
    
}

-(void)onArrayEndWithKey:(NSString*)key {
    
    [_output appendChar:']'];

}


-(void)onBooleanWithKey:(NSString*)key value:(bool)value {

    if( _objectStarted ) {
        _objectStarted = false;
    } else {
        [_output appendChar:','];
    }
    
    
    [JBJsonStringHandler writeString:key writer:_output];
    [_output appendChar:':'];
    [JBJsonBooleanHandler writeBoolean:value writer:_output];

    
}

-(void)onNullWithKey:(NSString*)key {
    
    if( _objectStarted ) {
        _objectStarted = false;
    } else {
        [_output appendChar:','];
    }
    
    
    [JBJsonStringHandler writeString:key writer:_output];
    [_output appendChar:':'];
    [JBJsonNullHandler writeNullTo:_output];

    
}

-(void)onNumberWithKey:(NSString*)key value:(NSNumber*)value {

    if( _objectStarted ) {
        _objectStarted = false;
    } else {
        [_output appendChar:','];
    }
    
    
    [JBJsonStringHandler writeString:key writer:_output];
    [_output appendChar:':'];
    [JBJsonNumberHandler writeNumber:value writer:_output];
    
}


-(void)onObjectStartWithKey:(NSString*)key {
    
    if( _objectStarted ) {
        _objectStarted = false;
    } else {
        [_output appendChar:','];
    }
    
    
    [JBJsonStringHandler writeString:key writer:_output];
    [_output appendString:@":{"];
    _objectStarted = true;
    
    
    
}

-(void)onObjectEndWithKey:(NSString*)key {
    
    [_output appendChar:'}'];
    _objectStarted = false;


}


-(void)onStringWithKey:(NSString*)key value:(NSString*)value {
    
    
    if( _objectStarted ) {
        _objectStarted = false;
    } else {
        [_output appendChar:','];
    }
    
    
    [JBJsonStringHandler writeString:key writer:_output];
    [_output appendChar:':'];
    [JBJsonStringHandler writeString:value writer:_output];

}


#pragma mark -
#pragma mark array

-(void)onArrayStartWithIndex:(NSUInteger)index {
    
    if( 0 != index ) {
        [_output appendChar:','];
    }
    
    [_output appendChar:'['];
    
    
}

-(void)onArrayEndWithIndex:(NSUInteger)index {
    
    [_output appendChar:']'];

}



-(void)onBooleanWithIndex:(NSUInteger)index value:(bool)value {
    
    if( 0 != index ) {
        [_output appendChar:','];
    }

    [JBJsonBooleanHandler writeBoolean:value writer:_output];

}

-(void)onNullWithIndex:(NSUInteger)index {
    
    if( 0 != index ) {
        [_output appendChar:','];
    }

    [JBJsonNullHandler writeNullTo:_output];

}

-(void)onNumberWithIndex:(NSUInteger)index value:(NSNumber*)value {
    
    if( 0 != index ) {
        [_output appendChar:','];
    }

    [JBJsonNumberHandler writeNumber:value writer:_output];

}


-(void)onObjectStartWithIndex:(NSUInteger)index {
    
    if( 0 != index ) {
        [_output appendChar:','];
    }

    [_output appendChar:'{'];
    _objectStarted = true;

    
}

-(void)onObjectEndWithIndex:(NSUInteger)index {
    
    [_output appendChar:'}'];
    _objectStarted = false;

}


-(void)onStringWithIndex:(NSUInteger)index value:(NSString*)value {
    
    if( 0 != index ) {
        [_output appendChar:','];
    }

    [JBJsonStringHandler writeString:value writer:_output];
    
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithOutput:(id<JBJsonOutput>)output {
    
    JBJsonWriter* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setOutput:output];
    }
    
    return answer;
    
}

-(void)dealloc {
	[self setOutput:nil];
	
	
}


#pragma mark -
#pragma mark fields



// output
//id<JBJsonOutput> _output;
//@property (nonatomic, retain) id<JBJsonOutput> output;
@synthesize output = _output;

@end

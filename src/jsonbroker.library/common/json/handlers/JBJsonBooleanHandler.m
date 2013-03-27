// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonBooleanHandler.h"

@implementation JBJsonBooleanHandler


static JBJsonBooleanHandler* _instance = nil; 

+(void)initialize {
	
	_instance = [[JBJsonBooleanHandler alloc] init];
	
}

+(JBJsonBooleanHandler*)getInstance { 
	
	return _instance;	
}



+(bool)readBoolean:(JBJsonInput*)reader {
    
    UInt8 currentByte = [reader currentByte];

    if( 't' == currentByte || 'T' == currentByte) {
        
        
        //'t' is the current character
        [reader nextByte]; // 'r' is the current character
        [reader nextByte]; // 'u' is the current character
        [reader nextByte]; // 'e' is the current character
        [reader nextByte]; // after true
        
        return true;
        
        
    } else {
        
        //'f' is the current character
        [reader nextByte]; // 'a' is the current character
        [reader nextByte]; // 'l' is the current character
        [reader nextByte]; // 's' is the current character
        [reader nextByte]; // 'e' is the current character
        [reader nextByte]; // after false
        
        return false;
        
    }

    
}

-(id)readValue:(JBJsonInput*)reader {

    bool value = [JBJsonBooleanHandler readBoolean:reader];
    return [NSNumber numberWithBool:value];
    
    
}


+(void)writeBoolean:(bool)value writer:(id<JBJsonOutput>)writer {
    
    if( value ) {
        
        [writer appendString:@"true"];
        
    } else {
        
        [writer appendString:@"false"];
    }
    
    
}

-(void)writeValue:(id)value writer:(id<JBJsonOutput>)writer {
    
    NSNumber* booleanNumber = value;
    
    [JBJsonBooleanHandler writeBoolean:[booleanNumber boolValue] writer:writer];
	
}


@end

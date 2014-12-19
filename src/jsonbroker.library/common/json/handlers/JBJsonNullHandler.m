// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonInput.h"
#import "JBJsonNullHandler.h"

@implementation JBJsonNullHandler


static JBJsonNullHandler* _instance = nil; 

+(void)initialize {
	
	_instance = [[JBJsonNullHandler alloc] init];
	
}

+(JBJsonNullHandler*)getInstance { 
	
	return _instance;
	
}


+(id)readNull:(JBJsonInput*)reader {
    
    //'n' is the current character
	
	[reader nextByte]; // 'u' is the current character
	[reader nextByte]; // 'l' is the current character
	[reader nextByte]; // 'l' is the current character
	[reader nextByte]; // after null
	
	return nil;

}


-(id)readValue:(JBJsonInput*)reader {
    
    return [JBJsonNullHandler readNull:reader];
	
}


+(void)writeNullTo:(id<JBJsonOutput>)writer {
    
    [writer appendString:@"null"];

}


-(void)writeValue:(id)value writer:(id<JBJsonOutput>)writer {
	
    [JBJsonNullHandler writeNullTo:writer];
	
}



@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonArray.h"
#import "JBJsonArrayHandler.h"
#import "JBJsonDataInput.h"
#import "JBJsonStringOutput.h"


@implementation JBJsonArrayHandler


static JBJsonArrayHandler* _instance = nil; 

+(void)initialize {
	
	_instance = [[JBJsonArrayHandler alloc] init];
	
}

+(JBJsonArrayHandler*)getInstance { 
	
	return _instance;
	
}



-(void)writeValue:(id)value writer:(id<JBJsonOutput>)writer {
	
	JBJsonArray* array = (JBJsonArray*)value;
	
	[writer appendChar:'['];
	
	
	long count = [array count];
	
	
	if( count > 0 ) {
		
		id object = [array objectAtIndex:0 defaultValue:nil];
		
		JBJsonHandler* valueHandler = [JBJsonHandler getHandlerForObject:object];
		
		[valueHandler writeValue:object writer:writer];
	
		
	}
	for( int i = 1; i < count; i++ ) {
		[writer appendChar:','];

		id object = [array objectAtIndex:i defaultValue:nil];
		
		JBJsonHandler* valueHandler = [JBJsonHandler getHandlerForObject:object];
		
		[valueHandler writeValue:object writer:writer];
		
	}
	
	
	[writer appendChar:']'];
	
	
}




-(JBJsonArray*)readJSONArray:(JBJsonInput*)reader {
	
	JBJsonArray* answer = [[JBJsonArray alloc] init];
	[answer autorelease];
	
	[reader nextByte]; // move past the '['
	
	
	UInt8 b = [ reader scanToNextToken];
	
	while( ']' != b ) {
		
		JBJsonHandler* valueHandler =  [JBJsonHandler getHandlerForTokenBeginning:b];
		
		
		id object = [valueHandler readValue:reader];
		
		[answer add:object];
		
		b = [reader scanToNextToken];
		
	}	
	
	// move past the ']' if we can
	
	if( [reader hasNextByte] ) {
		
		[reader nextByte];
		
	}
	
	
	return answer;
	
	
}

-(id)readValue:(JBJsonDataInput*)reader {
	
	return [self readJSONArray:reader];
	
	
}



@end

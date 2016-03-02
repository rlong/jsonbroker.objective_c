// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonDataInput.h"
#import "JBJsonObjectHandler.h"
#import "JBJsonObject.h"
#import "JBJsonStringHandler.h"

#import "JBLog.h"

@implementation JBJsonObjectHandler


static JBJsonObjectHandler* _instance = nil; 

+(void)initialize {
	
	_instance = [[JBJsonObjectHandler alloc] init];
	
}

+(JBJsonObjectHandler*)getInstance { 
	
	return _instance;
	
}



-(void)writeValue:(id)value writer:(id<JBJsonOutput>)writer {
	
	JBJsonObject* jsonObject = (JBJsonObject*)value;

	[writer appendChar:'{'];

	NSArray* allKeys = [jsonObject allKeys];
	
	for( long i = 0, count = [allKeys count]; i < count; i++ ) {
		NSString* key = [allKeys objectAtIndex:i];
		
		[[JBJsonStringHandler getInstance] writeValue:key writer:writer];
		
		[writer appendChar:':'];
		
		id embeddedValue = [jsonObject objectForKey:key defaultValue:nil];
		
		JBJsonHandler* valueHander = [JBJsonHandler getHandlerForObject:embeddedValue];
		
		[valueHander writeValue:embeddedValue writer:writer];
		
		if( i+1 < count ) {
			
			[writer appendChar:','];
		}
	}
	
	[writer appendChar:'}'];

	
	
}


-(JBJsonObject*)readJSONObject:(JBJsonInput*)reader { 
	
	JBJsonObject* answer = [[JBJsonObject alloc] init];
	
	[reader nextByte]; // move past the '{'
	
	
	UInt8 b = [reader scanToNextToken];
	
	while( '}' != b ) {
		
		NSString* key = (NSString*)[[JBJsonStringHandler getInstance] readValue:reader];
		
		b = [reader scanToNextToken];
		
		JBJsonHandler* valueHandler = [JBJsonHandler getHandlerForTokenBeginning:b];
		
		id value = [valueHandler readValue:reader];
		
		[answer setObject:value forKey:key];
		
		b = [reader scanToNextToken];
		
	}	
	
	// move past the '}' if we can
	if( [reader hasNextByte] ) {
		
		[reader nextByte];
		
	}
	
	return answer;
	
}

-(id)readValue:(JBJsonDataInput*)reader {
	
	return [self readJSONObject:reader];
	
}


@end

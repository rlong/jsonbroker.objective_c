// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBJsonNumberHandler.h"
#import "JBStringHelper.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBJsonNumberHandler () 


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



@implementation JBJsonNumberHandler



static JBJsonNumberHandler* _instance = nil; 

+(void)initialize {
	
	_instance = [[JBJsonNumberHandler alloc] init];
	
}

+(JBJsonNumberHandler*)getInstance { 
	
	return _instance;
	
}

+(NSNumber*)readNumber:(JBJsonInput*)reader {
    
    NSMutableData* data = [reader reserveMutableData];
    
	@try {
        
		UInt8 c = [reader currentByte];
		
		NSNumber* answer;
		
		do {
			
			if( '.' == c || 'e' == c || 'E' == c ) {
                [data appendBytes:&c length:1];
				c = [reader nextByte];
				continue;
			}
			
			if( '+' == c || '-' == c ) {
                [data appendBytes:&c length:1];
				c = [reader nextByte];
				continue;
			}
			
			if( '0' <= c && c <= '9' ) {
                [data appendBytes:&c length:1];
				c = [reader nextByte];
				continue;
			}
			
            
			NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString* numberString = [JBStringHelper getUtf8String:data];
			answer = [numberFormatter numberFromString:numberString];
			[numberFormatter release];
			return answer;
			
		}while( true );
	}
	@finally {
		[reader releaseMutableData:data];
	}
    
	// code 'should' never arrive here
	BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unexpected code path"];
	[e autorelease];
	@throw e;
    
}


-(id)readValue:(JBJsonInput*)reader {
	
    return [JBJsonNumberHandler readNumber:reader];
	
}



+(void)writeNumber:(NSNumber*)value writer:(id<JBJsonOutput>)writer {

    [writer appendString:[value stringValue]];

}

-(void)writeValue:(id)value writer:(id<JBJsonOutput>)writer {
	
	
	NSNumber* numberValue = (NSNumber*)value;
    
	[JBJsonNumberHandler writeNumber:numberValue writer:writer];
}

@end

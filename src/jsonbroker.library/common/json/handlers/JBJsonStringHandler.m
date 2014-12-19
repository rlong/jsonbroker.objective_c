// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBJsonInput.h"
#import "JBJsonStringHandler.h"




@implementation JBJsonStringHandler


static JBJsonStringHandler* _instance = nil;
static bool _doNotEscapeForwardSlashForOldRemoteGateway = false;

+(void)initialize {
	
	_instance = [[JBJsonStringHandler alloc] init];
	
}

+(JBJsonStringHandler*)getInstance { 
	
	return _instance;
	
}


// major hack to handle older builds of 'RemoteGateway'
+(void)doNotEscapeForwardSlashForOldRemoteGateway {
    
    _doNotEscapeForwardSlashForOldRemoteGateway = true;
    
}




+(NSString*)readString:(JBJsonInput*)reader {
    
    NSMutableData* data = [reader reserveMutableData];
    
	@try {
		
		UInt8 b;
		
		while( true ) {
			
			b = [reader nextByte];
			
			if('"' == b ) {
				NSString* answer = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
				[answer autorelease];
                
				
				[reader nextByte]; // move past the '"'
                
				return answer;
				
			}
			
			if( '\\' != b ) {
				
				[data appendBytes:&b length:1];
				
				continue;
			}
			
			b = [reader nextByte];
            
            if ('"' == b || '\\' == b || '/' == b) {
                
                [data appendBytes:&b length:1];
                
                continue;
            }
            
            if ('n' == b ) {
                b = '\n';
                [data appendBytes:&b length:1];
                
                continue;
            }
            
            if ('t' == b ) {
                b = '\t';
                [data appendBytes:&b length:1];
                
                continue;
            }
            
            
            if ('r' == b ) {
                b = '\r';
                [data appendBytes:&b length:1];
                
                continue;
            }
			
		}
	}
	@finally {
		[reader releaseMutableData:data];
	}
	
	// control should never reach here ... either the loop will continue forever or the return statement in the loop will get executed
	BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unexpected control flow"];
	[e autorelease];
	@throw e;

    
    
}

-(id)readValue:(JBJsonInput*)reader { 
	
    return [JBJsonStringHandler readString:reader];
	
	
}




+(void)writeString:(NSString*)value writer:(id<JBJsonOutput>)writer {

    
    [writer appendChar:'"'];
	
	
	for( long i = 0, count = [value length]; i < count; i++ ) {
		
		unichar c = [value characterAtIndex:i];
		
		if( '"' == c ) {
			
			[writer appendString:@"\\\""];
			
			continue;
			
		}
		
		if( '\\' == c ) {
			
			[writer appendString:@"\\\\"];
			
			continue;
		}

        if( '/' == c ) {

            if( _doNotEscapeForwardSlashForOldRemoteGateway ) {
        
                [writer appendChar:c];

            } else {
                
                [writer appendString:@"\\/"];

                
            }

			
			continue;
		}



		if( '\n' == c ) {
			
			[writer appendString:@"\\n"];
			
			continue;
		}
		
		if( '\t' == c ) {
			[writer appendString:@"\\t"];
			
			continue;
		}
		
		[writer appendChar:c];
	}
	
	[writer appendChar:'"'];

}

-(void)writeValue:(id)value writer:(id<JBJsonOutput>)writer {
    
    
    [JBJsonStringHandler writeString:(NSString*)value writer:writer];
	
}



@end

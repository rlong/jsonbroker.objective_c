// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJsonStringOutput.h"
#import "JBObjectTracker.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBJsonStringOutput () 

//NSMutableString* _stringBuffer;
@property (nonatomic, retain) NSMutableString* stringBuffer;
//@synthesize stringBuffer = _stringBuffer;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



@implementation JBJsonStringOutput



-(void)reset {
	[_stringBuffer setString:@""];
}

-(void)appendChar:(unichar)c {
	[_stringBuffer appendFormat:@"%C", c];
}

-(void)appendString:(NSString*)string { 
	[_stringBuffer appendString:string]; 
}

-(NSString*)toString {
	
	return [NSString stringWithString:_stringBuffer];
}


#pragma mark instance lifecycle

-(id)init {
	
	JBJsonStringOutput* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_stringBuffer = [[NSMutableString alloc] init];
	
	
	return answer;
}

-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	[self setStringBuffer:nil];
	 

}
	 
#pragma mark fields

//NSMutableString* _stringBuffer;
//@property (nonatomic, retain) NSMutableString* stringBuffer;
@synthesize stringBuffer = _stringBuffer;

@end

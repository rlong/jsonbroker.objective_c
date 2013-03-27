// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonOutput.h"

@interface JBJsonStringOutput : NSObject <JBJsonOutput>{
	

	NSMutableString* _stringBuffer;
	//@property (nonatomic, retain) NSMutableString* stringBuffer;
	//@synthesize stringBuffer = _stringBuffer;
	
}


-(void)reset;
-(void)appendChar:(unichar)c;
-(void)appendString:(NSString*)string;
-(NSString*)toString;
	

@end

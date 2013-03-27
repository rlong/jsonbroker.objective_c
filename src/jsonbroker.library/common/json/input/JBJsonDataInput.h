// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJsonInput.h"

@interface JBJsonDataInput : JBJsonInput {
	
	
	NSData* _data;
	//@property (nonatomic, retain) NSData* data;
	//@synthesize data = _data;
	
	int _cursor;
	//@property (nonatomic, readonly) int cursor;
	//@synthesize cursor = _cursor;
	


}

-(BOOL)hasNextByte;
-(UInt8)currentByte;
-(UInt8)nextByte;



#pragma mark instance lifecycle

-(id)initWithData:(NSData*)data;

#pragma mark fields


//int _cursor;
@property (nonatomic, readonly) int cursor;
//@synthesize cursor = _cursor;

@end

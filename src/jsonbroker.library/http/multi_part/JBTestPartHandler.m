// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBTestPartHandler.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBTestPartHandler ()





@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBTestPartHandler



#pragma mark -
#pragma mark <JBPartHandler> implementation


-(void)handleHeaderWithName:(NSString*)name value:(NSString*)value  {
    
}

-(void)handleBytes:(const UInt8*)bytes offset:(NSUInteger)offset length:(NSUInteger)length  {
    
    const void* start = &bytes[offset];
    [_data appendBytes:start length:length];
    
}

-(void)handleFailure:(BaseException*)e {
    Log_errorException(e);
}

-(void)partCompleted {
}



#pragma mark -
#pragma mark instance lifecycle

-(id)init {
    
    JBTestPartHandler* answer = [super init];
    
    if( nil != answer ) {
        answer->_data = [[NSMutableData alloc] init];
    }
    
    
    return answer;
    
    
}

-(void)dealloc {
	
	[self setData:nil];
	
	
}

#pragma mark -
#pragma mark fields

// data
//NSMutableData* _data;
//@property (nonatomic, retain) NSMutableData* data;
@synthesize data = _data;




@end

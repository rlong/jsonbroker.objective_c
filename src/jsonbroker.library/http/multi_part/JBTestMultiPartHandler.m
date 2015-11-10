// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBTestMultiPartHandler.h"
#import "JBTestPartHandler.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBTestMultiPartHandler ()




@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBTestMultiPartHandler


-(bool)haveFoundCloseDelimiter {
    return _foundCloseDelimiter;
}

#pragma mark -
#pragma mark <JBMultiPartHandler> implementation

-(id<JBPartHandler>)foundPartDelimiter {
    
    JBTestPartHandler* answer = [[JBTestPartHandler alloc] init];
    {
        [_partHandlers addObject:answer];
    }
    [answer release];
    
    return answer;
    
}

-(void)handleExceptionZZZ:(BaseException*)e {
    
    Log_errorException(e);

}

-(void)foundCloseDelimiter {
    
    _foundCloseDelimiter = true;
    
    
}

#pragma mark -
#pragma mark instance lifecycle


-(id)init {
    
    
    JBTestMultiPartHandler* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_partHandlers = [[NSMutableArray alloc] init];
        answer->_foundCloseDelimiter = false;
        
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setPartHandlers:nil];
	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields

// partHandlers
//NSMutableArray* _partHandlers;
//@property (nonatomic, retain) NSMutableArray* partHandlers;
@synthesize partHandlers = _partHandlers;

@end

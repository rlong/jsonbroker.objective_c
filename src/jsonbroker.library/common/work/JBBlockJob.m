//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBlockJob.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBlockJob ()

// block
//BlockJobDelegate _block;
@property (nonatomic, copy) BlockJobDelegate block;
//@synthesize block = _block;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBBlockJob


#pragma mark -
#pragma mark <JBJob> implementation

-(void)execute {
    
    

    _block();
    
    
}



#pragma mark -
#pragma mark instance lifecycle

-(id)initWithBlock:(BlockJobDelegate)block {
    
    JBBlockJob* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setBlock:block];
        
    }
    
    
    return answer;
    
    
}

-(void)dealloc {
	
	[self setBlock:nil];
	
	[super dealloc];
	
}


#pragma mark -
#pragma mark fields

// block
//BlockJobDelegate _block;
//@property (nonatomic, copy) BlockJobDelegate block;
@synthesize block = _block;


@end

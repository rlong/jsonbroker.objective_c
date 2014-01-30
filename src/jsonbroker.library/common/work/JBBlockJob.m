//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBBlockJob.h"
#import "JBLog.h"
#import "JBWorkManager.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBlockJob ()

// context
//id _context;
@property (nonatomic, retain) id context;
//@synthesize context = _context;

// block
//JBBlock _block;
@property (nonatomic, copy) jbBlock block;
//@synthesize block = _block;

// blockResponse
//id _blockResponse;
@property (nonatomic, retain) id blockResponse;
//@synthesize blockResponse = _blockResponse;

// blockDone
//JBBlockDone _blockDone;
@property (nonatomic, copy) jbBlockDone blockDone;
//@synthesize blockDone = _blockDone;

// blockFailed
//JBBlockFailed _blockFailed;
@property (nonatomic, copy) jbBlockFailed blockFailed;
//@synthesize blockFailed = _blockFailed;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBBlockJob


#pragma mark -
#pragma mark <JBJob> implementation

-(void)execute {
    
    if( nil == _block ) {
        Log_warn(@"nil == _block");
        return;
    }
    
    
    JBBaseException *exceptionCaught = nil;
    
    @try {
        
        id blockResponse = _block(_context);
        [self setBlockResponse:blockResponse];
    }
    @catch (JBBaseException *exception) {
        
        exceptionCaught = exception;
        
        if( nil != _blockFailed ) {
            
            // vvv http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                @try {
                    _blockFailed( _context, exception );
                }
                @catch (NSException *exception) {
                    Log_errorException( exception );
                }
                
            });
            
            // ^^^ http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
        } else {
            Log_errorException( exception );
        }
        
        // we are not 'done' so we return ...
        return;
        
    }
    
    if( nil == exceptionCaught ) { // if we completed the call to '_asyncAdaptee' successfully ...
        if( nil != _blockDone ) {
            
            // vvv http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                @try {
                    _blockDone( _context, _blockResponse );
                }
                @catch (NSException *exception) {
                    Log_errorException( exception );
                }
            });
            // ^^^ http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
        }
    }

}



+(void)executeWithContext:(id)context block:(jbBlock)block {
    
    JBBlockJob* job = [[JBBlockJob alloc] initWithContext:context block:block];
    {
        
        [JBWorkManager enqueue:job];
        
    }

    [job release];

}

+(void)executeWithContext:(id)context block:(jbBlock)block onBlockDone:(jbBlockDone)blockDone onBlockFailed:(jbBlockFailed) blockFailed {

    JBBlockJob* job = [[JBBlockJob alloc] initWithContext:context block:(jbBlock)block onBlockDone:(jbBlockDone)blockDone onBlockFailed:(jbBlockFailed) blockFailed];
    {
        
        [JBWorkManager enqueue:job];
        
    }
    
    [job release];

}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithContext:(id)context block:(jbBlock)block {
    
    JBBlockJob* answer = [super init];
    
    if( nil != answer ) {
        [answer setContext:context];
        [answer setBlock:block];
        [answer setBlockDone:nil];
        [answer setBlockFailed:nil];
    }
    
    return answer;
    
}

-(id)initWithContext:(id)context block:(jbBlock)block onBlockDone:(jbBlockDone)blockDone onBlockFailed:(jbBlockFailed) blockFailed {
    
    JBBlockJob* answer = [super init];
    
    if( nil != answer ) {
        [answer setContext:context];
        [answer setBlock:block];
        [answer setBlockDone:blockDone];
        [answer setBlockFailed:blockFailed];
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setContext:nil];
    [self setBlock:nil];
	[self setBlockResponse:nil];
	[self setBlockDone:nil];
	[self setBlockFailed:nil];

	[super dealloc];
	
}



#pragma mark -
#pragma mark fields

// context
//id _context;
//@property (nonatomic, retain) id context;
@synthesize context = _context;


// block
//JBBlock _block;
//@property (nonatomic, copy) JBBlock block;
@synthesize block = _block;


// blockResponse
//id _blockResponse;
//@property (nonatomic, retain) id blockResponse;
@synthesize blockResponse = _blockResponse;

// blockDone
//JBBlockDone _blockDone;
//@property (nonatomic, copy) JBBlockDone blockDone;
@synthesize blockDone = _blockDone;

// blockFailed
//JBBlockFailed _blockFailed;
//@property (nonatomic, copy) JBBlockFailed blockFailed;
@synthesize blockFailed = _blockFailed;


@end

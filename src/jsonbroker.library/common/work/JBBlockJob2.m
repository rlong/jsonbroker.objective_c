//
//  JBBlockJob2.m
//  jsonbroker
//
//  Created by rlong on 5/03/2014.
//
//

#import "JBBaseException.h"
#import "JBBlockJob2.h"
#import "JBLog.h"
#import "JBWorkManager.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBlockJob2 ()

// block
//JBBlock _block;
@property (nonatomic, copy) jbBlock2 block;
//@synthesize block = _block;

// blockDone
//JBBlockDone _blockDone;
@property (nonatomic, copy) jbBlockDone2 blockDone;
//@synthesize blockDone = _blockDone;

// blockFailed
//JBBlockFailed _blockFailed;
@property (nonatomic, copy) jbBlockFailed2 blockFailed;
//@synthesize blockFailed = _blockFailed;

// blockResponse
//id _blockResponse;
@property (nonatomic, retain) id blockResponse;
//@synthesize blockResponse = _blockResponse;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBBlockJob2



#pragma mark -
#pragma mark <JBJob> implementation

-(void)execute {
    
    if( nil == _block ) {
        Log_warn(@"nil == _block");
        return;
    }
    
    JBBaseException *exceptionCaught = nil;
    
    @try {
        id blockResponse = _block();
        [self setBlockResponse:blockResponse];
    }
    @catch (JBBaseException *exception) {
        
        exceptionCaught = exception;
        
        if( nil != _blockFailed ) {
            
            // vvv http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                @try {
                    _blockFailed( exception );
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
                    _blockDone();
                }
                @catch (NSException *exception) {
                    Log_errorException( exception );
                }
            });
            // ^^^ http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
        }
    }

}



+(void)executeWithBlock:(jbBlock2)block {
    
    JBBlockJob2* job = [[JBBlockJob2 alloc] initWithBlock:block];
    {
        
        [JBWorkManager enqueue:job];
        
    }
    
    [job release];
    
}

+(void)executeWithBlock:(jbBlock2)block onBlockDone:(jbBlockDone2)blockDone onBlockFailed:(jbBlockFailed2) blockFailed {
    
    JBBlockJob2* job = [[JBBlockJob2 alloc] initWithBlock:(jbBlock2)block onBlockDone:(jbBlockDone2)blockDone onBlockFailed:(jbBlockFailed2) blockFailed];
    {
        
        [JBWorkManager enqueue:job];
        
    }
    
    [job release];
    
}


#pragma mark -
#pragma mark instance lifecycle



-(id)initWithBlock:(jbBlock2)block {
    
    JBBlockJob2* answer = [super init];
    
    if( nil != answer ) {
        [answer setBlock:block];
        [answer setBlockDone:nil];
        [answer setBlockFailed:nil];
    }
    
    return answer;
    
}


-(id)initWithBlock:(jbBlock2)block onBlockDone:(jbBlockDone2)blockDone onBlockFailed:(jbBlockFailed2)blockFailed {
    
    JBBlockJob2* answer = [super init];
    
    if( nil != answer ) {
        [answer setBlock:block];
        [answer setBlockDone:blockDone];
        [answer setBlockFailed:blockFailed];
    }
    
    return answer;
    
}

-(void)dealloc {
	
    [self setBlock:nil];
	[self setBlockDone:nil];
	[self setBlockFailed:nil];
    [self setBlockResponse:nil];

	[super dealloc];
	
}



#pragma mark -
#pragma mark fields


// block
//JBBlock _block;
//@property (nonatomic, copy) JBBlock block;
@synthesize block = _block;


// blockDone
//JBBlockDone _blockDone;
//@property (nonatomic, copy) JBBlockDone blockDone;
@synthesize blockDone = _blockDone;

// blockFailed
//JBBlockFailed _blockFailed;
//@property (nonatomic, copy) JBBlockFailed blockFailed;
@synthesize blockFailed = _blockFailed;

// blockResponse
//id _blockResponse;
//@property (nonatomic, retain) id blockResponse;
@synthesize blockResponse = _blockResponse;

@end

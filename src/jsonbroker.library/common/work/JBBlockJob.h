//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBJob.h"

@class JBBaseException;

typedef id(^jbBlock)(id context);
typedef void(^jbBlockDone)(id context, id blockResponse);
typedef void(^jbBlockFailed)(id context, JBBaseException* exceptionThrown);


@interface JBBlockJob : NSObject <JBJob> {
    
    // context
    id _context;
    //@property (nonatomic, retain) id context;
    //@synthesize context = _context;

    // block
    jbBlock _block;
    //@property (nonatomic, copy) JBBlock block;
    //@synthesize block = _block;
    
    // blockResponse
    id _blockResponse;
    //@property (nonatomic, retain) id blockResponse;
    //@synthesize blockResponse = _blockResponse;

    
    // blockDone
    jbBlockDone _blockDone;
    //@property (nonatomic, copy) JBBlockDone blockDone;
    //@synthesize blockDone = _blockDone;

    // blockFailed
    jbBlockFailed _blockFailed;
    //@property (nonatomic, copy) JBBlockFailed blockFailed;
    //@synthesize blockFailed = _blockFailed;

    
}

+(void)executeWithContext:(id)context block:(jbBlock)block;
+(void)executeWithContext:(id)context block:(jbBlock)block onBlockDone:(jbBlockDone)blockDone onBlockFailed:(jbBlockFailed) blockFailed;

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithContext:(id)context block:(jbBlock)block;
-(id)initWithContext:(id)context block:(jbBlock)block onBlockDone:(jbBlockDone)blockDone onBlockFailed:(jbBlockFailed) blockFailed;

@end

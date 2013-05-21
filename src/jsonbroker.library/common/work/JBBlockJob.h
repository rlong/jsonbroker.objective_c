//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBBaseException.h"
#import "JBJob.h"


typedef id(^JBBlock)(id context);
typedef void(^JBBlockDone)(id context, id blockResponse);
typedef void(^JBBlockFailed)(id context, JBBaseException* exceptionThrown);


@interface JBBlockJob : NSObject <JBJob> {
    
    // context
    id _context;
    //@property (nonatomic, retain) id context;
    //@synthesize context = _context;

    // block
    JBBlock _block;
    //@property (nonatomic, copy) JBBlock block;
    //@synthesize block = _block;
    
    // blockResponse
    id _blockResponse;
    //@property (nonatomic, retain) id blockResponse;
    //@synthesize blockResponse = _blockResponse;

    
    // blockDone
    JBBlockDone _blockDone;
    //@property (nonatomic, copy) JBBlockDone blockDone;
    //@synthesize blockDone = _blockDone;

    // blockFailed
    JBBlockFailed _blockFailed;
    //@property (nonatomic, copy) JBBlockFailed blockFailed;
    //@synthesize blockFailed = _blockFailed;

    
}

+(void)executeWithContext:(id)context block:(JBBlock)block;
+(void)executeWithContext:(id)context block:(JBBlock)block onBlockDone:(JBBlockDone)blockDone onBlockFailed:(JBBlockFailed) blockFailed;

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithContext:(id)context block:(JBBlock)block;
-(id)initWithContext:(id)context block:(JBBlock)block onBlockDone:(JBBlockDone)blockDone onBlockFailed:(JBBlockFailed) blockFailed;

@end

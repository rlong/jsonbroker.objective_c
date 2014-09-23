//
//  JBBlockJob2.h
//  jsonbroker
//
//  Created by rlong on 5/03/2014.
//
//

#import <Foundation/Foundation.h>


#import "JBBaseException.h"
#import "JBJob.h"


typedef id(^jbBlock2)();
typedef void(^jbBlockDone2)();
typedef void(^jbBlockFailed2)(JBBaseException* exceptionThrown);


@interface JBBlockJob2 : NSObject <JBJob> {
    
    // block
    jbBlock2 _block;
    //@property (nonatomic, copy) JBBlock block;
    //@synthesize block = _block;
    
    // blockDone
    jbBlockDone2 _blockDone;
    //@property (nonatomic, copy) JBBlockDone blockDone;
    //@synthesize blockDone = _blockDone;
    
    // blockFailed
    jbBlockFailed2 _blockFailed;
    //@property (nonatomic, copy) JBBlockFailed blockFailed;
    //@synthesize blockFailed = _blockFailed;
    
    // blockResponse
    id _blockResponse;
    //@property (nonatomic, retain) id blockResponse;
    //@synthesize blockResponse = _blockResponse;


    
}


+(void)executeWithBlock:(jbBlock2)block;
+(void)executeWithBlock:(jbBlock2)block onBlockDone:(jbBlockDone2)blockDone onBlockFailed:(jbBlockFailed2) blockFailed;


@end

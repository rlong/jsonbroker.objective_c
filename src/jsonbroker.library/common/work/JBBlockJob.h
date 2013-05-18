//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBJob.h"


typedef void(^BlockJobDelegate)(void);


@interface JBBlockJob : NSObject <JBJob> {
    
    
    // block
    BlockJobDelegate _block;
    //@property (nonatomic, copy) BlockJobDelegate block;
    //@synthesize block = _block;
    
}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithBlock:(BlockJobDelegate)block;


@end

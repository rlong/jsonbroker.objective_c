//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJob.h"
#import "JBJobListener.h"

@interface JBWorkManager : NSObject

+(void)start;

+(void)enqueue:(id<JBJob>)request;
+(void)enqueue:(id<JBJob>)request listener:(id<JBJobListener>)listener;


@end

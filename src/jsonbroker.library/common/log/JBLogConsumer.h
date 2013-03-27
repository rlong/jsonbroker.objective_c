//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@protocol JBLogConsumer <NSObject>

-(void)logMessage:(NSString*)message forFunction:(const char *)function atLevel:(NSString*)level;


@end

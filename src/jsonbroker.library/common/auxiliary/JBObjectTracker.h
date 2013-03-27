// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@interface JBObjectTracker : NSObject {

}

+(void)allocated:(id)object;
+(void)deallocated:(id)object;
+(void)reportForCaller:(const char*)caller;

@end

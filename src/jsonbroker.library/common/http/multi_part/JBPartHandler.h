// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBBaseException.h"

@protocol JBPartHandler <NSObject>

-(void)handleHeaderWithName:(NSString*)name value:(NSString*)value;
-(void)handleBytes:(const UInt8*)bytes offset:(NSUInteger)offset length:(NSUInteger)length;

-(void)handleException:(BaseException*)e;

-(void)partCompleted;

@end

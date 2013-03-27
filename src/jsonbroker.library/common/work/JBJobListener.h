//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBBaseException.h"

#import "JBJob.h"

@protocol JBJobListener <NSObject>

-(void)jobCompleted:(id<JBJob>)job;
-(void)jobFailed:(id<JBJob>)job withException:(BaseException*)exception;


@end

//
//  JBMainThreadJobListener2.h
//  jsonbroker
//
//  Created by rlong on 25/03/13.
//
//

#import <Foundation/Foundation.h>

#import "JBJobListener.h"

@protocol JBMainThreadJobListener2 <JBJobListener>

-(bool)jobListenerIsRunning;


@end

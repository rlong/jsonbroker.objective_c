//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBLog.h"


@interface JBSimpleLogConsumer : NSObject <JBLogConsumer> {
    
    NSMutableArray *_logEntries;
    //@property (nonatomic, retain) NSMutableArray *logEntries;
    //@synthesize logEntries = _logEntries;

 
    int _start;
	int _next;

}

-(NSArray*)getRecentLogEntries;


-(void)reset;

@end

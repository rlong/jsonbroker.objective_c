//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@class JBBaseException;
#import "JBJob.h"
@protocol JBJobListener;

@interface JBListenedJob : NSObject <JBJob> {
    
    // delegate
	id<JBJob> _delegate;
	//@property (nonatomic, retain) id<Job> delegate;
	//@synthesize delegate = _delegate;

    // listener
	id<JBJobListener> _listener;
	//@property (nonatomic, retain) id<JobListener> listener;
	//@synthesize listener = _listener;
    
    
    // exceptionCaughtDuringExecute
    JBBaseException* _exceptionCaughtDuringExecute;
    //@property (nonatomic, retain) JBBaseException* exceptionCaughtDuringExecute;
    //@synthesize exceptionCaughtDuringExecute = _exceptionCaughtDuringExecute;


    
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithDelegate:(id<JBJob>)delegate listener:(id<JBJobListener>)listener;

@end

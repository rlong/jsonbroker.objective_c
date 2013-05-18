//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBJob.h"
#import "JBJobListener.h"

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
    BaseException* _exceptionCaughtDuringExecute;
    //@property (nonatomic, retain) BaseException* exceptionCaughtDuringExecute;
    //@synthesize exceptionCaughtDuringExecute = _exceptionCaughtDuringExecute;


    
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithDelegate:(id<JBJob>)delegate listener:(id<JBJobListener>)listener;

@end

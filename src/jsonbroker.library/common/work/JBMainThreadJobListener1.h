//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBJobListener.h"

@interface JBMainThreadJobListener1 : NSObject <JBJobListener> {
    
    // delegate
	id<JBJobListener> _delegate;
	//@property (nonatomic, retain) id<JobListener> delegate;
	//@synthesize delegate = _delegate;

    bool _enabled;
    
}


-(void)enable;
-(void)disable;
-(bool)isEnabled;


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithDelegate:(id<JBJobListener>)delegate;
-(id)init;


#pragma mark -
#pragma mark fields


// delegate
//id<JobListener> _delegate;
@property (nonatomic, assign) id<JBJobListener> delegate;
//@synthesize delegate = _delegate;



@end

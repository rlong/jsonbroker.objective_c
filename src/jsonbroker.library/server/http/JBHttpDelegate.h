//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



@class JBFileHandle;
@protocol JBRequestHandler;

#import "JBConnectionDelegate.h"


@interface JBHttpDelegate : NSObject  <JBConnectionDelegate> {
	
    
	// httpProcessor
	id<JBRequestHandler> _httpProcessor;
	//@property (nonatomic, retain) id<HttpProcessor> httpProcessor;
	//@synthesize httpProcessor = _httpProcessor;

}


#pragma mark -
#pragma mark instance setup/teardown


-(id)initWithRequestHandler:(id<JBRequestHandler>)httpProcessor;



@end

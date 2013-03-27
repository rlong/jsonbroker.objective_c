//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBGuiService.h"

@interface JBGuiServiceDelegator : NSObject <JBService> {

	id<JBGuiService> _delegate;
	//@property (nonatomic, retain) id<UserInterfaceService> delegate;
	//@synthesize delegate = _delegate;
	
	NSException* _exception;
	//@property (nonatomic, retain) NSException* exception;
	//@synthesize exception = _exception;
	
	JBBrokerMessage* _response;
	//@property (nonatomic, retain) BrokerMessage* response;
	//@synthesize response = _response;
	
}

#pragma mark instance lifecycle 

-(id)initWithDelegate:(id<JBGuiService>)delegate;


#pragma mark fields

//id<UserInterfaceService> _delegate;
@property (nonatomic, retain) id<JBGuiService> delegate;
//@synthesize delegate = _delegate;

	
@end

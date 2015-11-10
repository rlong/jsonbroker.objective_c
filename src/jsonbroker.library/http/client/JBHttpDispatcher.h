// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBAuthenticator.h"
#import "JBHttpRequestAdapter.h"
#import "JBNetworkAddress.h"
#import "JBHttpResponseHandler.h"




@interface JBHttpDispatcher : NSObject {
	
	JBNetworkAddress* _networkAddress;
	//@property (nonatomic, retain) NetworkAddress* networkAddress;
	//@synthesize networkAddress = _networkAddress;

	
}



-(void)get:(JBHttpRequestAdapter*)requestAdapter authenticator:(JBAuthenticator*)authenticator responseHandler:(id<JBHttpResponseHandler>)responseHandler;
-(void)get:(JBHttpRequestAdapter*)requestAdapter responseHandler:(id<JBHttpResponseHandler>)responseHandler;

-(void)post:(JBHttpRequestAdapter*)requestAdapter authenticator:(JBAuthenticator*)authenticator responseHandler:(id<JBHttpResponseHandler>)responseHandler;
-(void)post:(JBHttpRequestAdapter*)requestAdapter responseHandler:(id<JBHttpResponseHandler>)responseHandler;


#pragma mark instance lifecycle


-(id)initWithNetworkAddress:(JBNetworkAddress*)networkAddress;



#pragma mark fields

//NetworkAddress* _networkAddress;
@property (nonatomic, retain) JBNetworkAddress* networkAddress;
//@synthesize networkAddress = _networkAddress;





@end



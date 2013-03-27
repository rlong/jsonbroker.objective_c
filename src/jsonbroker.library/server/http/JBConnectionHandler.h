//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBFileHandle.h"
#import "JBRequestHandler.h"



@interface JBConnectionHandler : NSObject {
	
	
    // socket
	JBFileHandle* _socket;
	//@property (nonatomic, retain) JBFileDescriptor* socket;
	//@synthesize socket = _socket;

    
    
    // inputStream
    NSInputStream* _inputStream;
    //@property (nonatomic, retain) NSInputStream* inputStream;
    //@synthesize inputStream = _inputStream;


    // outputStream
    NSOutputStream* _outputStream;
    //@property (nonatomic, retain) NSOutputStream* outputStream;
    //@synthesize outputStream = _outputStream;

    NSTimer* _callbackTimer;
	//@property (nonatomic, retain) NSTimer* callbackTimer;
	//@synthesize callbackTimer = _callbackTimer;
    
	// httpProcessor
	id<JBRequestHandler> _httpProcessor;
	//@property (nonatomic, retain) id<HttpProcessor> httpProcessor;
	//@synthesize httpProcessor = _httpProcessor;

}


+(void)handleConnection:(JBFileHandle*)fileDescriptor httpProcessor:(id<JBRequestHandler>)httpProcessor;



@end

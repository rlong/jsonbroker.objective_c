//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@protocol JBConnectionDelegate;
@class JBFileHandle;
@protocol JBRequestHandler;


@interface JBConnectionHandler : NSObject {
    
    // delegate
    id<JBConnectionDelegate> _delegate;
    //@property (nonatomic, retain) id<JBConnectionDelegate> delegate;
    //@synthesize delegate = _delegate;
    
    
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
    
}


+(void)handleConnection:(JBFileHandle*)fileDescriptor httpProcessor:(id<JBRequestHandler>)httpProcessor;



@end

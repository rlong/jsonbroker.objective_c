//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBConnectionDelegate.h"
@class JBFileHandle;
@class JBTextWebSocket;



@interface JBEchoWebSocket : NSObject <JBConnectionDelegate> {

    // echoWebSocket
    JBTextWebSocket* _echoWebSocket;
    //@property (nonatomic, retain) JBTextWebSocket* echoWebSocket;
    //@synthesize echoWebSocket = _echoWebSocket;
    
    // socket
    JBFileHandle* _socket;
    //@property (nonatomic, retain) JBFileHandle* socket;
    //@synthesize socket = _socket;

}

@end

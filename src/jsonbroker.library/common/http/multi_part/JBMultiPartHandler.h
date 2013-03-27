// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "JBBaseException.h"
#import "JBPartHandler.h"

@protocol JBMultiPartHandler <NSObject>


-(id<JBPartHandler>)foundPartDelimiter;

-(void)handleException:(BaseException*)e;

-(void)foundCloseDelimiter;

@end

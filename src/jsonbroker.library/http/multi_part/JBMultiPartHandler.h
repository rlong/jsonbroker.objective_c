// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "JBBaseException.h"
#import "JBPartHandler.h"

@protocol JBMultiPartHandler <NSObject>


-(id<JBPartHandler>)foundPartDelimiter;


// gives a warning in "iOS App" validation
-(void)handleExceptionZZZ:(BaseException*)e;

-(void)foundCloseDelimiter;

@end

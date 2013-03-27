// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBBaseException.h"

@interface JBJsonBrokerException : BaseException


#pragma mark instance lifecycle

-(id)initWithOriginator:(NSString*)originator faultMessage:(NSString *)faultMessage;
-(id)initWithOriginator:(id)originatingObject line:(int)line faultMessage:(NSString *)faultString;
-(id)initWithOriginator:(id)originatingObject line:(int)line faultStringFormat:(NSString *)faultStringFormat, ...;
-(id)initWithOriginator:(id)originatingObject line:(int)line callTo:(NSString*)methodName failedWithErrno:(int)value;
-(id)initWithOriginator:(id)originatingObject line:(int)line callTo:(NSString*)methodName failedWithError:(NSError*)error;
-(id)initWithOriginator:(id)originatingObject line:(int)line cause:(NSException*)cause;

@end

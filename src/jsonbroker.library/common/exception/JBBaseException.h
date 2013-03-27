// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "BaseException.h"

@interface JBBaseException : BaseException {
    
}



#pragma mark instance lifecycle


+(JBBaseException*)baseExceptionWithOriginator:(id)originatingObject line:(int)line faultString:(NSString *)faultString;
+(JBBaseException*)baseExceptionWithOriginator:(id)originatingObject line:(int)line faultStringFormat:(NSString *)format, ...;
+(JBBaseException*)baseExceptionWithOriginator:(id)originatingObject line:(int)line callTo:(NSString*)methodName failedWithError:(NSError*)error;


@end



// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface JBStreamHelper : NSObject


+(NSString*)ERROR_DOMAIN_BROKEN_PIPE;

+(void)closeStream:(NSStream*)stream swallowErrors:(BOOL)swallowErrors caller:(id)caller;



@end

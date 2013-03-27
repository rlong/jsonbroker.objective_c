// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBJsonArray.h"

@interface JBExceptionHelper : NSObject


+(JBJsonArray*)getStackTrace:(NSException*)e;

+(NSString*)getAtosCommand:(NSException*)e;


@end

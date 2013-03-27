//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBBaseException.h"
#import "JBHttpResponse.h"

@interface JBHttpErrorHelper : NSObject


+(BaseException*)badRequest400FromOriginator:(id)originator line:(int)line;
+(BaseException*)unauthorized401FromOriginator:(id)originator line:(int)line;
+(BaseException*)forbidden403FromOriginator:(id)originator line:(int)line;
+(BaseException*)notFound404FromOriginator:(id)originator line:(int)line;
+(BaseException*)requestEntityTooLarge413FromOriginator:(id)originator line:(int)line;

+(BaseException*)internalServerError500FromOriginator:(id)originator line:(int)line;
+(BaseException*)notImplemented501FromOriginator:(id)originator line:(int)line;

+(JBHttpResponse*)toHttpResponse:(NSException*)e;

@end

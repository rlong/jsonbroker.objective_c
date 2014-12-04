//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@class JBBaseException;
@class JBHttpResponse;

@interface JBHttpErrorHelper : NSObject


+(JBBaseException*)badRequest400FromOriginator:(id)originator line:(int)line;
+(JBBaseException*)unauthorized401FromOriginator:(id)originator line:(int)line;
+(JBBaseException*)forbidden403FromOriginator:(id)originator line:(int)line;
+(JBBaseException*)notFound404FromOriginator:(id)originator line:(int)line;
+(JBBaseException*)requestEntityTooLarge413FromOriginator:(id)originator line:(int)line;

+(JBBaseException*)internalServerError500FromOriginator:(id)originator line:(int)line;
+(JBBaseException*)notImplemented501FromOriginator:(id)originator line:(int)line;

+(JBHttpResponse*)toHttpResponse:(NSException*)e;

@end

//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBDataEntity.h"
#import "JBHttpErrorHelper.h"
#import "JBHttpResponse.h"
#import "JBHttpStatus.h"

#import "JBEntity.h"


@implementation JBHttpErrorHelper

+(JBBaseException*)buildException:(id)originator line:(int)line statusCode:(int)statusCode {
    
    NSString* reason = [JBHttpStatus getReason:statusCode];
    
    JBBaseException* answer = [[JBBaseException alloc] initWithOriginator:originator line:line faultMessage:reason];
    [answer autorelease];
    [answer setFaultCode:statusCode];
    
    return answer;
}

+(JBBaseException*)badRequest400FromOriginator:(id)originator line:(int)line {
  
    JBBaseException* answer = [self buildException:originator line:line statusCode:HttpStatus_BAD_REQUEST_400];
    [answer setErrorDomain:[[JBHttpStatus errorDomain] BAD_REQUEST_400]];
    return answer;
}

+(JBBaseException*)unauthorized401FromOriginator:(id)originator line:(int)line {
    JBBaseException* answer = [self buildException:originator line:line statusCode:HttpStatus_UNAUTHORIZED_401];
    [answer setErrorDomain:[[JBHttpStatus errorDomain] UNAUTHORIZED_401]];
    return answer;
}

+(JBBaseException*)forbidden403FromOriginator:(id)originator line:(int)line {
    return [self buildException:originator line:line statusCode:HttpStatus_FORBIDDEN_403];
}

+(JBBaseException*)notFound404FromOriginator:(id)originator line:(int)line {
    JBBaseException* answer =  [self buildException:originator line:line statusCode:HttpStatus_NOT_FOUND_404];
    [answer setErrorDomain:[[JBHttpStatus errorDomain] NOT_FOUND_404]];
    return answer;
}


+(JBBaseException*)requestEntityTooLarge413FromOriginator:(id)originator line:(int)line {
    return [self buildException:originator line:line statusCode:HttpStatus_REQUEST_ENTITY_TOO_LARGE_413];
}


+(JBBaseException*)internalServerError500FromOriginator:(id)originator line:(int)line {
    return [self buildException:originator line:line statusCode:HttpStatus_INTERNAL_SERVER_ERROR_500];
}

+(JBBaseException*)notImplemented501FromOriginator:(id)originator line:(int)line {
    return [self buildException:originator line:line statusCode:HttpStatus_NOT_IMPLEMENTED_501];
}

+(id<JBEntity>)toEntity:(int)statusCode { 
    NSString* statusString = [JBHttpStatus getReason:statusCode];
    
    NSString* responseTemplate = @"<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\"><html><head><title>%d %@</title></head><body><h1>%@</h1></body></html>";
    NSString* messageBody = [NSString stringWithFormat:responseTemplate, statusCode, statusString,statusString];
    
    NSData* data=[messageBody dataUsingEncoding:NSUTF8StringEncoding];
    
    JBDataEntity* answer = [[JBDataEntity alloc] initWithData:data];
    [answer autorelease];
    return answer;
    
}

+(JBHttpResponse*)toHttpResponse:(NSException*)e {
    
    int statusCode = HttpStatus_INTERNAL_SERVER_ERROR_500;
    
    if( [e isKindOfClass:[BaseException class]] ){ 
        
        BaseException* baseException = (BaseException*)e;
        
        int faultCode = [baseException faultCode];
        
        // does BaseException have what looks like a HTTP CODE ?
        if( 0 < faultCode &&  faultCode < 1000 ) {
            statusCode = faultCode;
        }
    }
  
    id<JBEntity> entity = [self toEntity:statusCode];
    JBHttpResponse* answer = [[JBHttpResponse alloc] initWithStatus:statusCode entity:entity];
    [answer autorelease];
    return answer;
    
    
}



@end

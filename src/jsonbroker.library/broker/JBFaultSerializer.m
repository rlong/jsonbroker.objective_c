// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBExceptionHelper.h"
#import "JBFaultSerializer.h"

@implementation JBFaultSerializer




+(JBJsonObject*)baseExceptionToJSONObject:(BaseException*)baseException {
    
    
    JBJsonObject* answer = [[JBJsonObject alloc] init];
    [answer autorelease];
    
    [answer setObject:[baseException errorDomain] forKey:@"errorDomain"]; // nil is OK
    
    int fault_code = [baseException faultCode];
    [answer setInt:fault_code forKey:@"faultCode"];
    
    [answer setObject:[baseException reason] forKey:@"faultMessage"];
    [answer setObject:[baseException underlyingFaultMessage] forKey:@"underlyingFaultMessage"];
    
    [answer setObject:[baseException originator] forKey:@"originator"];
    
    JBJsonArray* stackTrace = [JBExceptionHelper getStackTrace:baseException];
    [answer setObject:stackTrace forKey:@"stackTrace"];
    
    JBJsonObject* faultContext = [[JBJsonObject alloc] init];
    [faultContext setObject:[JBExceptionHelper getAtosCommand:baseException] forKey:@"atos"];
    [answer setObject:faultContext forKey:@"faultContext"];
    [faultContext autorelease];	 
    
    return answer;
    
}


+(JBJsonObject*)toJSONObject:(NSException*)exception {
    
    if( [exception isKindOfClass:[BaseException class]] ) { 
        return [self baseExceptionToJSONObject:(BaseException*)exception];
    }
    
    JBJsonObject* answer = [[JBJsonObject alloc] init];
    [answer autorelease];

    [answer setObject:nil forKey:@"errorDomain"];

    [answer setInt:[BaseException defaultFaultCode] forKey:@"faultCode"];
    [answer setObject:[exception reason] forKey:@"faultMessage"];
    [answer setObject:[exception reason] forKey:@"underlyingFaultMessage"];

    
    JBJsonArray* stackTrace = [JBExceptionHelper getStackTrace:exception];
    [answer setObject:stackTrace forKey:@"stackTrace"];
    
    [answer setObject:@"?" forKey:@"originator"];
    
    JBJsonObject* faultContext = [[JBJsonObject alloc] init];
    [faultContext setObject:[JBExceptionHelper getAtosCommand:exception] forKey:@"atos"];
    [faultContext autorelease];
    [answer setObject:faultContext forKey:@"faultContext"];
    
    return answer;

}

+(JBBaseException*)toBaseException:(JBJsonObject*)jsonObject {
    
    NSString* originator = [jsonObject stringForKey:@"originator" defaultValue:@"NULL"];
    NSString* fault_string = [jsonObject stringForKey:@"faultMessage" defaultValue:@"NULL"];
    
    JBBaseException* answer = [[JBBaseException alloc] initWithOriginator:originator faultMessage:fault_string];
    [answer autorelease];
    

    {
        NSString* errorDomain = [jsonObject stringForKey:@"errorDomain" defaultValue:nil];
        [answer setErrorDomain:errorDomain];
    }

    int fault_code = [jsonObject intForKey:@"faultCode" defaultValue:[BaseException defaultFaultCode]];
    [answer setFaultCode:fault_code];
    
    NSString* underlyingFaultMessage = [jsonObject stringForKey:@"underlyingFaultMessage" defaultValue:nil];
    [answer setUnderlyingFaultMessage:underlyingFaultMessage];
    
    JBJsonArray* stack_trace = [jsonObject jsonArrayForKey:@"stackTrace" defaultValue:nil];
    if( nil != stack_trace ) {
        for( int i  = 0, count = [stack_trace count]; i < count; i++ ) { 
            NSString* key = [NSString stringWithFormat:@"cause[%d]", i];
            NSString* value = [stack_trace getString:i defaultValue:@"NULL"];
            [answer addStringContext:value withName:key];
        }
    }
    
    JBJsonObject* fault_context = [jsonObject jsonObjectForKey:@"faultContext" defaultValue:nil];
    if( nil != fault_context ) {
        
        NSArray* allKeys = [fault_context allKeys];
        
        for( long i = 0, count = [allKeys count]; i < count; i++ ) {
            NSString* key = [allKeys objectAtIndex:i];
            id value = [fault_context objectForKey:key];
            if( nil != value && [value isKindOfClass:[NSString class]] ) {
                [answer addStringContext:(NSString*)value withName:key];
            }
        }
    }
    return answer;
    
}






         

@end

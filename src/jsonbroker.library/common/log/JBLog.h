//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBLoggable.h"
#import "JBLogConsumer.h"


@interface JBLog : NSObject  {
}



///////////////////////////////////////////////////////////

+(void)setLogConsumer:(id <JBLogConsumer>)logConsumer forCaller:(const char *)caller;
+(id <JBLogConsumer>)getLogConsumer;


#pragma mark -
#pragma mark Debug

#ifdef DEBUG
#define Log_isDebugEnabled() TRUE
#else
#define Log_isDebugEnabled() FALSE
#endif


+ (void)debug:(NSString *)message inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debug(message) [JBLog debug:message inFunction:__func__]
#else
#define Log_debug(message)
#endif


+(void)debugBool:(BOOL)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugBool(value) [JBLog debugBool:value withName:#value inFunction:__func__]
#else
#define Log_debugBool(value)
#endif



+ (void)debugData:(NSData *)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugData(value) [JBLog debugData:value withName:#value inFunction:__func__]
#else
#define Log_debugData(value)
#endif


+ (void)debugDate:(NSDate *)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugDate(value) [JBLog debugDate:value withName:#value inFunction:__func__]
#else
#define Log_debugDate(value)
#endif


+ (void)debugDouble:(double)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugDouble(value) [JBLog debugFloat:value withName:#value inFunction:__func__]
#else
#define Log_debugDouble(value)
#endif


+(void)debugError:(NSError*)error withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugError(value) [JBLog debugError:value withName:#value inFunction:__func__]
#else
#define Log_debugError(value)
#endif


+ (void)debugFloat:(double)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugFloat(value) [JBLog debugFloat:value withName:#value inFunction:__func__]
#else
#define Log_debugFloat(value)
#endif


+(void)debugForFunction:(const char*)function format:(NSString *)format, ...;
#ifdef DEBUG
#define Log_debugFormat(...) [JBLog debugForFunction:__func__ format:__VA_ARGS__]
#else
#define Log_debugFormat(...)
#endif


+ (void)debugInt:(long)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugInt(value) [JBLog debugInt:value withName:#value inFunction:__func__]
#else
#define Log_debugInt(value)
#endif


+ (void)debugIp4Address:(in_addr_t)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugIp4Address(value) [JBLog debugIp4Address:value withName:#value inFunction:__func__]
#else
#define Log_debugIp4Address(value)
#endif

+(void)debugLoggable:(id<JBLoggable>)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugLoggable(value) [JBLog debugLoggable:value withName:#value inFunction:__func__]
#else
#define Log_debugLoggable(value)
#endif


+ (void)debugLong:(long)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugLong(value) [JBLog debugInt:value withName:#value inFunction:__func__]
#else
#define Log_debugLong(value)
#endif

+ (void)debugLongLong:(long long)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugLongLong(value) [JBLog debugLongLong:value withName:#value inFunction:__func__]
#else
#define Log_debugLongLong(value)
#endif


+ (void)debugPointer:(void*)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugPointer(value) [JBLog debugPointer:value withName:#value inFunction:__func__]
#else
#define Log_debugPointer(value)
#endif

+ (void)debugString:(NSString *)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugString(value) [JBLog debugString:value withName:#value inFunction:__func__]
#else
#define Log_debugString(value)
#endif

+ (void)debugUtf8String:(const char*)value withName:(const char*)name inFunction:(const char*)function;
#ifdef DEBUG
#define Log_debugUtf8String(value) [JBLog debugUtf8String:value withName:#value inFunction:__func__]
#else
#define Log_debugUtf8String(value)
#endif

///////////////////////////////////////////////////////////

+(void)entered:(const char*)function;
#ifdef DEBUG
#define Log_enteredMethod() [JBLog entered:__func__]
#else
#define Log_enteredMethod()
#endif


#pragma mark -
#pragma mark Information



+ (void)info:(NSString *)message inFunction:(const char*)function;
#define Log_info(message) [JBLog info:message inFunction:__func__]


+(void)infoBool:(BOOL)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoBool(value) [JBLog infoBool:value withName:#value inFunction:__func__]

+ (void)infoDouble:(double)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoDouble(value) [JBLog infoFloat:value withName:#value inFunction:__func__]

+ (void)infoFloat:(double)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoFloat(value) [JBLog infoFloat:value withName:#value inFunction:__func__]

+ (void)infoInt:(long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoInt(value) [JBLog infoInt:value withName:#value inFunction:__func__]

+(void)infoLoggable:(id<JBLoggable>)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoLoggable(value) [JBLog infoLoggable:value withName:#value inFunction:__func__]

+ (void)infoLong:(long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoLong(value) [JBLog infoLong:value withName:#value inFunction:__func__]

+ (void)infoLongLong:(long long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoLongLong(value) [JBLog infoLongLong:value withName:#value inFunction:__func__]

+(void)infoPointer:(void*)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoPointer(value) [JBLog infoPointer:value withName:#value inFunction:__func__]

+ (void)infoString:(NSString*)value withName:(const char*)name inFunction:(const char*)function;
#define Log_infoString(value) [JBLog infoString:value withName:#value inFunction:__func__]

+(void)infoInFunction:(const char*)function format:(NSString*)format, ...;
#define Log_infoFormat( ... ) [JBLog infoInFunction:__func__ format:__VA_ARGS__]


#pragma mark -
#pragma mark Warning

+ (void)warn:(NSString *)message inFunction:(const char*)function;
#define Log_warn(message) [JBLog warn:message inFunction:__func__]

+(void)warnBool:(BOOL)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnBool(value) [JBLog warnBool:value withName:#value inFunction:__func__]

+ (void)warnCallTo:(NSString*)methodName failedWithErrno:(int)value inFunction:(const char*)function;
#define Log_warnCallFailed(methodName,errorCode) [JBLog warnCallTo:methodName failedWithErrno:errorCode inFunction:__func__]


+ (void)warnDouble:(double)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnDouble(value) [JBLog warnFloat:value withName:#value inFunction:__func__]

+(void)warnError:(NSError*)error withName:(const char*)name inFunction:(const char*)function;
#define Log_warnError(error) [JBLog warnError:error withName:#error inFunction:__func__]

+ (void)warnException:(NSException *)e withName:(const char*)name inFunction:(const char*)function;
#define Log_warnException(exception) [JBLog warnException:exception withName:#exception inFunction:__func__]

+ (void)warnFloat:(double)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnFloat(value) [JBLog warnFloat:value withName:#value inFunction:__func__]

+ (void)warnInt:(long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnInt(value) [JBLog warnInt:value withName:#value inFunction:__func__]

+(void)warnLoggable:(id<JBLoggable>)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnLoggable(value) [JBLog warnLoggable:value withName:#value inFunction:__func__]

+ (void)warnLong:(long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnLong(value) [JBLog warnLong:value withName:#value inFunction:__func__]

+ (void)warnLongLong:(long long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnLongLong(value) [JBLog warnLongLong:value withName:#value inFunction:__func__]

+ (void)warnPointer:(void*)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnPointer(value) [JBLog warnPointer:value withName:#value inFunction:__func__]

+ (void)warnString:(NSString *)value withName:(const char*)name inFunction:(const char*)function;
#define Log_warnString(value) [JBLog warnString:value withName:#value inFunction:__func__]

+(void)warnInFunction:(const char*)function format:(NSString *)format, ...;
#define Log_warnFormat( ... ) [JBLog warnInFunction:__func__ format:__VA_ARGS__]

#pragma mark -
#pragma mark Error

+ (void)error:(NSString *)message inFunction:(const char*)function;
#define Log_error(message) [JBLog error:message inFunction:__func__]

+(void)errorBool:(BOOL)value withName:(const char*)name inFunction:(const char*)function;
#define Log_errorBool(value) [JBLog errorBool:value withName:#value inFunction:__func__]

+ (void)errorCallTo:(NSString*)methodName failedWithErrno:(int)value inFunction:(const char*)function;
#define Log_errorCallFailed(methodName,errorCode) [JBLog errorCallTo:methodName failedWithErrno:errorCode inFunction:__func__]

+ (void)errorDouble:(double)value withName:(const char*)name inFunction:(const char*)function;
#define Log_errorDouble(value) [JBLog errorDouble:value withName:#value inFunction:__func__]

+(void)errorError:(NSError*)error withName:(const char*)name inFunction:(const char*)function;
#define Log_errorError(error) [JBLog errorError:error withName:#error inFunction:__func__]

+ (void)errorException:(NSException *)e withName:(const char*)name inFunction:(const char*)function;
#define Log_errorException(exception) [JBLog errorException:exception withName:#exception inFunction:__func__] 

+ (void)errorFloat:(double)value withName:(const char*)name inFunction:(const char*)function;
#define Log_errorFloat(value) [JBLog errorFloat:value withName:#value inFunction:__func__]

+(void)errorInFunction:(const char*)function format:(NSString *)format, ...;
#define Log_errorFormat( ... ) [JBLog errorInFunction:__func__ format:__VA_ARGS__]

+ (void)errorInt:(long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_errorInt(value) [JBLog errorInt:value withName:#value inFunction:__func__]

+(void)errorLoggable:(id<JBLoggable>)value withName:(const char*)name inFunction:(const char*)function;
#define Log_errorLoggable(value) [JBLog errorLoggable:value withName:#value inFunction:__func__]

+ (void)errorLong:(long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_errorLong(value) [JBLog errorLong:value withName:#value inFunction:__func__]

+ (void)errorLongLong:(long long)value withName:(const char*)name inFunction:(const char*)function;
#define Log_errorLongLong(value) [JBLog errorLongLong:value withName:#value inFunction:__func__]

+ (void)errorString:(NSString *)value withName:(const char*)name inFunction:(const char*)function;
#define Log_errorString(value) [JBLog errorString:value withName:#value inFunction:__func__]


@end

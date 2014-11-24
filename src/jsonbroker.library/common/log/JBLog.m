//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBLog.h"


@implementation JBLog




static id <JBLogConsumer> _logConsumer; 


+(void)initialize {	
}


+(void)setLogConsumer:(id <JBLogConsumer>)logConsumer forCaller:(const char *)caller{
    
    
    NSString* logMessage = [NSString stringWithFormat:@"caller = %s", caller];
    
    if( nil != _logConsumer ) { 
        [_logConsumer logMessage:logMessage forFunction:__func__ atLevel:@"INF"];
        [_logConsumer release];
    }

    _logConsumer = logConsumer;
    
    if( nil != _logConsumer ) { 
        [_logConsumer logMessage:logMessage forFunction:__func__ atLevel:@"INF"];
        [_logConsumer retain];
    }

	
}

+(id <JBLogConsumer>)getLogConsumer {
    return _logConsumer;
}


+(void)logMessage:(NSString*)message forFunction:(const char *)function atLevel:(NSString*)level {
	if( nil != _logConsumer ) {
		[_logConsumer logMessage:message forFunction:function atLevel:level];
	}
	
	NSString* currentThreadName = [[NSThread currentThread] name];
	NSLog( @"%@ %@ %s %@" , level, currentThreadName, function, message  );


}

#pragma mark -
#pragma mark Debug



+ (void)debug:(NSString *)message inFunction:(const char*)function {


#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings

	[self logMessage:message forFunction:function atLevel:@"DBG"]; 
	
#endif
	
}


+(void)debugBool:(BOOL)value withName:(const char*)name inFunction:(const char*)function {
    
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
    
    NSString *message;
    
    if( value ) {
        message  = [NSString stringWithFormat : @"%s = true" , name];
    } else {
        message  = [NSString stringWithFormat : @"%s = false" , name];
    }
	
    [self debug:message inFunction:function];
    
#endif
    
}

+ (void)debugDataLine:(const UInt8*)data count:(int)count inFunction:(const char*)function {

#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	NSMutableString* line = [[NSMutableString alloc] init];
	
	NSString* hexNums[] = { @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F"  };
	
	for( int i = 0; i < count; i++) {
		UInt8 byte = data[i];
		
		[line appendString:hexNums[ byte >> 4 ]]; // shift the offset to the right
		[line appendString:hexNums[ byte & 0xF ]];  // mask off the high bits
		
		if( i > 0 ) {
			if( 0 == ((i+1)%4) ) {
				[line appendString:@" "];
			}
		}
	}
	
	// fill out (if required)
	for( int i = count; i < 16; i++ ){
		[line appendString:@"  "];
		if( i > 0 ) {
			if( 0 == ((i+1)%4) ) {
				[line appendString:@" "];
			}
		}		
	}
	
	// ascii
	for( int i = 0; i < count; i++) {
		UInt8 byte = data[i];
		if( '!' <= byte && '~' >= byte ) {
			[line appendFormat:@"%c", byte];
		} else {
			[line appendString:@"."];
		}
	}
	
	
	[JBLog debug:line inFunction:function];
	[line release];
	
	
	
#endif

}


+ (void)debugData:(NSData *)value withName:(const char*)name inFunction:(const char*)function {

#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	NSString* message = [NSString stringWithFormat:@"%s[%ld] ...", name, (long)[value length]];
	[self debug:message inFunction:function];
	
	const UInt8* dataPointer = [value bytes];
	
	for( long count = [value length]; count > 0; count-=16, dataPointer+= 16 ) {
		if( count < 16 ) {
			[self debugDataLine:dataPointer count:(int)count inFunction:function];
		} else {
			[self debugDataLine:dataPointer count:16 inFunction:function];
		}
	}
	

#endif

}



+ (void)debugDate:(NSDate *)value withName:(const char*)name inFunction:(const char*)function {
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	NSString *message;

	if( nil == value ) {
		message  = [NSString stringWithFormat : @"%s = nil" , name]; 
	}
	else {
		NSString *stringValue = [value description]; 
		message  = [NSString stringWithFormat : @"%s = %@" , name , stringValue];
	}
	
    [self debug:message inFunction:function];
	
#endif

}


+ (void)debugDouble:(double)value withName:(const char*)name inFunction:(const char*)function {
    
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lf" , name, value];
    [self debug:message inFunction:function];
    
	
#endif
	
}

+(void)debugError:(NSError*)error withName:(const char*)name inFunction:(const char*)function {

#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings

    if( nil == error ) {
        
        [JBLog debugForFunction:function format:@"%s = NULL", name];
        
    } else {
        
        [JBLog debugForFunction:function format:@"[%s localizedDescription] = '%@'", name, [error localizedDescription]];
        [JBLog debugForFunction:function format:@"[%s localizedFailureReason] = '%@'", name, [error localizedFailureReason]];
        [JBLog debugForFunction:function format:@"[%s domain] = '%@'", name, [error domain]];
        [JBLog debugForFunction:function format:@"[%s code] = '%d'", name, [error code]];
        
    }
    
#endif

}



+(void)debugForFunction:(const char*)function format:(NSString *)format, ... {
    
    NSString* message;
    va_list vaList;
    va_start(vaList, format);
    {
        message = [[NSString alloc] initWithFormat:format arguments:vaList];
		[message autorelease];
    }
    va_end(vaList);
    [self debug:message inFunction:function];
    
}


+ (void)debugFloat:(double)value withName:(const char*)name inFunction:(const char*)function {

	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings

	NSString *message  = [NSString stringWithFormat : @"%s = %lf" , name, value]; 
    [self debug:message inFunction:function];

	
#endif
	
}


+ (void)debugInt:(long)value withName:(const char*)name inFunction:(const char*)function {
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	
	NSString *message  = [NSString stringWithFormat : @"%s = %ld" , name, value]; 
    [self debug:message inFunction:function];
	
#endif
}

+ (void)debugIp4Address:(in_addr_t)value withName:(const char*)name inFunction:(const char*)function {
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	int ip1 = value & 0xFF;
	int ip2 = ( value >> 8 ) & 0xFF;
	int ip3 = ( value >> 16 ) & 0xFF;
	int ip4 = ( value >> 24 ) & 0xFF;
	
	NSString *message  = [NSString stringWithFormat : @"%s = %d.%d.%d.%d" , name, ip1, ip2, ip3, ip4]; 
    [self debug:message inFunction:function];
	
#endif
	
}


+(void)debugLoggable:(id<JBLoggable>)value withName:(const char*)name inFunction:(const char*)function {

#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings

    
    if( nil == value ) { 
        NSString* message = [NSString stringWithFormat:@"%s = NULL", name];
        [self debug:message inFunction:function];
        return;
    }
    
    NSArray* messages = [value getLogMessages];
    if( 0 == [messages count] ) { 
        NSString* message = [NSString stringWithFormat:@"%s = {}", name];
        [self debug:message inFunction:function];
        return;
    }
    
    if( 1 == [messages count] ) { 
        NSString* message = [NSString stringWithFormat:@"%s = %@", name, [messages objectAtIndex:0]];
        [self debug:message inFunction:function];
        return;         
    }
    
    NSString* startMessage = [NSString stringWithFormat:@"%s = {", name ];
    
    [self debug:startMessage inFunction:function];
    
    for( NSString* message in messages ) {
        
        NSString* indentedMessage = [NSString stringWithFormat:@"    %@", message];
        [self debug:indentedMessage inFunction:function];
    }
    
    [self debug:@"}" inFunction:function];
    
#endif 
    
    
}


+ (void)debugLong:(long)value withName:(const char*)name inFunction:(const char*)function {
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	
	NSString *message  = [NSString stringWithFormat : @"%s = %ld" , name, value];
    [self debug:message inFunction:function];
	
#endif
}


+ (void)debugLongLong:(long long)value withName:(const char*)name inFunction:(const char*)function {
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	
	NSString *message  = [NSString stringWithFormat : @"%s = %lld" , name, value];
    [self debug:message inFunction:function];
	
#endif
}

+ (void)debugPointer:(void*)value withName:(const char*)name inFunction:(const char*)function {
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	
	NSString *message  = [NSString stringWithFormat : @"%s = %p" , name, value]; 
    [self debug:message inFunction:function];
	
#endif
	
}

+ (void)debugString:(NSString *)value withName:(const char*)name inFunction:(const char*)function {
	
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	NSString *message;
	if( nil == value )
	{
		message  = [NSString stringWithFormat : @"%s = nil" , name];
	}
	else
	{
		message  = [NSString stringWithFormat : @"%s = '%@'" , name, value];
	}
	
    [self debug:message inFunction:function];
	
#endif
	
}


+ (void)debugUtf8String:(const char*)value withName:(const char *)name inFunction:(const char*)function {
	
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings
	
	NSString *message;
	if( nil == value )
	{
		message  = [NSString stringWithFormat : @"%s = NULL" , name];
	}
	else
	{
		message  = [NSString stringWithFormat : @"%s = '%s'" , name, value];
	}
	
    [self debug:message inFunction:function];
	
#endif
	
}


///////////////////////////////////////////////////////////


+(void)entered:(const char*)function {
	
#ifdef DEBUG // see GCC_PREPROCESSOR_DEFINITIONS in the build settings

	[JBLog debug:@"entered" inFunction:function];
	
#endif
}


#pragma mark -
#pragma mark Information

+ (void)info:(NSString *)message inFunction:(const char*)function {
	

	[self logMessage:message forFunction:function atLevel:@"INF"]; 
	
}


+(void)infoBool:(BOOL)value withName:(const char*)name inFunction:(const char*)function {
    
    NSString *message;
    
    if( value ) {
        message  = [NSString stringWithFormat : @"%s = true" , name];
    } else {
        message  = [NSString stringWithFormat : @"%s = false" , name];
    }
	
    [self info:message inFunction:function];
    
}

+ (void)infoDouble:(double)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lf" , name, value];
    [self info:message inFunction:function];
}


+ (void)infoFloat:(double)value withName:(const char*)name inFunction:(const char*)function {

	NSString *message  = [NSString stringWithFormat : @"%s = %lf" , name, value]; 
    [self info:message inFunction:function];
}


+ (void)infoInt:(long)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %ld" , name, value]; 
    [self info:message inFunction:function];
    
}


+(void)infoLoggable:(id<JBLoggable>)value withName:(const char*)name inFunction:(const char*)function {
    
    
    if( nil == value ) { 
        NSString* message = [NSString stringWithFormat:@"%s = NULL", name];
        [self info:message inFunction:function];
        return;
    }
    
    NSArray* messages = [value getLogMessages];
    if( 0 == [messages count] ) { 
        NSString* message = [NSString stringWithFormat:@"%s = {}", name];
        [self info:message inFunction:function];
        return;
    }
    
    if( 1 == [messages count] ) { 
        NSString* message = [NSString stringWithFormat:@"%s = %@", name, [messages objectAtIndex:0]];
        [self info:message inFunction:function];
        return;         
    }
    
    NSString* startMessage = [NSString stringWithFormat:@"%s = {", name ];
    
    [self info:startMessage inFunction:function];
    
    for( NSString* message in messages ) {
        
        NSString* indentedMessage = [NSString stringWithFormat:@"    %@", message];
        [self info:indentedMessage inFunction:function];
    }
    
    [self info:@"}" inFunction:function];    
    
}


+ (void)infoLong:(long)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %ld" , name, value];
    [self info:message inFunction:function];
    
}

+ (void)infoLongLong:(long long)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lld" , name, value];
    [self info:message inFunction:function];
    
}


+(void)infoPointer:(void*)value withName:(const char*)name inFunction:(const char*)function {
    
    NSString *message  = [NSString stringWithFormat : @"%s = %p" , name, value]; 
    [self info:message inFunction:function];

}


+ (void)infoString:(NSString*)value withName:(const char*)name inFunction:(const char*)function {
    
    
    NSString *message;
	if( nil == value )
	{
		message  = [NSString stringWithFormat : @"%s = NULL" , name];
	}
	else
	{
		message  = [NSString stringWithFormat : @"%s = '%@'" , name, value];
	}
	
    [self info:message inFunction:function];

}


+(void)infoInFunction:(const char*)function format:(NSString*)format, ... {
	
	NSString* message = nil;
	
	va_list vaList;
	va_start(vaList, format);
	{
		message = [[NSString alloc] initWithFormat:format arguments:vaList];
		[message autorelease];
	}
	va_end(vaList);
    
    [self info:message inFunction:function];
	
}


#pragma mark -
#pragma mark Warning


+ (void)warn:(NSString *)message inFunction:(const char*)function {
	
	[self logMessage:message forFunction:function atLevel:@"WRN"]; 
	
}


+(void)warnBool:(BOOL)value withName:(const char*)name inFunction:(const char*)function {
    
    NSString *message;
    
    if( value ) {
        message  = [NSString stringWithFormat : @"%s = true" , name];
    } else {
        message  = [NSString stringWithFormat : @"%s = false" , name];
    }
	
    [self warn:message inFunction:function];
    
    
}


+ (void)warnCallTo:(NSString*)methodName failedWithErrno:(int)value inFunction:(const char*)function {

	NSString* message = [NSString stringWithFormat:@"'%@' call failed, errno = %d, strerror(errno)=%s", methodName, value, strerror(value) ];
    [self warn:message inFunction:function];
	
}


+(void)warnError:(NSError*)error withName:(const char*)name inFunction:(const char*)function {
    
    if( nil == error ) {
        
        [JBLog warnInFunction:function format:@"%s = NULL", name];
        
    } else {
        
        [JBLog warnInFunction:function format:@"[%s localizedDescription] = '%@'", name, [error localizedDescription]];
        [JBLog warnInFunction:function format:@"[%s localizedFailureReason] = '%@'", name, [error localizedFailureReason]];
        [JBLog warnInFunction:function format:@"[%s domain] = '%@'", name, [error domain]];
        [JBLog warnInFunction:function format:@"[%s code] = '%d'", name, [error code]];
        
    }
}


+ (void)warnException:(NSException *)e withName:(const char*)name inFunction:(const char*)function {
	
    if( [[e class] conformsToProtocol:@protocol(JBLoggable)] ) { 
        [self warnLoggable:(id<JBLoggable>)e withName:name inFunction:function];
        return;
    }
    
    [JBLog warnInFunction:function format:@"NSStringFromClass([%s class]) = '%@'", name, NSStringFromClass([e class])];
    [JBLog warnInFunction:function format:@"[%s name] = '%@'", name, [e name]];
    [JBLog warnInFunction:function format:@"[%s reason] = '%@'", name, [e reason]];
    
    [JBLog warnInFunction:function format:@"[%s callStackSymbols] = [", name];
    NSArray* callStackSymbols = [e callStackSymbols];
    for( NSString* callStackSymbol in callStackSymbols ) {
        callStackSymbol = [callStackSymbol stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [JBLog warnInFunction:function format:@"\t%@", callStackSymbol];
    }
    [JBLog warn:@"]" inFunction:function];
    
    
}

+ (void)warnDouble:(double)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lf" , name, value];
    [self warn:message inFunction:function];
    
}



+ (void)warnFloat:(double)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lf" , name, value]; 
    [self warn:message inFunction:function];

}


+ (void)warnInt:(long)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %ld" , name, value]; 
    [self warn:message inFunction:function];
}


+(void)warnLoggable:(id<JBLoggable>)value withName:(const char*)name inFunction:(const char*)function {
    
    
    if( nil == value ) { 
        NSString* message = [NSString stringWithFormat:@"%s = NULL", name];
        [self warn:message inFunction:function];
        return;
    }
    
    NSArray* messages = [value getLogMessages];
    if( 0 == [messages count] ) { 
        NSString* message = [NSString stringWithFormat:@"%s = {}", name];
        [self warn:message inFunction:function];
        return;
    }
    
    if( 1 == [messages count] ) { 
        NSString* message = [NSString stringWithFormat:@"%s = %@", name, [messages objectAtIndex:0]];
        [self warn:message inFunction:function];
        return;         
    }
    
    NSString* startMessage = [NSString stringWithFormat:@"%s = {", name ];
    
    [self warn:startMessage inFunction:function];
    
    for( NSString* message in messages ) {
        
        NSString* indentedMessage = [NSString stringWithFormat:@"    %@", message];
        [self warn:indentedMessage inFunction:function];
    }
    
    [self warn:@"}" inFunction:function];    
    
}

+ (void)warnLong:(long)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %ld" , name, value];
    [self warn:message inFunction:function];
}

+ (void)warnLongLong:(long long)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lld" , name, value];
    [self warn:message inFunction:function];
}

+ (void)warnPointer:(void*)value withName:(const char*)name inFunction:(const char*)function {
	
	NSString *message  = [NSString stringWithFormat : @"%s = %p" , name, value]; 
    [self warn:message inFunction:function];
}


+ (void)warnString:(NSString *)value withName:(const char*)name inFunction:(const char*)function {
    
    NSString *message;
    
	if( nil == value )
	{
		message  = [NSString stringWithFormat : @"%s = NULL" , name];
	}
	else
	{
		message  = [NSString stringWithFormat : @"%s = '%@'" , name, value];
	}
	
    [self warn:message inFunction:function];
    
}


+(void)warnInFunction:(const char*)function format:(NSString*)format, ... {
	
	NSString* message = nil;
	
	va_list vaList;
	va_start(vaList, format);
	{
		message = [[NSString alloc] initWithFormat:format arguments:vaList];
		[message autorelease];
	}
	va_end(vaList);
    
    [self warn:message inFunction:function];
	
}


#pragma mark -
#pragma mark Error

+ (void)error:(NSString *)message inFunction:(const char*)function {

	[self logMessage:message forFunction:function atLevel:@"ERR"]; 
	
}

+(void)errorBool:(BOOL)value withName:(const char*)name inFunction:(const char*)function {
    
    NSString *message;
    
    if( value ) {
        message  = [NSString stringWithFormat : @"%s = true" , name];
    } else {
        message  = [NSString stringWithFormat : @"%s = false" , name];
    }
	
    [self error:message inFunction:function];
    
}

+ (void)errorCallTo:(NSString*)methodName failedWithErrno:(int)value inFunction:(const char*)function {
	
	NSString* message = [NSString stringWithFormat:@"'%@' call failed, errno = %d, strerror(errno)=%s", methodName, value, strerror(value) ];
    [self error:message inFunction:function];

}

+(void)errorError:(NSError*)error withName:(const char*)name inFunction:(const char*)function {
    
    if( nil == error ) {
        [JBLog errorInFunction:function format:@"%s = NULL", name];
    } else {
        
        [JBLog errorInFunction:function format:@"[%s localizedDescription] = '%@'", name, [error localizedDescription]];
        [JBLog errorInFunction:function format:@"[%s localizedFailureReason] = '%@'", name, [error localizedFailureReason]];
        [JBLog errorInFunction:function format:@"[%s domain] = '%@'", name, [error domain]];
        [JBLog errorInFunction:function format:@"[%s code] = '%d'", name, [error code]];
        
    }
    
}

+ (void)errorException:(NSException *)e withName:(const char*)name inFunction:(const char*)function {
	
    if( [[e class] conformsToProtocol:@protocol(JBLoggable)] ) { 
        [self errorLoggable:(id<JBLoggable>)e withName:name inFunction:function];
        return;
    }
    
    
    
    [JBLog errorInFunction:function format:@"NSStringFromClass([%s class]) = '%@'", name, NSStringFromClass([e class])];
    [JBLog errorInFunction:function format:@"[%s name] = '%@'", name, [e name]];
    [JBLog errorInFunction:function format:@"[%s reason] = '%@'", name, [e reason]];
    
    [JBLog errorInFunction:function format:@"[%s callStackSymbols] = [", name];
    NSArray* callStackSymbols = [e callStackSymbols];
    for( NSString* callStackSymbol in callStackSymbols ) {
        callStackSymbol = [callStackSymbol stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [JBLog errorInFunction:function format:@"\t%@", callStackSymbol];
    }
    [JBLog error:@"]" inFunction:function];

    
}



+ (void)errorDouble:(double)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lf" , name, value];
    [self error:message inFunction:function];
    
}



+ (void)errorFloat:(double)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lf" , name, value];
    [self error:message inFunction:function];
    
}

+(void)errorInFunction:(const char*)function format:(NSString *)format, ... {

    NSString* message = nil;
	
	va_list vaList;
	va_start(vaList, format);
	{
		message = [[NSString alloc] initWithFormat:format arguments:vaList];
		[message autorelease];
	}
	va_end(vaList);
    
    [self error:message inFunction:function];

}


+ (void)errorInt:(long)value withName:(const char*)name inFunction:(const char*)function {
	NSString *message  = [NSString stringWithFormat : @"%s = %ld" , name, value]; 
    [self error:message inFunction:function];
    
}


+(void)errorLoggable:(id<JBLoggable>)value withName:(const char*)name inFunction:(const char*)function {
    
    
    if( nil == value ) { 
        NSString* message = [NSString stringWithFormat:@"%s = NULL", name];
        [self error:message inFunction:function];
        return;
    }
    
    NSArray* messages = [value getLogMessages];
    if( 0 == [messages count] ) { 
        NSString* message = [NSString stringWithFormat:@"%s = {}", name];
        [self error:message inFunction:function];
        return;
    }
    
    if( 1 == [messages count] ) { 
        NSString* message = [NSString stringWithFormat:@"%s = %@", name, [messages objectAtIndex:0]];
        [self error:message inFunction:function];
        return;         
    }
    
    NSString* startMessage = [NSString stringWithFormat:@"%s = {", name ];
    
    [self error:startMessage inFunction:function];
    
    for( NSString* message in messages ) {
        
        NSString* indentedMessage = [NSString stringWithFormat:@"    %@", message];
        [self error:indentedMessage inFunction:function];
    }
    
    [self error:@"}" inFunction:function];    
    
}

+ (void)errorLong:(long)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %ld" , name, value];
    [self error:message inFunction:function];
    
}


+ (void)errorLongLong:(long long)value withName:(const char*)name inFunction:(const char*)function {
    
	NSString *message  = [NSString stringWithFormat : @"%s = %lld" , name, value];
    [self error:message inFunction:function];
    
}

+ (void)errorString:(NSString *)value withName:(const char*)name inFunction:(const char*)function {

	
	NSString *message;
	if( nil == value )
	{
		message  = [NSString stringWithFormat : @"%s = nil" , name];
	}
	else
	{
		message  = [NSString stringWithFormat : @"%s = '%@'" , name, value];
	}
	
    [self error:message inFunction:function];
}




@end

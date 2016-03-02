// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBExceptionHelper.h"
#import "JBErrorCodeUtilities.h"
#import "JBLog.h"




@implementation BaseException

static int _defaultFaultCode; 


+(void)initialize {
    
    
    // vvv legacy/deprecated code
    int jsonBrokerErrorCode = [JBErrorCodeUtilities getBaseErrorCode:@"jsonbroker"];
    
    int baseException = jsonBrokerErrorCode | 0x10;


    _defaultFaultCode = baseException|0x01;

    // ^^^ legacy/deprecated code

}


+(int)defaultFaultCode {
    return _defaultFaultCode;
}




-(void)setFaultCode:(int)faultCode { 
    _faultCode = faultCode;

    [self setError:[NSError errorWithDomain:_originator code:faultCode userInfo:nil]];
}

-(void)addStringContext:(NSString*)value withName:(NSString*)name {
	[_faultContext setValue:value forKey:name];
}

-(void)addIntContext:(long)value withName:(NSString*)name {
	NSString* objValue = [NSString stringWithFormat:@"%ld", value];
	[_faultContext setObject:objValue  forKey:name];
}



-(void)addContext:(NSDictionary*)moreContext
{
	
	Log_enteredMethod();
	
	for( NSString* key in moreContext ) {
		
		Log_debugString(key );
		
		id value = [moreContext objectForKey:key];
		if( [value isKindOfClass:[NSString class]] )
		{
			NSString* stringValue = (NSString*)value;
			Log_debugString(stringValue );
			[self addStringContext:stringValue withName:key];
		}
		else if ( [value isKindOfClass:[NSNumber class]] )
		{
			NSNumber* numericValue = (NSNumber*)value;
			Log_debugInt([numericValue intValue] );
			[self addStringContext:[numericValue stringValue] withName:key];
		} 
		else
		{
			NSString* valueClassName = NSStringFromClass( [value class] );
			NSString* message = [NSString stringWithFormat:@"unhandled value type '%@' for key '%@'", valueClassName, key];
            Log_warn( message );
		}
	}
}

#pragma mark -
#pragma mark <JBLoggable> implementation 


-(NSArray*)getLogMessages {
    NSMutableArray* answer = [[NSMutableArray alloc] init];

    if( nil != _errorDomain ) {
        [answer addObject:[NSString stringWithFormat:@"errorDomain = '%@'", _errorDomain]];
    } else {
        [answer addObject:@"errorDomain = nil"];
    }

    [answer addObject:[NSString stringWithFormat:@"faultCode = '%d'", _faultCode]];
    [answer addObject:[NSString stringWithFormat:@"faultMessage = '%@'", [self reason]]];
    if( nil == _underlyingFaultMessage ) { 
        [answer addObject:@"underlyingFaultMessage = NULL"];
    } else {
        [answer addObject:[NSString stringWithFormat:@"underlyingFaultMessage = '%@'", _underlyingFaultMessage]];        
    }
    [answer addObject:[NSString stringWithFormat:@"originator = '%@'", _originator]];
    
    
    if( nil != _file ) { 
        [answer addObject:[NSString stringWithFormat:@"file = '%@'", _file]];
    }
    if( nil != _function ) { 
        [answer addObject:[NSString stringWithFormat:@"function = '%@'", _function]];
    }
    
    if( nil != _error ) { 
        [answer addObject:[NSString stringWithFormat:@"[error domain] = '%@'", [_error domain]]];
        [answer addObject:[NSString stringWithFormat:@"[error code] = %ld", (long)[_error code]]];
        [answer addObject:[NSString stringWithFormat:@"[error localizedDescription] = '%@'", [_error localizedDescription]]];
    }

    for( NSString* key in _faultContext ) { 
        NSString* value = [_faultContext objectForKey:key];
        
        [answer addObject:[NSString stringWithFormat:@"faultContext['%@'] = '%@'", key, value]];
    }
    
    {
        [answer addObject:@"[self callStackSymbols] = ["];
        
        NSArray* callStackSymbols = [self callStackSymbols];
        for( NSString* callStackSymbol in callStackSymbols ) {
            
            NSString* trimmedCallStackSymbol = [callStackSymbol stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [answer addObject:[NSString stringWithFormat:@"\t%@", trimmedCallStackSymbol]];
        }
        
        [answer addObject:@"]"];

    }
    
    NSString* atosCommand = [JBExceptionHelper getAtosCommand:self];
    [answer addObject:[NSString stringWithFormat:@"atos = %@", atosCommand]];
    
    
    return answer;
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithOriginator:(NSString*)originator faultMessage:(NSString *)faultMessage {
    
    BaseException* answer = [super initWithName:originator reason:faultMessage userInfo:nil];
    [answer setOriginator:originator];

    [answer setFaultCode:_defaultFaultCode]; // 
    answer->_faultContext = [[NSMutableDictionary alloc] init];

    [answer setError:[NSError errorWithDomain:originator code:[BaseException defaultFaultCode] userInfo:nil]];
    
    [answer setErrorDomain:nil];

    return answer;
    
    
}


-(id)initWithOriginator:(id)originatingObject line:(int)line faultMessage:(NSString *)faultMessage {
	
	NSString* className = NSStringFromClass([originatingObject class]);
    NSString* originator = [NSString stringWithFormat:@"%@:%d", className, line];
    
    BaseException* answer = [self initWithOriginator:originator faultMessage:faultMessage];
    
	return answer;
	
}



-(id)initWithOriginator:(id)originatingObject line:(int)line faultStringFormat:(NSString *)faultStringFormat arguments:(va_list)argList {
    
    NSString* className = NSStringFromClass([originatingObject class]);
    NSString* originator = [NSString stringWithFormat:@"%@:%d", className, line];
    
	NSString* technicalError = nil;
	
    technicalError = [[NSString alloc] initWithFormat:faultStringFormat arguments:argList];
    
    
    BaseException* answer = [self initWithOriginator:originator faultMessage:technicalError];
    
	return answer;
}


-(id)initWithOriginator:(id)originatingObject line:(int)line faultStringFormat:(NSString *)faultStringFormat, ... {

    BaseException* answer;
	
	va_list vaList;
	va_start(vaList, faultStringFormat);
	{
        answer = [self initWithOriginator:originatingObject line:line faultStringFormat:faultStringFormat arguments:vaList];
	}
	va_end(vaList);
    
	return answer;
}






-(id)initWithOriginator:(id)originatingObject line:(int)line callTo:(NSString*)methodName failedWithErrno:(int)value {
    
    
	NSString* className = NSStringFromClass([originatingObject class]);
    NSString* originator = [NSString stringWithFormat:@"%@:%d", className, line];

	NSString* technicalError = [NSString stringWithFormat:@"'%@' call failed, errno = %d, strerror(errno) = %s", methodName, value, strerror(value) ];
	
    
    BaseException* answer = [self initWithOriginator:originator faultMessage:technicalError];
    
    [answer addIntContext:errno withName:@"errno"];
    NSString* strerrorErrno = [NSString stringWithUTF8String:strerror(errno)];
    [answer addStringContext:strerrorErrno withName:@"strerror(errno)"];
    
    return answer;

}

-(id)initWithOriginator:(id)originatingObject line:(int)line callTo:(NSString*)methodName failedWithError:(NSError*)error {

    NSString* className = NSStringFromClass([originatingObject class]);
    NSString* originator = [NSString stringWithFormat:@"%@:%d", className, line];
    
    NSString* localizedErrorDescrition = [error localizedDescription];
    
	NSString* technicalError = [NSString stringWithFormat:@"'%@' call failed, localizedErrorDescrition = '%@'", methodName, localizedErrorDescrition];
    
    BaseException* answer = [self initWithOriginator:originator faultMessage:technicalError];
    [answer setError:error];
    [answer setUnderlyingFaultMessage:localizedErrorDescrition];
    return answer;
    

}

-(id)initWithOriginator:(id)originatingObject line:(int)line cause:(NSException*)cause {

    NSString* className = NSStringFromClass([originatingObject class]);
    NSString* originator = [NSString stringWithFormat:@"%@:%d", className, line];

    NSString* technicalError = [cause reason];
    
    BaseException* answer = [self initWithOriginator:originator faultMessage:technicalError];
    [answer setUnderlyingFaultMessage:[cause reason]];
    [answer setCause:cause];

    return answer;
}



-(void)dealloc {
	
    [self setCause:nil];
	[self setError:nil];
    [self setErrorDomain:nil];
    [self setFaultContext:nil];
	[self setFile:nil];
	[self setFunction:nil];
    [self setOriginator:nil];
    [self setUnderlyingFaultMessage:nil];
	
	
}


#pragma mark -
#pragma mark fields

// cause
//NSException* _cause;
//@property (nonatomic, retain) NSException* cause;
@synthesize cause = _cause;

//NSError *_error;
//@property (nonatomic, retain) NSError* error;
@synthesize error = _error;

// errorDomain
//NSString* _errorDomain;
//@property (nonatomic, retain) NSString* errorDomain;
@synthesize errorDomain = _errorDomain;


// from XML-RPC ... faultCode
//int _faultCode;
//@property (nonatomic) int faultCode;
@synthesize faultCode = _faultCode;

//NSMutableDictionary *_faultContext;
//@property (nonatomic, retain) NSMutableDictionary* faultContext;
@synthesize faultContext = _faultContext;

//NSString* _file;
//@property (nonatomic, retain) NSString* file;
@synthesize file = _file;

//NSString* _function;
//@property (nonatomic, retain) NSString* function;
@synthesize function = _function;

//NSString* _originator;
//@property (nonatomic, retain) NSString* originator;
@synthesize originator = _originator;

// underlyingFaultMessage
//NSString* _underlyingFaultMessage;
//@property (nonatomic, retain) NSString* underlyingFaultMessage;
@synthesize underlyingFaultMessage = _underlyingFaultMessage;





@end

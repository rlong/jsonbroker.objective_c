// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBContentDisposition.h"
#import "JBLog.h"
#import "JBParametersScanner.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBContentDisposition ()


-(id)initWithValue:(NSString*)value;


#pragma mark -
#pragma mark fields




// value
//NSString* _value;
@property (nonatomic, retain) NSString* value;
//@synthesize value = _value;


// dispositionParameters
//NSMutableDictionary* _dispositionParameters;
@property (nonatomic, retain) NSMutableDictionary* dispositionParameters;
//@synthesize dispositionParameters = _dispositionParameters;




@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



@implementation JBContentDisposition





#pragma mark -
#pragma mark <HttpHeader> implementation


-(NSString*)getName {
    return @"Content-Disposition";
}

-(NSString*)getValue {
    return _value;
}


#pragma mark -

-(NSString*)getDispositionParameter:(NSString*)parameterName defaultValue:(NSString*)defaultValue {
  
    NSString* answer = [_dispositionParameters objectForKey:parameterName];
    
    if( nil == answer ) {
        return defaultValue;
    }
    
    return answer;
    
    
}

+(JBContentDisposition*)buildFromString:(NSString*)value {
    
    
    // see http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1 for rules

    JBParametersScanner* scanner = [[JBParametersScanner alloc] initWithValue:value offset:0];
    
    
    NSString* firstAttribute = [scanner nextAttribute];
    if( nil == firstAttribute ) {
        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"nil == firstAttribute; value = '%@'", value];
    }
    
    NSString* dispExtensionToken = nil;
    
    if( [@"attachment" isEqualToString:firstAttribute] ) {
        
        // we leave _dispExtensionToken as null
        
    } else {
        dispExtensionToken = firstAttribute;
    }
    
    JBContentDisposition* answer = [[JBContentDisposition alloc] initWithValue:value];
    
    [answer setDispExtensionToken:dispExtensionToken];
    
    for( NSString* attribute = [scanner nextAttribute]; nil != attribute; attribute = [scanner nextAttribute] ) {
        
        Log_debugString( attribute );
        NSString* attributeValue = [scanner nextValue];
        Log_debugString( attributeValue );
        [answer->_dispositionParameters setObject:attributeValue forKey:attribute];
        
    }
    
    return answer;
    
    
    
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithValue:(NSString*)value {
    
    JBContentDisposition* answer = [super init];
    
    if( nil != answer )  {
        
        [answer setValue:value];
        answer->_dispositionParameters = [[NSMutableDictionary alloc] init];
        
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setDispExtensionToken:nil];
    [self setValue:nil];
	[self setDispositionParameters:nil];

	
}

#pragma mark -
#pragma mark fields

// dispExtensionToken ... can be null, see http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
//NSString* _dispExtensionToken;
//@property (nonatomic, retain) NSString* dispExtensionToken;
@synthesize dispExtensionToken = _dispExtensionToken;

// value
//NSString* _value;
//@property (nonatomic, retain) NSString* value;
@synthesize value = _value;

// dispositionParameters
//NSMutableDictionary* _dispositionParameters;
//@property (nonatomic, retain) NSMutableDictionary* dispositionParameters;
@synthesize dispositionParameters = _dispositionParameters;


@end

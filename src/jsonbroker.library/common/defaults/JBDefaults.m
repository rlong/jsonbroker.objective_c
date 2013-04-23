// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBDefaults.h"
#import "JBJsonObjectHelper.h"
#import "JBLog.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBDefaults ()

// environment
//JBJsonObject* _environment;
@property (nonatomic, retain) JBJsonObject* environment;
//@synthesize environment = _environment;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBDefaults






-(bool)boolWithName:(NSString*)name defaultValue:(bool)defaultValue {

    return [_environment boolForKey:name defaultValue:defaultValue];
    
}

-(int)intWithName:(NSString*)name defaultValue:(int)defaultValue {

    
    return [_environment intForKey:name defaultValue:defaultValue];
    
}

-(JBJsonObject*)jsonObjectWithName:(NSString*)name defaultValue:(JBJsonObject*)defaultValue {
    
    return [_environment jsonObjectForKey:name defaultValue:defaultValue];

}




+(JBDefaults*)getDefaultsForScope:(NSString*)scope {
    
    // environment ...
    {
        
        // vvv http://stackoverflow.com/questions/2821043/allowed-characters-in-linux-environment-variable-names
        
        NSString* environmentName = [scope stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        Log_debugString( environmentName );
        
        // ^^^ http://stackoverflow.com/questions/2821043/allowed-characters-in-linux-environment-variable-names
        
        NSString* environmentValue = [[[NSProcessInfo processInfo] environment] objectForKey:environmentName];
        
        if( nil != environmentValue ) {
            Log_debugString( environmentValue );
            JBJsonObject* environment = [JBJsonObjectHelper buildFromString:environmentValue];
            JBDefaults* answer = [[JBDefaults alloc] initWithEnvironment:environment];
            [answer autorelease];
            return answer;
            
        }
    }
    
    
    // appplication plist ...
    {
        NSBundle* mainBundle = [NSBundle mainBundle];
        NSString* bundleValue = [mainBundle objectForInfoDictionaryKey:scope];
        
        if( nil != bundleValue ) {
            Log_debugString( bundleValue );
            JBJsonObject* environment = [JBJsonObjectHelper buildFromString:bundleValue];
            JBDefaults* answer = [[JBDefaults alloc] initWithEnvironment:environment];
            [answer autorelease];
            return answer;
            
        }
    }
    
    // empty ...
    
    
    JBJsonObject* environment = [[JBJsonObject alloc] init];
    [environment autorelease];
    
    JBDefaults* answer = [[JBDefaults alloc] initWithEnvironment:environment];
    [answer autorelease];
    
    return answer;
    
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithEnvironment:(JBJsonObject*) environment {
    
    JBDefaults* answer  = [super init];
    
    if( nil != answer ) {
        
        [answer setEnvironment:environment];

    }
    
    return answer;
    
}

-(id)initWithScope:(NSString*)scope {
    
    JBDefaults* answer  = [super init];
    
    if( nil != answer ) {
        
        // vvv http://stackoverflow.com/questions/2821043/allowed-characters-in-linux-environment-variable-names
        
        scope = [scope stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        Log_debugString( scope );
        
        // ^^^ http://stackoverflow.com/questions/2821043/allowed-characters-in-linux-environment-variable-names
        
        NSString* environmentVariable = [[[NSProcessInfo processInfo] environment] objectForKey:scope];
        Log_debugString( environmentVariable );
        
        if( nil == environmentVariable ) {
            answer->_environment = [[JBJsonObject alloc] init];
        } else {

            JBJsonObject* environment = [JBJsonObjectHelper buildFromString:environmentVariable];
            [answer setEnvironment:environment];
        }
        
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setEnvironment:nil];
	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields

// environment
//JBJsonObject* _environment;
//@property (nonatomic, retain) JBJsonObject* environment;
@synthesize environment = _environment;


@end

//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBAuthorization.h"
#import "JBHttpErrorHelper.h"
#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBSecurityUtilities.h"
#import "JBSubject.h"



@interface JBSubject () 

#pragma mark private fields 





@end


@implementation JBSubject


static JBSubject* _test = nil; 

+(void)initialize {
    
    _test = [[JBSubject alloc] initWithUsername:[JBSubject TEST_USER] realm:[JBSubject TEST_REALM] password:[JBSubject TEST_PASSWORD] label:@"Test User"];
	
}


+(NSString*)TEST_USER {
    return @"test";
    
}

+(NSString*)TEST_REALM {
    return @"test";
    
}

+(NSString*)TEST_PASSWORD {
    return @"12345678";
    
}


+(JBSubject*)TEST {

    return _test;
}




// sections 3.2.2.1-3.2.2.3 of RFC-2617
-(NSString*)ha1 {
	
	if( nil == _ha1 ) {
		
		NSString* a1 = [NSString stringWithFormat:@"%@:%@:%@", _username, _realm, _password];
		_ha1 = [JBSecurityUtilities md5HashOfString:a1];
		[_ha1 retain];
		Log_debugString( _ha1 );
		
	}
	
	return _ha1;
	
}


-(void)validateAuthorizationRequestHeader:(JBAuthorization*)authorizationRequestHeader {
	
	// realm ... 
	NSString* realm = [authorizationRequestHeader realm];
	if( nil == realm ) {
        Log_error( @"nil == realm" );
        @throw [JBHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
    
	if( ! [_realm isEqualToString:realm] ) {
        Log_errorFormat( @"! [_realm isEqualToString:realm]; _realm = '%@'; realm = '%@'", _realm, realm);
        @throw [JBHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
	
	// username ...
	NSString* username = [authorizationRequestHeader username];
	if( nil == username ) {
        Log_error( @"nil == username" );
        @throw [JBHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
        
	} else if( ![_username isEqualToString:username] ) { // someone is switching user names 
        Log_errorFormat( @"![_username isEqualToString:username]; _username = '%@'; username = '%@'", _username, username);
        @throw [JBHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
         
	}
	
}

#pragma mark instance setup/teardown


-(id)initWithUsername:(NSString*)username realm:(NSString*)realm password:(NSString*)password label:(NSString*)label {
	
	JBSubject* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_born = [[NSDate date] retain];
    
    answer->_username = [username retain];
    answer->_realm = [realm retain];
	answer->_password = [password retain];
	answer->_label = [label retain];
	
	return answer;
}


-(void)dealloc {
	

	[JBObjectTracker deallocated:self];
    
    
    if( nil != _username ) { 
        [_username release];
        _username = nil;
         
    }
	
    if( nil != _realm ) { 
        [_realm release];
        _realm = nil;
    }
    
    if( nil != _password ) { 
        [_password release];
        _password = nil;
    }
    
    if( nil != _label ) {
        [_label release];
        _label = nil;
    }
	
	[_born release];
	_born = nil;
	
	if( nil != _ha1 ) {
		[_ha1 release];
		_ha1 = nil;
	}
	
	[super dealloc];
	
}

#pragma mark fields 

//////////////////////////////////////////////////////
// username
//NSString* _username;
//@property (nonatomic, readonly) NSString* username;
@synthesize username = _username;


// realm
//NSString* realm;
//@property (nonatomic, readonly) NSString* realm;
@synthesize realm = _realm;

//////////////////////////////////////////////////////
// password
//NSString* _password;
//@property (nonatomic, retain) NSString* password;
@synthesize password = _password;

//////////////////////////////////////////////////////
// label
//NSString* _label;
//@property (nonatomic, retain) NSString* label;
@synthesize label = _label;


//NSDate* _born;
//@property (nonatomic, readonly) NSDate* born;
@synthesize born = _born;

@end

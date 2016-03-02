//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Security/Security.h>
#import <Security/SecItem.h>

#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
#else
#import <UIKit/UIKit.h> // for UIDevice
#endif


#import "JBBaseException.h"
#import "JBDataHelper.h"
#import "JBKeychainUtilities.h"
#import "JBLog.h"



@implementation JBKeychainUtilities





+(void)setupAccessGroupForQuery:(NSMutableDictionary*)query {

    Log_info( @"NOT incorporating 'kSecAttrAccessGroup' into query" );


}


+(void)setupSecurityClassForQuery:(NSMutableDictionary*)query {

#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
	
	// OSX ... 
    Log_debug(@"OSX: using 'kSecClassInternetPassword'");
    NSString* secClassInternetPassword = (NSString *)secClassInternetPassword;
	[query setObject:secClassInternetPassword forKey:(NSString *)kSecClass];
    
#else
	
	// iOS ... 
    Log_debug(@"iOS: returning 'kSecClassGenericPassword'");
    NSString* secClassGenericPassword = (NSString *)kSecClassGenericPassword;
	[query setObject:secClassGenericPassword forKey:(NSString *)kSecClass];
	
#endif

}




// returns nil if no such user exists
+(NSString*)passwordForAccount:(NSString*)account service:(NSString*)service {
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
	
    [self setupSecurityClassForQuery:query];
	[self setupAccessGroupForQuery:query];
	[query setObject:service forKey:(NSString *)kSecAttrService];
	[query setObject:account forKey:(NSString *)kSecAttrAccount];
	
	
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnData];
	
	NSData* passwordData = nil;
	NSString* answer = nil;
	
	@try {
        
        // vvv some weirdness experienced between OSStatus and OSX 64 bit (just being sure)
        long longErrSecSuccess = errSecSuccess;
        long longStatus = SecItemCopyMatching((CFDictionaryRef) attributeQuery, (CFTypeRef *) &passwordData);
        // ^^^ some weirdness experienced between OSStatus and OSX 64 bit (just being sure)
		
		if( longErrSecSuccess != longStatus ) {
			if( errSecItemNotFound == longStatus ) { // follows a valid business usecase
                Log_info( @"errSecItemNotFound == status" );
				return nil;
			} 
			// otherwise we throw an exception ...
			NSString* technicalError = [NSString stringWithFormat:@"SecItemCopyMatching call failed for account '%@' for service '%@' (%ld == status)", account, service, longStatus];
			BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
			[e addIntContext:longStatus withName:@"longStatus"];
			
			@throw e;
		}
		
		if( nil == passwordData ) { // can this happen if (errSecSuccess == status) ?
			NSString* technicalError = [NSString stringWithFormat:@"got unexpected response from SecItemCopyMatching call (nil == passwordData). account = '%@', service = '%@'", account, service];
			BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
			[e addIntContext:longStatus withName:@"longStatus"];
			
			@throw e;
		}
		
		answer = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        
        Log_debugString( answer );
		
	}
	@finally {
		if( nil != passwordData ) {
		}
	}
	return answer;
	
	
}




+(void)dump {
    Log_enteredMethod();
    
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
	
    [self setupSecurityClassForQuery:query];
	[self setupAccessGroupForQuery:query];
    
    NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnAttributes];
    
    NSDictionary* passwordData = nil; 
    
    
    @try {
        
        // vvv some weirdness experienced between OSStatus and OSX 64 bit (just being sure)
        long longErrSecSuccess = errSecSuccess;
        long longStatus = SecItemCopyMatching((CFDictionaryRef) attributeQuery, (CFTypeRef *) &passwordData);
        // ^^^ some weirdness experienced between OSStatus and OSX 64 bit (just being sure)

        
		
		if( longErrSecSuccess != longStatus ) {
			if( errSecItemNotFound == longStatus ) { // follows a valid business usecase
                Log_info(@"errSecItemNotFound == status");
                return;
			} 
			// otherwise we throw an exception ...
			NSString* technicalError = [NSString stringWithFormat:@"SecItemCopyMatching call failed for account; status = %ld", longStatus];
			BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
			[e addIntContext:longStatus withName:@"longStatus"];
			
			@throw e;
		}
        
        if( nil == passwordData ) { // can this happen if (errSecSuccess == status) ?
			NSString* technicalError = @"nil == passwordData";
			BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
			[e addIntContext:longStatus withName:@"longStatus"];
			
			@throw e;
		}
        Log_debugPointer( (__bridge void*)passwordData );
        Log_debugString( [passwordData objectForKey:(NSString*)kSecAttrAccount] );
		
        
    }
    @finally {
    }
    
}

// can return nil
+(NSString*)getSavedUsername {
    
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
	
    [self setupSecurityClassForQuery:query];
	[self setupAccessGroupForQuery:query];
    
    NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnAttributes];
    
    NSObject* attributes = nil; 
    
    @try {
        // vvv some weirdness experienced between OSStatus and OSX 64 bit (just being sure)
        long longErrSecSuccess = errSecSuccess;
        long longErrSecItemNotFound = errSecItemNotFound;
        long longStatus = SecItemCopyMatching((CFDictionaryRef) attributeQuery, (CFTypeRef *) &attributes);
        // ^^^ some weirdness experienced between OSStatus and OSX 64 bit (just being sure)

		
		if( longErrSecSuccess != longStatus ) {
			if( longErrSecItemNotFound == longStatus ) { // follows a valid business usecase
                Log_info(@"longErrSecItemNotFound == longStatus");
                return nil;
			} 
            Log_warnFormat( @"SecItemCopyMatching call failed for account; longStatus = %ld", longStatus);
            return nil;
		}
        
        if( nil == attributes ) { // can this happen if (errSecSuccess == status) ?
            Log_warn( @"nil == passwordData");
            return nil;
		}
        
        if( !([attributes isKindOfClass:[NSDictionary class]]) ) { 
            Log_warn( @"!([attributes isKindOfClass:[NSDictionary class]]");
            return nil;            
        }
        
        NSDictionary* attributesDictionary = (NSDictionary*)attributes;
        
        id secAttrAccount = [attributesDictionary objectForKey:(NSString*)kSecAttrAccount]; // 'acct'

        NSString* answer = nil;

        // vvv documentation says 'secAttrAccount' should be a CFStringRef (i.e. NSString), but finding in simulator on OSX 10.8.5 that 'secAttrAccount' is a NSData
        if( nil == secAttrAccount ) {
            answer = nil; // just to be explicit
        } else if( [secAttrAccount isKindOfClass:[NSString class]] ) {
            answer = (NSString*)secAttrAccount;
            
        } else if( [secAttrAccount isKindOfClass:[NSData class]] ) {
            Log_warn(@"[secAttrAccount isKindOfClass:[NSData class]]");
            NSData* secAttrAccountData = (NSData*)secAttrAccount;
            answer = [JBDataHelper toUtf8String:secAttrAccountData];
        } else {
            Class clazz = [secAttrAccount class];
            NSString* technicalError = [NSString stringWithFormat:@"unsupported type; NSStringFromClass(clazz) = %@", NSStringFromClass(clazz)];
            
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
            @throw  e;
        }
        // ^^^ documentation says 'secAttrAccount' should be a CFStringRef (i.e. NSString), but finding in simulator on OSX 10.8.5 that 'secAttrAccount' is a NSData
        
        
        Log_debugString( answer );
        return answer;
        
    }
    @finally {
    }
    
    
}


// returns nil if no such user exists
+(NSString*)passwordForUsername:(NSString*)username service:(NSString*)service {
	
	return [self passwordForAccount:username service:service];
}



+(BOOL)addPassword:(NSString*)password account:(NSString*)username service:(NSString*)service label:(NSString*)label {
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
	
    [self setupSecurityClassForQuery:query];
	[self setupAccessGroupForQuery:query];
    
	[query setObject:service forKey:(NSString *)kSecAttrService];
	[query setObject:service forKey:(NSString *)kSecAttrLabel];
	[query setObject:username forKey:(NSString *)kSecAttrAccount];
    [query setObject:label forKey:(NSString *)kSecAttrLabel];
	[query setObject:[password dataUsingEncoding: NSUTF8StringEncoding] forKey:(NSString *)kSecValueData];
	
	OSStatus status = SecItemAdd((CFDictionaryRef) query, NULL);
	
	int kErrSecNoAccessForItem = -25243;
	
	if( errSecSuccess == status ) {		
		Log_debug( @"errSecSuccess == status" );
		
		return YES;
	} 
	
	if( errSecDuplicateItem == status ) {
        Log_warn( @"errSecDuplicateItem == status" );
	} else if ( kErrSecNoAccessForItem == status ) { // not entitled access to the
        Log_warn( @"kErrSecNoAccessForItem == status" );
	} else {
        Log_warnInt( status);
	}
	
	return NO;
}

+(BOOL)updatePassword:(NSString*)password account:(NSString*)username service:(NSString*)service label:(NSString*)label {
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
	
    [self setupSecurityClassForQuery:query];
	[self setupAccessGroupForQuery:query];
	
	[query setObject:service forKey:(NSString *)kSecAttrService];
	[query setObject:username forKey:(NSString *)kSecAttrAccount];
    [query setObject:label forKey:(NSString *)kSecAttrLabel];
	
	NSMutableDictionary* attributesToUpdate = [[NSMutableDictionary alloc] init];
	[attributesToUpdate setObject:[password dataUsingEncoding: NSUTF8StringEncoding] forKey:(NSString *)kSecValueData];
	
	
	OSStatus status = SecItemUpdate( (CFDictionaryRef)query, (CFDictionaryRef)attributesToUpdate );
	
	if( errSecSuccess == status ) {		
		Log_debug( @"errSecSuccess == status" );
		
		return YES;
	} 
	
	if( errSecItemNotFound == status ) {
        Log_warn( @"errSecItemNotFound == status" );
	} else {
        Log_warnInt( status);
	}
	
	return NO;
}


+(BOOL)setPassword:(NSString*)password forUsername:(NSString*)username atService:(NSString*)service label:(NSString*)label throwExceptionOnFail:(BOOL)throwExceptionOnFail {

	if( ! [self addPassword:password account:username service:service label:label] ) {
		if( ! [self updatePassword:password account:username service:service label:label] ) {
            
            Log_warnFormat( @"Could not add or update password for user '%@' for service '%@'; will try to remove and then add", username, service);
            
            @try {
                [self removePasswordForUsername:username atService:service];
            }
            @catch (BaseException *exception) {
                Log_errorException(exception);
            }
            
            if( ! [self addPassword:password account:username service:service label:label] ) {
                
                NSString* technicalError = [NSString stringWithFormat:@"Could not set password for user '%@' for service '%@'", username, service];
                
                if( throwExceptionOnFail ) {
                    
                    BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
                    
                    @throw e;
                    
                } else {
                    Log_error(technicalError);
                    return false;
                }
                
                
            }
            
		}
	}
    return true;
}


+(void)removePasswordForUsername:(NSString*)username atService:(NSString*)service {
	
	NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
	
    [self setupSecurityClassForQuery:query];
	[self setupAccessGroupForQuery:query];
    
	[query setObject:service forKey:(NSString *)kSecAttrService];
	[query setObject:username forKey:(NSString *)kSecAttrAccount];
	
    
    // vvv some weirdness experienced between OSStatus and OSX 64 bit (just being sure)
    long longErrSecSuccess = errSecSuccess;
    long longErrSecItemNotFound = errSecItemNotFound;
    long longStatus = SecItemDelete( (CFDictionaryRef)query );
    // ^^^ some weirdness experienced between OSStatus and OSX 64 bit (just being sure)

	
	if( longErrSecSuccess == longStatus ) {		
		Log_debug( @"longErrSecSuccess == longStatus" );
	} else {
		
		if( longErrSecItemNotFound == longStatus ) { // follows a valid business usecase
            Log_warn( @"longErrSecItemNotFound == longStatus" );
			return;
		} 
		// otherwise we throw an exception ...
		NSString* technicalError = [NSString stringWithFormat:@"SecItemDelete call failed for user '%@' for service '%@' (%ld == longStatus)", username, service, longStatus];
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e addIntContext:longStatus withName:@"longStatus"];
		
		@throw e;
	}
	
}


@end

//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBAuthenticationInfo.h"
#import "JBWwwAuthenticate.h"
#import "JBHttpRequest.h"
#import "JBHttpResponse.h"
#import "JBSubject.h"


@interface JBHttpSecuritySession : NSObject {

    
	// usersRealm
	NSString* _usersRealm;
	//@property (nonatomic, retain) NSString* usersRealm;
	//@synthesize usersRealm = _usersRealm;

	
	NSString* _cnonce;
	//@property (nonatomic, retain) NSString* cnonce;
	//@synthesize cnonce = _cnonce;

	NSMutableDictionary* _cnoncesUsed;
	//@property (nonatomic, retain) NSMutableDictionary* cnoncesUsed;
	//@synthesize cnoncesUsed = _cnoncesUsed;
	
	UInt32 _nc;
	//@property (nonatomic) UInt32 nc;
	//@synthesize nc = _nc;
	
	NSString* _nonce;
	//@property (nonatomic, retain) NSString* nonce;
	//@synthesize nonce = _nonce;
	
	NSString* _opaque;
	//@property (nonatomic, retain) NSString* opaque;
	//@synthesize opaque = _opaque;
		
	JBSubject* _registeredSubject;
	//@property (nonatomic, retain) Subject* registeredSubject;
	//@synthesize registeredSubject = _registeredSubject;
	
	NSDate* _idleSince;
	//@property (nonatomic, retain) NSDate* idleSince;
	//@synthesize idleSince = _idleSince;
	
	
}


-(void)authorise:(NSString*)method authorization:(JBAuthorization*)authorization entity:(id<JBEntity>)entity;
-(void)authorise:(NSString*)method authorization:(JBAuthorization*)authorization;
-(void)updateUsingAuthenticatedAuthorization:(JBAuthorization*)authorization;
-(JBWwwAuthenticate*)buildWwwAuthenticate;
-(JBAuthenticationInfo*)buildAuthenticationInfo:(JBAuthorization*)authorization responseEntity:(id<JBEntity>)responseEntity;
-(NSTimeInterval)idleTime;




#pragma mark instance setup/teardown 

-(id)initWithUsersRealm:(NSString*)usersReam;


#pragma mark fields

//NSString* _cnonce;
@property (nonatomic, retain) NSString* cnonce;
//@synthesize cnonce = _cnonce;

//NSMutableDictionary* _cnoncesUsed;
@property (nonatomic, retain) NSMutableDictionary* cnoncesUsed;
//@synthesize cnoncesUsed = _cnoncesUsed;


//UInt32 _nc;
@property (nonatomic) UInt32 nc;
//@synthesize nc = _nc;

//NSString* _nonce;
@property (nonatomic, retain) NSString* nonce;
//@synthesize nonce = _nonce;

//NSString* _opaque;
@property (nonatomic, retain) NSString* opaque;
//@synthesize opaque = _opaque;

//Subject* _registeredSubject;
@property (nonatomic, retain) JBSubject* registeredSubject;
//@synthesize registeredSubject = _registeredSubject;



@end

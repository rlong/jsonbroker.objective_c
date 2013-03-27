//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBHttpRequest.h"
#import "JBHttpResponse.h"
#import "JBServerSecurityConfiguration.h"
#import "JBSubject.h"
#import "JBSubjectGroup.h"

@interface JBHttpSecurityManager : NSObject {
	
	// securityConfiguration
	id<JBServerSecurityConfiguration> _securityConfiguration;
	//@property (nonatomic, retain) id<ServerSecurityConfiguration> securityConfiguration;
	//@synthesize securityConfiguration = _securityConfiguration;
    
	NSMutableDictionary* _unauthenticatedSessions;
	//@property (nonatomic, retain) NSMutableDictionary* unauthenticatedSessions;
	//@synthesize unauthenticatedSessions = _unauthenticatedSessions;
	
	NSMutableDictionary* _authenticatedSessions;
	//@property (nonatomic, retain) NSMutableDictionary* authenticatedSessions;
	//@synthesize authenticatedSessions = _authenticatedSessions;
	
	JBSubjectGroup* _unregisteredSubjects;
	//@property (nonatomic, retain) SubjectGroup* unregisteredSubjects;
	//@synthesize unregisteredSubjects = _unregisteredSubjects;
	
}

-(id<JBServerSecurityConfiguration>)getSecurityConfiguration;


-(void)authenticateRequest:(NSString*)method authorizationRequestHeader:(JBAuthorization*)authorizationRequestHeader entity:(id<JBEntity>)entity;
-(void)authenticateRequest:(NSString*)method authorizationRequestHeader:(JBAuthorization*)authorizationRequestHeader;
-(id<JBHttpHeader>)getHeaderForResponse:(JBAuthorization*)authorization responseStatusCode:(int)responseStatusCode responseEntity:(id<JBEntity>)responseEntity;
-(void)addUnregisteredSubject:(JBSubject*)unregisteredSubject;
-(void)addRegisteredSubject:(JBSubject*)registeredSubject;
-(void)removeSubjectWithUsername:(NSString*)username;
-(void)runCleanup;
-(BOOL)subjectHasAuthenticatedSession:(JBSubject*)target;
-(JBSubject*)approveSubjectWithUsername:(NSString*)userName;



#pragma mark instance setup/teardown 

-(id)initWithSecurityConfiguration:(id<JBServerSecurityConfiguration>)securityConfiguration;

#pragma mark public fields

//SubjectGroup* _unregisteredSubjects;
@property (nonatomic, retain) JBSubjectGroup* unregisteredSubjects;
//@synthesize unregisteredSubjects = _unregisteredSubjects;


@end

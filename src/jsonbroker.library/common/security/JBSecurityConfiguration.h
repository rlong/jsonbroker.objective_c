//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBAuthorization.h"
#import "JBClientSecurityConfiguration.h"
#import "JBConfigurationService.h"
#import "JBSecurityAdapter.h"
#import "JBSecurityConfiguration_Generated.h"
#import "JBServerSecurityConfiguration.h"
#import "JBSubjectGroup.h"

@interface JBSecurityConfiguration : JBSecurityConfiguration_Generated <JBClientSecurityConfiguration,JBServerSecurityConfiguration> {
    
    // identifier
	NSString* _identifier;
	//@property (nonatomic, retain) NSString* identifier;
	//@synthesize identifier = _identifier;

    
    // configurationService
	JBConfigurationService* _configurationService;
	//@property (nonatomic, retain) ConfigurationService* configurationService;
	//@synthesize configurationService = _configurationService;
    

	// clients
	NSMutableDictionary* _clients;
	//@property (nonatomic, retain) NSMutableDictionary* clients;
	//@synthesize clients = _clients;
    
    
    // servers
	NSMutableDictionary* _servers;
	//@property (nonatomic, retain) NSMutableDictionary* servers;
	//@synthesize servers = _servers;
    
    // registeredSubjects
	JBSubjectGroup* _registeredSubjects;
	//@property (nonatomic, retain) SubjectGroup* registeredSubjects;
	//@synthesize registeredSubjects = _registeredSubjects;

}


+(JBSecurityConfiguration*)TEST;

+(JBSecurityConfiguration*)build:(id<JBSecurityAdapter>)securityAdapter configurationService:(JBConfigurationService*)configurationService;




@end

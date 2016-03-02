//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBSecurityConfiguration.h"
#import "JBSecurityUtilities.h"
#import "JBSimpleSecurityAdapter.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBSecurityConfiguration () 


+(JBSecurityConfiguration*)buildTestConfiguration;


-(id)initWithIdentifier:(NSString *)identifier configurationService:(JBConfigurationService*)configurationService;
-(id)initWithValue:(JBJsonObject *)value configurationService:(JBConfigurationService*)configurationService;


-(JBJsonObject*)toJsonObject;

#pragma mark fields


// identifier
//NSString* _identifier;
@property (nonatomic, retain) NSString* identifier;
//@synthesize identifier = _identifier;

// configurationService
//ConfigurationService* _configurationService;
@property (nonatomic, retain) JBConfigurationService* configurationService;
//@synthesize configurationService = _configurationService;

// clients
//NSMutableDictionary* _clients;
@property (nonatomic, retain) NSMutableDictionary* clients;
//@synthesize clients = _clients;


// servers
//NSMutableDictionary* _servers;
@property (nonatomic, retain) NSMutableDictionary* servers;
//@synthesize servers = _servers;



// registeredSubjects
//SubjectGroup* _registeredSubjects;
@property (nonatomic, retain) JBSubjectGroup* registeredSubjects;
//@synthesize registeredSubjects = _registeredSubjects;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation JBSecurityConfiguration




static JBSecurityConfiguration* _test = nil; 


+(JBSecurityConfiguration*)TEST {
    
    if( nil != _test ) { 
        return _test;
    }
    
    _test = [JBSecurityConfiguration buildTestConfiguration];
    
    return _test;
    
    
}



+(JBSecurityConfiguration*)buildTestConfiguration {
    
    JBSecurityConfiguration* answer = [[JBSecurityConfiguration alloc] initWithIdentifier:[JBSubject TEST_REALM] configurationService:nil];
    
    [answer addClient:[JBSubject TEST]];
    
    return answer;
}


// vvv fix any badly formed 'identifier' in 'jsonbroker.SecurityConfiguration.json' (ref: B0312DC4-2B62-4BF4-B745-B1B99BE21D73)

+(bool)isValidIdentifierCharacter:(unichar)c {
    
    if( c == '-' ) { // 45
        return true;
    }

    if( c == '.' ) { // 46
        return true;
    }
    
    if( c == '/' ) { // 47
        return true;
    }

    if( c >= '0' && c <= '9') { // 48 - 57
        return true;
    }
    
    if( c == ':' ) { // 58
        return true;
    }

    if( c == '@' ) { // 64
        return true;
    }

    if( c >= 'A' && c <= 'Z') { // 65 - 90
        return true;
    }

    if( c == '_' ) { // 95
        return true;
    }

    if( c >= 'a' && c <= 'z') { // 97 - 122
        return true;
    }


    return false;
    
}

+(bool)isValidIdentifier:(NSString*)identifier {
    
    for( NSUInteger i = 0, count = [identifier length]; i < count; i++ ) {
        
        unichar c = [identifier characterAtIndex:i];
        if( ![self isValidIdentifierCharacter:c] ) {
            Log_warnFormat( @"identifier = '%@'; i = %d; c = %d", identifier, i, c );
            return false;
        }
        
    }
    
    return true;
}


// ^^^ fix any badly formed 'identifier' in 'jsonbroker.SecurityConfiguration.json' (ref: B0312DC4-2B62-4BF4-B745-B1B99BE21D73)


+(JBSecurityConfiguration*)build:(id<JBSecurityAdapter>)securityAdapter configurationService:(JBConfigurationService*)configurationService {
    
    JBJsonObject* bundleData = [configurationService getBundle:[JBSimpleSecurityAdapter BUNDLE_NAME]];
    
    JBSecurityConfiguration* answer = nil;
    
    
    if( nil != bundleData ) { 
        if( [bundleData contains:@"identifier"] )  {
            
            // vvv pairing in production is setting up the user as 'test' (ref: 477550FB-3656-4014-B4D7-DC49821E0BA6)
            // see SecurityConfiguration, KeychainSecurityAdapter
            
            
            NSString* identifier = [bundleData stringForKey:@"identifier"];
            
            if( [@"test" isEqualToString:identifier] ) {
                Log_warnString( identifier );
                
                NSString* identifier = [securityAdapter getIdentifier];
                Log_debugString( identifier );
                
                answer = [[JBSecurityConfiguration alloc] initWithIdentifier:identifier configurationService:configurationService];
                return answer;
            }
            
            
            // ^^^ pairing in production is setting up the user as 'test' (ref: 477550FB-3656-4014-B4D7-DC49821E0BA6)
            
            
            // vvv fix any badly formed 'identifier' in 'jsonbroker.SecurityConfiguration.json' (ref: B0312DC4-2B62-4BF4-B745-B1B99BE21D73)
            
            if( ![JBSecurityConfiguration isValidIdentifier:identifier] ) {

                Log_warnString( identifier );
                
                NSString* identifier = [securityAdapter getIdentifier];
                Log_debugString( identifier );
                
                answer = [[JBSecurityConfiguration alloc] initWithIdentifier:identifier configurationService:configurationService];
                return answer;

            }
            
            // ^^^ fix any badly formed 'identifier' in 'jsonbroker.SecurityConfiguration.json' (ref: B0312DC4-2B62-4BF4-B745-B1B99BE21D73)
            
            answer = [[JBSecurityConfiguration alloc] initWithValue:bundleData configurationService:configurationService];
            return answer;
        }
    }
    NSString* identifier = [securityAdapter getIdentifier];
    Log_debugString( identifier );
    
    answer = [[JBSecurityConfiguration alloc] initWithIdentifier:identifier configurationService:configurationService];
    
    return answer;
    
}


-(void)save { 
    
    if( nil == _configurationService ) { 
        Log_warn(@"nil == _configurationService");
        return;
    }
    
    JBJsonObject* bundleData = [self toJsonObject];
    [_configurationService saveBundle:bundleData withName:[JBSimpleSecurityAdapter BUNDLE_NAME]];
    [_configurationService set_bundle:[JBSimpleSecurityAdapter BUNDLE_NAME] bundle:bundleData];
    [_configurationService saveAllBundles];
    
    
}

-(void)addSubject:(NSString*)subjectIdentifier password:(NSString*)subjectPassword label:(NSString*)subjectLabel { 
    
    JBSubject* client = [[JBSubject alloc] initWithUsername:subjectIdentifier realm:_identifier password:subjectPassword label:subjectLabel];
    {
        [_clients setObject:client forKey:subjectIdentifier];        
    }
    
    
    JBSubject* server = [[JBSubject alloc] initWithUsername:_identifier realm:subjectIdentifier password:subjectPassword label:subjectLabel];
    {
        
        [_servers setObject:server forKey:subjectIdentifier];
    }
    
    [self save];
    
}

-(void)removeSubject:(NSString*)subjectIdentifier {
    
    [_clients removeObjectForKey:subjectIdentifier];
    [_servers removeObjectForKey:subjectIdentifier];
    
    [self save];
}




-(JBJsonObject*)toJsonObject {

    JBJsonObject* answer = [[JBJsonObject alloc] init];
    
    [answer setObject:_identifier forKey:@"identifier"];
    
    JBJsonArray* subjects = [[JBJsonArray alloc] init];
    {
    
        for( NSString* clientIdentifier in _clients ) { 
            JBSubject* client = [_clients objectForKey:clientIdentifier];
            
            JBJsonObject* subjectData = [[JBJsonObject alloc] init];
            {
                [subjectData setObject:[client username] forKey:@"identifier"];
                [subjectData setObject:[client password] forKey:@"password"];
                [subjectData setObject:[client label] forKey:@"label"];
                
                [subjects add:subjectData];
            }
            
        }
        
        [answer setObject:subjects forKey:@"subjects"];
    }
    
    return answer;
    
}

#pragma mark <ClientSecurityConfiguration> implementation

////////////////////////////////////////////////////////////////////////////
// ClientSecurityConfiguration::create


-(void)addServer:(JBSubject*)server { 
    
    NSString* subjectIdentifier = [server realm];
    NSString* subjectPassword = [server password];
    NSString* subjectLabel = [server label];
    
    [self addSubject:subjectIdentifier password:subjectPassword label:subjectLabel];
    
}

////////////////////////////////////////////////////////////////////////////
// ClientSecurityConfiguration::read

-(NSString*)username { 
    
    return _identifier;
}


-(BOOL)hasServer:(NSString *)realm {
    
    if( nil != [_servers objectForKey:realm] ) {
        return true;
    }
    return false;
}

//can return nil
-(JBSubject*)getServer:(NSString *)realm {
    return [_servers objectForKey:realm];
}


-(void)removeServer:(NSString *)realm {
    if( nil == [_servers objectForKey:realm] ) {
        Log_warnFormat(@"nil == [_servers objectForKey:realm]; realm = '%@'", realm );
    }
    [self removeSubject:realm];
}


#pragma mark <ServerSecurityConfiguration> implementation

////////////////////////////////////////////////////////////////////////////
// ServerSecurityConfiguration::create


-(void)addClient:(JBSubject*)client { 
    
    NSString* subjectIdentifier = [client username];
    NSString* subjectPassword = [client password];
    NSString* subjectLabel = [client label];
    
    [self addSubject:subjectIdentifier password:subjectPassword label:subjectLabel];
    
}


////////////////////////////////////////////////////////////////////////////
// ServerSecurityConfiguration::read 


-(NSString*)realm {
    return _identifier;
}


//can return nil
-(JBSubject*)getClient:(NSString *)clientUsername {
    return [_clients objectForKey:clientUsername];
}

-(BOOL)hasClient:(NSString *)clientUsername {
    
    if( nil != [_clients objectForKey:clientUsername] ) {
        return true;
    }
    return false;
}



-(NSArray*)getClients {
    
    return [_clients allValues];
    
}

////////////////////////////////////////////////////////////////////////////
// ServerSecurityConfiguration::delete 

-(void)removeClient:(NSString*)clientUsername { 
    
    [self removeSubject:clientUsername];
    
}



#pragma mark instance lifecycle


-(id)initWithIdentifier:(NSString *)identifier configurationService:(JBConfigurationService*)configurationService {
    
    
    JBSecurityConfiguration* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setIdentifier:identifier];
        [answer setConfigurationService:configurationService];
        
        answer->_clients = [[NSMutableDictionary alloc] init];
        answer->_servers = [[NSMutableDictionary alloc] init];
        
        
    }
    
    return answer;
    
}


-(id)initWithValue:(JBJsonObject *)value configurationService:(JBConfigurationService*)configurationService {
    
    
    JBSecurityConfiguration* answer = [super init];

    if( nil != answer ) { 
        
        NSString* identifier = [value stringForKey:@"identifier"];
        [answer setIdentifier:identifier];
        [answer setConfigurationService:configurationService];
        
        answer->_clients = [[NSMutableDictionary alloc] init];
        answer->_servers = [[NSMutableDictionary alloc] init];
        
        {
            JBJsonArray* subjects = [value jsonArrayForKey:@"subjects"];
            for( int i = 0, count = [subjects count]; i < count; i++ ) { 
                JBJsonObject* subjectData = [subjects jsonObjectAtIndex:i];
                
                NSString* subjectIdentifier = [subjectData stringForKey:@"identifier"];
                NSString* subjectPassword = [subjectData stringForKey:@"password"];
                NSString* subjectLabel = [subjectData stringForKey:@"label"];
                
                [answer addSubject:subjectIdentifier password:subjectPassword label:subjectLabel];
            }
        }
    }
    
    return answer;
    
    
}


-(void)dealloc { 
    
    [JBObjectTracker deallocated:self];
    
    [self setIdentifier:nil];
    [self setConfigurationService:nil];
    [self setClients:nil];
    [self setServers:nil];
    
    [self setRegisteredSubjects:nil];
    
}

#pragma mark fields


// identifier
//NSString* _identifier;
//@property (nonatomic, retain) NSString* identifier;
@synthesize identifier = _identifier;


// configurationService
//ConfigurationService* _configurationService;
//@property (nonatomic, retain) ConfigurationService* configurationService;
@synthesize configurationService = _configurationService;


// clients
//NSMutableDictionary* _clients;
//@property (nonatomic, retain) NSMutableDictionary* clients;
@synthesize clients = _clients;


// servers
//NSMutableDictionary* _servers;
//@property (nonatomic, retain) NSMutableDictionary* servers;
@synthesize servers = _servers;



// registeredSubjects
//SubjectGroup* _registeredSubjects;
//@property (nonatomic, retain) SubjectGroup* registeredSubjects;
@synthesize registeredSubjects = _registeredSubjects;



@end

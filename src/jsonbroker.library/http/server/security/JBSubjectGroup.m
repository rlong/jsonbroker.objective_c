//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBHttpErrorHelper.h"
#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBSubjectGroup.h"



@interface JBSubjectGroup () 

#pragma mark private fields 


//NSMutableDictionary* _subjectDictionary;
@property (nonatomic, retain) NSMutableDictionary* subjectDictionary;
//@synthesize subjectDictionary = _subjectDictionary;



@end



@implementation JBSubjectGroup


-(NSEnumerator*)subjectEnumerator {
	return [_subjectDictionary objectEnumerator];
}



-(int)count {
	return (int)[_subjectDictionary count];
}


-(bool)containsUsername:(NSString*)username {

    JBSubject* subject = [_subjectDictionary objectForKey:username];
    
    if( nil != subject ) {
        return true;
    }
    
    return false;
}



-(JBSubject*)subjectForUsername:(NSString*)username {
	
	
	JBSubject* answer = [_subjectDictionary objectForKey:username];
	
	if( nil == answer ) {
        
        Log_errorFormat( @"nil == answer; username = '%@'", username);
        @throw [JBHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
	
	return answer;
	
}


-(void)addSubject:(JBSubject*)subject {

    Log_enteredMethod();

	NSString* username = [subject username];
	
	[_subjectDictionary setObject:subject forKey:username];
	
}

-(void)removeSubjectWithUsername:(NSString*)username {

    Log_enteredMethod();

	[_subjectDictionary removeObjectForKey:username];
	
		
}

-(void)removeSubject:(JBSubject*)subject {
    
    Log_enteredMethod();
    NSString* username = [subject username];
	[_subjectDictionary removeObjectForKey:username];
}



#pragma mark instance setup/teardown

-(id)init {
	
	JBSubjectGroup* answer = [super init];
    
    if( nil != answer ) { 
        
        [JBObjectTracker allocated:answer];
        
        answer->_subjectDictionary = [[NSMutableDictionary alloc] init];

    }
	
	return answer;
	
}

-(void)dealloc {

	[JBObjectTracker deallocated:self];
	
	[self setSubjectDictionary:nil];
	
	[super dealloc];
}


#pragma mark fields


//NSMutableDictionary* _subjectDictionary;
//@property (nonatomic, retain) NSMutableDictionary* subjectDictionary;
@synthesize subjectDictionary = _subjectDictionary;



@end

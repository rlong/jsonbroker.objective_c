//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBSecurityConfiguration_Generated.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBSecurityConfiguration_Generated ()

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation JBSecurityConfiguration_Generated


-(JBJsonObject*)toJsonObject {
	JBJsonObject* answer = [[JBJsonObject alloc] init];
	[answer autorelease];
	[answer setObject:_localRealm forKey:@"localRealm"];
	return answer;
    
}


#pragma mark instance lifecycle

-(id)init {
	return [super init];
}


-(id)initWithJsonObject:(JBJsonObject*)jsonObject {
	
	JBSecurityConfiguration_Generated* answer = [super init];
	
	[answer setLocalRealm:[jsonObject getString:@"localRealm" defaultValue:nil]];
	
	return answer;
	
}

-(void)dealloc {
    
    [self setLocalRealm:nil];
    
	[super dealloc];
    
}



#pragma mark fields

// localRealm
//NSString* _localRealm;
//@property (nonatomic, retain) NSString* localRealm;
@synthesize localRealm = _localRealm;


@end

//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBHttpMethod.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBHttpMethod ()

-(id)initWithName:(NSString*)name;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



@implementation JBHttpMethod


static JBHttpMethod* _GET = nil;
static JBHttpMethod* _OPTIONS = nil;
static JBHttpMethod* _POST = nil;

+(void)initialize {
	
    _GET = [[JBHttpMethod alloc] initWithName:@"GET"];
    _OPTIONS = [[JBHttpMethod alloc] initWithName:@"OPTIONS"];
    _POST = [[JBHttpMethod alloc] initWithName:@"POST"];
	
}


+(JBHttpMethod*)GET {

    return _GET;

}

+(JBHttpMethod*)OPTIONS {

    return _OPTIONS;
    
}

+(JBHttpMethod*)POST {

    return _POST;
    
}

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithName:(NSString*)name {
    
    JBHttpMethod* answer = [super init];
    
    if( nil != answer ) {
        answer->_name = [name retain];
        
    }
    
    return answer;
}

-(void)dealloc {
	
    [_name release];
	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields

// name
//NSString* _name;
//@property (nonatomic, retain) NSString* name;
@synthesize name = _name;

@end

// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBPartialDelimiterMatched.h"




@implementation JBPartialDelimiterMatched





#pragma mark -
#pragma mark instance lifecycle


-(id)initWithMatchingData:(NSData*)matchingData {

    
    JBPartialDelimiterMatched* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setMatchingData:matchingData];
        
    }
    
    
    return answer;

}





-(void)dealloc {
	
	[self setMatchingData:nil];
	
	[super dealloc];
	
}



#pragma mark -
#pragma mark fields

// matchingData
//NSData* _matchingData;
//@property (nonatomic, retain) NSData* matchingData;
@synthesize matchingData = _matchingData;


@end

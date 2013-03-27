//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBLog.h"
#import "JBSimpleSecurityAdapter.h"
#import "JBSecurityUtilities.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBSimpleSecurityAdapter () 


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation JBSimpleSecurityAdapter


+(NSString*)BUNDLE_NAME {
    
    return @"jsonbroker.SecurityConfiguration";
    
}


#pragma mark <IdentifierProvider> implementation 

-(NSString*)getIdentifier {
    
    NSString* answer = [JBSecurityUtilities generateNonce];
    Log_debugString( answer );
    return answer;
    
}

#pragma mark instance lifecycle


#pragma mark fields


@end
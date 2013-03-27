//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBSubject.h"

@protocol JBServerSecurityConfiguration <NSObject>

-(void)addClient:(JBSubject*)client;

-(NSString*)realm;

//can return nil
-(JBSubject*)getClient:(NSString *)clientUsername;

-(BOOL)hasClient:(NSString *)clientUsername;


-(NSArray*)getClients;

-(void)removeClient:(NSString*)clientUsername;
@end

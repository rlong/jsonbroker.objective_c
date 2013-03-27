//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBSubject.h"

@protocol JBClientSecurityConfiguration <NSObject>


-(void)addServer:(JBSubject*)server;
-(NSString*)username;

-(BOOL)hasServer:(NSString *)realm;
-(JBSubject*)getServer:(NSString*)realm;

-(void)removeServer:(NSString *)realm;

@end

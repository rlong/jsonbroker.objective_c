// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@protocol JBJsonOutput <NSObject>


-(void)appendChar:(unichar)c;
-(void)appendString:(NSString*)string;
-(NSString*)toString;

@end

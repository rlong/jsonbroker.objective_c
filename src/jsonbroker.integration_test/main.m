// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBIntegrationTestRunner.h"

int main(int argc, char *argv[])
{
    
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    {
        
        {
            NSString* executable = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
            Log_debugString( executable );
        }
        
        [[NSThread currentThread] setName:@"main"];
        
        [JBIntegrationTestRunner run];
        
        
    }
    
    [pool release];
    return 0;
    
    
    
}


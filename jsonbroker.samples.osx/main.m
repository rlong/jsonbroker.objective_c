//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Cocoa/Cocoa.h>

#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBSampleWebServer.h"
#import "JBWorkManager.h"

int main(int argc, const char * argv[]) {

    // vvv [c - How to prevent SIGPIPEs (or handle them properly) - Stack Overflow](http://stackoverflow.com/questions/108183/how-to-prevent-sigpipes-or-handle-them-properly)
    
    signal(SIGPIPE,SIG_IGN);
    
    // ^^^ [c - How to prevent SIGPIPEs (or handle them properly) - Stack Overflow](http://stackoverflow.com/questions/108183/how-to-prevent-sigpipes-or-handle-them-properly)
    
    
    [[NSThread currentThread] setName:@"main"];
    
    Log_enteredMethod();
    
    {
        NSString* executable = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
        Log_debugString( executable );
    }
    
    {
        [JBWorkManager start];
    }

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    {
        
        
        JBSampleWebServer* webServer = [[JBSampleWebServer alloc] init];
        [webServer start];

        
        Log_info(@"starting main run-loop");
        [[NSRunLoop currentRunLoop] run];
        {
            
        }
        Log_info(@"main run-loop finished");

        [webServer stop];

    }
    JBRelease( pool );
    
    
    
    return 0;

}

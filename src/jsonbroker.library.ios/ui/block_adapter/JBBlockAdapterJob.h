//
//  BlockAdapterJob.h
//  jsonbroker
//
//  Created by rlong on 17/05/13.
//
//

#import <Foundation/Foundation.h>


#import "JBBlockAdapter.h"
#import "JBJob.h"


@interface JBBlockAdapterJob : NSObject <JBJob> {
    
    
    // adapteeResponse
    id _adapteeResponse;
    //@property (nonatomic, retain) id adapteeResponse;
    //@synthesize adapteeResponse = _adapteeResponse;

    // asyncTask
    AsyncTask _asyncTask;
    //@property (nonatomic, copy) AsyncTask asyncTask;
    //@synthesize asyncTask = _asyncTask;
    
    
    // asyncTaskResponse
    id _asyncTaskResponse;
    //@property (nonatomic, retain) id asyncTaskResponse;
    //@synthesize asyncTaskResponse = _asyncTaskResponse;

    
    // asyncTaskDone
    AsyncTaskDone _asyncTaskDone;
    //@property (nonatomic, copy) AsyncTaskDone asyncTaskDone;
    //@synthesize asyncTaskDone = _asyncTaskDone;
    
    
    // asyncTaskFailed
    AsyncTaskFailed _asyncTaskFailed;
    //@property (nonatomic, copy) AsyncTaskFailed asyncTaskFailed;
    //@synthesize asyncTaskFailed = _asyncTaskFailed;

    
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithAdapteeResponse:(id)adapteeResponse asyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed;


@end

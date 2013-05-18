//
//  JBBlockAdapter.h
//  jsonbroker
//
//  Created by rlong on 16/05/13.
//
//

//#import <Foundation/Foundation.h>

#import "JBBaseException.h"

typedef void(^SyncTask)();

typedef id(^AsyncTask)(id adapteeResponse);
typedef void(^AsyncTaskDone)(id adapteeResponse, id asyncTaskResponse);
typedef void(^AsyncTaskFailed)(id adapteeResponse, JBBaseException* exceptionThrown);


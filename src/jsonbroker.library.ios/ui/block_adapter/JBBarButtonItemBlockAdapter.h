//
//  JBBarButtonItemBlockAdapter.h
//  jsonbroker
//
//  Created by rlong on 18/05/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> // explicit import of UI* types

#import "JBAbstractAdapter.h"


typedef id(^JBBarButtonItemDelegate)(UIBarButtonItem* barButtonItem);

@interface JBBarButtonItemBlockAdapter : JBAbstractAdapter {
 
    // client
    UIBarButtonItem* _client;
    //@property (nonatomic, retain) UIBarButtonItem* client;
    //@synthesize client = _client;

    // adaptee
    JBBarButtonItemDelegate _adaptee;
    //@property (nonatomic, copy) JBBarButtonItemDelegate adaptee;
    //@synthesize adaptee = _adaptee;

}

+(JBBarButtonItemBlockAdapter*)adapterWithClient:(UIBarButtonItem*)client adaptee:(JBBarButtonItemDelegate)adaptee;

+(JBBarButtonItemBlockAdapter*)adapterWithClient:(UIBarButtonItem*)client adaptee:(JBBarButtonItemDelegate)adaptee asyncTask:(AsyncTask)asyncTask afterAsyncTaskDone:(AsyncTaskDone)asyncTaskDone afterAsyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed;


@end

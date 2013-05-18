//
//  JBTabBarBlockAdapter.h
//  jsonbroker
//
//  Created by rlong on 17/05/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> // explicit import of UI* types


#import "JBAbstractAdapter.h"


typedef id(^JBTabBarDelegate)(UITabBar* tabBar, UITabBarItem* selectedItem);

@interface JBTabBarBlockAdapter : JBAbstractAdapter <UITabBarDelegate> {

    
    // client
    UITabBar* _client;
    //@property (nonatomic, retain) UITabBar* client;
    //@synthesize client = _client;

    // adaptee
    JBTabBarDelegate _adaptee;
    //@property (nonatomic, copy) JBTabBarDelegate adaptee;
    //@synthesize adaptee = _adaptee;

    
}

+(JBTabBarBlockAdapter*)adapterWithClient:(UITabBar *)client adaptee:(JBTabBarDelegate)adaptee;

+(JBTabBarBlockAdapter*)adapterWithClient:(UITabBar *)client adaptee:(JBTabBarDelegate)adaptee asyncTask:(AsyncTask)asyncTask afterAsyncTaskDone:(AsyncTaskDone)asyncTaskDone afterAsyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed;


@end

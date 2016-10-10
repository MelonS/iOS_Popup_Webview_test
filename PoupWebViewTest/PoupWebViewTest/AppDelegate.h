//
//  AppDelegate.h
//  PoupWebViewTest
//
//  Created by Inc.MelonS on 2016. 10. 5..
//  Copyright © 2016년 MelonS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *appdelegateNaviController;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *appdelegateNaviController;

@end


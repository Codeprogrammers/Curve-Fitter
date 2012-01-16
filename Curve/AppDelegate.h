//
//  AppDelegate.h
//  Curve
//
//  Created by Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *mainNavController;
}

@property (readonly) BOOL isiPad;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *mainNavController;

@end

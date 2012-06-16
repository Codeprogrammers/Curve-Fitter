//
//  AppDelegate.m
//  Curve
//
//  Created by Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 Codeprogrammers LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainNavController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)isiPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    RootViewController *rootController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    mainNavController = [[UINavigationController alloc] initWithRootViewController:rootController];
    self.window = [[UIWindow alloc] initWithFrame: [ [UIScreen mainScreen] bounds]];
    
    if(self.isiPad)
    {
        rootController.contentSizeForViewInPopover = CGSizeMake(320.0, 445.0);
        
        UISplitViewController *iPadCurveRootViewController = [[UISplitViewController alloc] init];
        UINavigationController *rightSideNavigationViewController = [[UINavigationController alloc] init];
        [rightSideNavigationViewController pushViewController:rootController.curveDetailViewController animated:NO];
        
        iPadCurveRootViewController.delegate = rootController.curveDetailViewController;
        iPadCurveRootViewController.viewControllers = [NSArray arrayWithObjects:mainNavController, rightSideNavigationViewController, nil];
        
        [mainNavController release];
        [rightSideNavigationViewController release];
        
        [self.window addSubview:iPadCurveRootViewController.view];
    }
    else
    {
        [self.window addSubview:mainNavController.view];
    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end

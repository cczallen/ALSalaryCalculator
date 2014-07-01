//
//  AppDelegate.m
//  ALSalaryCalculator
//
//  Created by ALLENMAC on 2014/6/29.
//  Copyright (c) 2014年 AllenLee. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	[self _setCoverEnabled:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[self _setCoverEnabled:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[self _setCoverEnabled:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[self _setCoverEnabled:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)_setCoverEnabled:(BOOL)enabled {

	NSUInteger tag = 10588;
	UIView *coverView = [self.window viewWithTag:tag];
	if (enabled) {
		if (!coverView) {
			NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
			
			UITextField * tf = [[UITextField alloc] initWithFrame:self.window.bounds];
			[tf  setFont:[UIFont fontWithName:tf.font.fontName size:35]];
			[tf  setTextAlignment:NSTextAlignmentCenter];
			[tf  setText:name];
			
			coverView = tf;
			coverView.backgroundColor = [UIColor colorWithRed:0.223 green:0.747 blue:1.000 alpha:1.000];
			coverView.tag = tag;
			coverView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
			[self.window addSubview:coverView];
		}
		coverView.alpha = 1;
	}else {
		coverView.alpha = 0;
	}
}

@end

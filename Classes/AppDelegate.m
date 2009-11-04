//
//  AppDelegate.m
//  JSONBenchmarks
//
//  Created by Sam Soffes on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

#pragma mark -
#pragma mark NSObject
#pragma mark -

- (void)dealloc {
    [window release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIApplicationDelegate
#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window makeKeyAndVisible];
}

@end

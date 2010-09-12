//
//  JBAppDelegate.m
//  JSONBenchmarks
//
//  Created by Sam Soffes on 11/4/09.
//  Copyright 2009 Sam Soffes. All rights reserved.
//

#import "JBAppDelegate.h"
#import "JBResultsViewController.h"
#import "JBConstants.h"
#import "JSONParser.h"
#import "JSONWriter.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "JSONKit.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "NSObject+YAJL.h"

// Comparer function for sorting
static int _compareResults(NSDictionary *result1, NSDictionary *result2, void *context) {
	return [[result1 objectForKey:JBAverageTimeKey] compare:[result2 objectForKey:JBAverageTimeKey]];
}


@implementation JBAppDelegate

#pragma mark NSObject

- (void)dealloc {
	[_navigationController release];
	[_window release];
	[super dealloc];
}

#pragma mark Benchmarking

- (void)benchmark {
	// This could obviously be better, but I'm trying to keep things simple.
	
	// Configuration
	NSUInteger times = 100;
	NSLog(@"Starting benchmarks with %i iterations for each library", times);
	NSStringEncoding stringEncoding = NSUTF8StringEncoding;
	NSStringEncoding dataEncoding = stringEncoding; //NSUTF32BigEndianStringEncoding;	
	
	// Load JSON string
	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"] encoding:stringEncoding error:nil];
	NSData *jsonData = [jsonString dataUsingEncoding:dataEncoding];
	NSArray *array = (NSArray *)[[CJSONDeserializer deserializer] deserialize:jsonData error:nil];
	NSUInteger x = 0;
	
	// Read with Apple JSON
	NSTimeInterval appleJSONReadTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		id object = [JSON objectWithData:jsonData options:0 error:nil];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		appleJSONReadTotal += time;
		[object description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval appleJSONReadAverage = (appleJSONReadTotal / times);
	NSLog(@"Apple JSON average read time: %f", appleJSONReadAverage);
	
	// Write with Apple JSON
	NSTimeInterval appleJSONWriteTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		NSString *writtenString = [JSON stringWithObject:array options:0 error:nil];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		appleJSONWriteTotal += time;
		[writtenString description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval appleJSONWriteAverage = (appleJSONWriteTotal / times);
	NSLog(@"Apple JSON average write time: %f", appleJSONWriteAverage);
	
	// Read with JSON Framework
	NSTimeInterval jsonFrameworkReadTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		SBJsonParser *parser = [[SBJsonParser new] autorelease];
		NSDate *before = [NSDate date];
		id object = [parser objectWithString:jsonString];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		jsonFrameworkReadTotal += time;
		[object description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval jsonFrameworkReadAverage = (jsonFrameworkReadTotal / times);
	NSLog(@"JSON Framework average read time: %f", jsonFrameworkReadAverage);
	
	// Write with JSON Framework
	NSTimeInterval jsonFrameworkWriteTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		SBJsonWriter *writer = [[SBJsonWriter new] autorelease];
		NSDate *before = [NSDate date];
		NSString *writtenString = [writer stringWithObject:array];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		jsonFrameworkWriteTotal += time;
		[writtenString description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval jsonFrameworkWriteAverage = (jsonFrameworkWriteTotal / times);
	NSLog(@"JSON Framework average write time: %f", jsonFrameworkWriteAverage);
	
	// Read with JSONKit
	NSTimeInterval jsonKitReadTotal = 0.0;
	JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		id object = [jsonKitDecoder parseJSONData:jsonData];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		jsonKitReadTotal += time;
		[object description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval jsonKitReadAverage = (jsonKitReadTotal / times);
	NSLog(@"JSONKit average read time: %f", jsonKitReadAverage);
	
	// Write with JSONKit
	NSTimeInterval jsonKitWriteTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		NSString *writtenString = [array JSONString];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		jsonKitWriteTotal += time;
		[writtenString description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval jsonKitWriteAverage = (jsonKitWriteTotal / times);
	NSLog(@"JSONKit average write time: %f", jsonKitWriteAverage);
	
	// Read with TouchJSON
	NSTimeInterval touchJSONReadTotal = 0.0;
	CJSONDeserializer *parser = [CJSONDeserializer deserializer];
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		id object = [parser deserialize:jsonData error:nil];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		touchJSONReadTotal += time;
		[object description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval touchJSONReadAverage = (touchJSONReadTotal / times);
	NSLog(@"TouchJSON average read time: %f", touchJSONReadAverage);
	
	// Write with TouchJSON
	NSTimeInterval touchJSONWriteTotal = 0.0;
	CJSONSerializer *writer = [CJSONSerializer serializer];
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		NSString *writtenString = [writer serializeArray:array error:nil];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		touchJSONWriteTotal += time;
		[writtenString description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval touchJSONWriteAverage = (touchJSONWriteTotal / times);
	NSLog(@"TouchJSON average write time: %f", touchJSONWriteAverage);
	
	// Read with YAJL
	NSTimeInterval yajlReadTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		id object = [jsonString yajl_JSON];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		yajlReadTotal += time;
		[object description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval yajlReadAverage = (yajlReadTotal / times);
	NSLog(@"YAJL average read time: %f", yajlReadAverage);
	
	// Write with YAJL
	NSTimeInterval yajlWriteTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		NSString *writtenString = [array yajl_JSONString];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		yajlWriteTotal += time;
		[writtenString description]; // Eliminate warning
		[pool release];
	}
	NSTimeInterval yajlWriteAverage = (yajlWriteTotal / times);
	NSLog(@"YAJL average write time: %f", yajlWriteAverage);
	
	// Done. Construct results
	NSMutableArray *readingResults = [[NSMutableArray alloc] initWithObjects:
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"Apple JSON", JBLibraryKey,
									   [NSNumber numberWithDouble:appleJSONReadAverage], JBAverageTimeKey,
									   nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"JSON Framework", JBLibraryKey,
									   [NSNumber numberWithDouble:jsonFrameworkReadAverage], JBAverageTimeKey,
									   nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"JSONKit", JBLibraryKey,
									   [NSNumber numberWithDouble:jsonKitReadAverage], JBAverageTimeKey,
									   nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"TouchJSON", JBLibraryKey,
									   [NSNumber numberWithDouble:touchJSONReadAverage], JBAverageTimeKey,
									   nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"YAJL", JBLibraryKey,
									   [NSNumber numberWithDouble:yajlReadAverage], JBAverageTimeKey,
									   nil],
									  nil];
	[readingResults sortUsingFunction:_compareResults context:nil];
	
	NSMutableArray *writingResults = [[NSMutableArray alloc] initWithObjects:
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"Apple JSON", JBLibraryKey,
									   [NSNumber numberWithDouble:appleJSONWriteAverage], JBAverageTimeKey,
									   nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"JSON Framework", JBLibraryKey,
									   [NSNumber numberWithDouble:jsonFrameworkWriteAverage], JBAverageTimeKey,
									   nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"JSONKit", JBLibraryKey,
									   [NSNumber numberWithDouble:jsonKitWriteAverage], JBAverageTimeKey,
									   nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"TouchJSON", JBLibraryKey,
									   [NSNumber numberWithDouble:touchJSONWriteAverage], JBAverageTimeKey,
									   nil],
									  [NSDictionary dictionaryWithObjectsAndKeys:
									   @"YAJL", JBLibraryKey,
									   [NSNumber numberWithDouble:yajlWriteAverage], JBAverageTimeKey,
									   nil],
									  nil];
	[writingResults sortUsingFunction:_compareResults context:nil];
	
	NSDictionary *allResults = [[NSDictionary alloc] initWithObjectsAndKeys:
								readingResults, JBReadingKey,
								writingResults, JBWritingKey,
								nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:JBDidFinishBenchmarksNotification object:allResults];
	
	[readingResults release];
	[writingResults release];
	[allResults release];
}


#pragma mark UIApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Setup UI
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	JBResultsViewController *viewController = [[JBResultsViewController alloc] init];
	_navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	[viewController release];
	[_window addSubview:_navigationController.view];
	[_window makeKeyAndVisible];
	
	// Perform after delay so UI doesn't block
	[self performSelector:@selector(benchmark) withObject:nil afterDelay:0.1];
}

@end

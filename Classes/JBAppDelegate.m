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

#define times 100

// Comparer function for sorting
static int _compareResults(NSDictionary *result1, NSDictionary *result2, void *context) {
	return [[result1 objectForKey:JBAverageTimeKey] compare:[result2 objectForKey:JBAverageTimeKey]];
}

#define x(x) do { x; x; x; x; x; } while (0)

static inline NSTimeInterval bench( NSString *what, void (^block)(void) ) {
	NSTimeInterval duration = 0.0;

	for (int x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		block();
		duration += -[before timeIntervalSinceNow];
		[pool release];
	}
	
	NSTimeInterval avg = duration / (double)times * 1000;
	NSLog(@"%@ average: %.3fms", what, avg);
	
	return avg;
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
	NSLog(@"Starting benchmarks with %i iterations for each library", times);
	NSStringEncoding stringEncoding = NSUTF8StringEncoding;
	NSStringEncoding dataEncoding = stringEncoding; //NSUTF32BigEndianStringEncoding;	
	
	// Load JSON string
	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"] encoding:stringEncoding error:nil];
	NSData *jsonData = [jsonString dataUsingEncoding:dataEncoding];
	NSArray *array = (NSArray *)[[CJSONDeserializer deserializer] deserialize:jsonData error:nil];
	
	NSTimeInterval appleJSONReadAverage = bench(@"Apple JSON read", ^{
		x([JSON objectWithData:jsonData options:0 error:nil]);
	});
	
	NSTimeInterval appleJSONWriteAverage = bench(@"Apple JSON write", ^{
		x([JSON stringWithObject:array options:0 error:nil]);
	});
	
	SBJsonParser *sbjsonParser = [[SBJsonParser new] autorelease];
	NSTimeInterval jsonFrameworkReadAverage = bench(@"JSON Framework read", ^{
		x([sbjsonParser objectWithString:jsonString]);
	});
	
	SBJsonWriter *sbjsonWriter = [[SBJsonWriter new] autorelease];
	NSTimeInterval jsonFrameworkWriteAverage = bench(@"JSON Framework write", ^{
		x([sbjsonWriter stringWithObject:array]);
	});
	
	JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
	NSTimeInterval jsonKitReadAverage = bench(@"JSONKit read", ^{
		x([jsonKitDecoder parseJSONData:jsonData]);
	});
	
	NSTimeInterval jsonKitWriteAverage = bench(@"JSONKit write", ^{
		x([array JSONString]);
	});
	
	CJSONDeserializer *cjsonDeserialiser = [CJSONDeserializer deserializer];
	NSTimeInterval touchJSONReadAverage = bench(@"TouchJSON read", ^{
		x([cjsonDeserialiser deserialize:jsonData error:nil]);
	});
	
	CJSONSerializer *cjsonSerializer = [CJSONSerializer serializer];
	NSTimeInterval touchJSONWriteAverage = bench(@"TouchJSON write", ^{
		x([cjsonSerializer serializeArray:array error:nil]);
	});
	
	NSTimeInterval yajlReadAverage = bench(@"YAJL read", ^{
		x([jsonString yajl_JSON]);
	});
	
	NSTimeInterval yajlWriteAverage = bench(@"YAJL write", ^{
		x([array yajl_JSONString]);
	});
	
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

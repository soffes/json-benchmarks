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

static inline NSTimeInterval bench( void (^block)(void) ) {
	NSTimeInterval duration = 0.0;

	for (int x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		block();
		duration += -[before timeIntervalSinceNow];
		[pool release];
	}
	
	return duration / (double)times;
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
	
	NSTimeInterval appleJSONReadAverage = bench(^{
		x([JSON objectWithData:jsonData options:0 error:nil]);
	});
	NSLog(@"Apple JSON average read time: %f", appleJSONReadAverage);
	
	NSTimeInterval appleJSONWriteAverage = bench(^{
		x([JSON stringWithObject:array options:0 error:nil]);
	});
	NSLog(@"Apple JSON average write time: %f", appleJSONWriteAverage);
	
	SBJsonParser *sbjsonParser = [[SBJsonParser new] autorelease];
	NSTimeInterval jsonFrameworkReadAverage = bench(^{
		x([sbjsonParser objectWithString:jsonString]);
	});
	NSLog(@"JSON Framework average read time: %f", jsonFrameworkReadAverage);
	
	SBJsonWriter *sbjsonWriter = [[SBJsonWriter new] autorelease];
	NSTimeInterval jsonFrameworkWriteAverage = bench(^{
		x([sbjsonWriter stringWithObject:array]);
	});
	NSLog(@"JSON Framework average write time: %f", jsonFrameworkWriteAverage);
	
	JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
	NSTimeInterval jsonKitReadAverage = bench(^{
		x([jsonKitDecoder parseJSONData:jsonData]);
	});
	NSLog(@"JSONKit average read time: %f", jsonKitReadAverage);
	
	NSTimeInterval jsonKitWriteAverage = bench(^{
		x([array JSONString]);
	});
	NSLog(@"JSONKit average write time: %f", jsonKitWriteAverage);
	
	CJSONDeserializer *cjsonDeserialiser = [CJSONDeserializer deserializer];
	NSTimeInterval touchJSONReadAverage = bench(^{
		x([cjsonDeserialiser deserialize:jsonData error:nil]);
	});
	NSLog(@"TouchJSON average read time: %f", touchJSONReadAverage);
	
	CJSONSerializer *cjsonSerializer = [CJSONSerializer serializer];
	NSTimeInterval touchJSONWriteAverage = bench(^{
		x([cjsonSerializer serializeArray:array error:nil]);
	});
	NSLog(@"TouchJSON average write time: %f", touchJSONWriteAverage);
	
	NSTimeInterval yajlReadAverage = bench(^{
		x([jsonString yajl_JSON]);
	});
	NSLog(@"YAJL average read time: %f", yajlReadAverage);
	
	NSTimeInterval yajlWriteAverage = bench(^{
		x([array yajl_JSONString]);
	});
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

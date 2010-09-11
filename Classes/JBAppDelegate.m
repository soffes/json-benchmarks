//
//  JBAppDelegate.m
//  JSONBenchmarks
//
//  Created by Sam Soffes on 11/4/09.
//  Copyright 2009 Sam Soffes. All rights reserved.
//

#import "JBAppDelegate.h"

// TouchJSON
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

// JSON Framework
#import "JSON.h"

// YAJL
#import "NSObject+YAJL.h"

// Apple JSON
#import "JSONParser.h"
#import "JSONWriter.h"

@implementation JBAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configuration
	NSUInteger times = 100;
	NSLog(@"Starting benchmarks with %i iterations for each library\n", times);
	NSStringEncoding stringEncoding = NSUTF8StringEncoding;
	NSStringEncoding dataEncoding = stringEncoding; //NSUTF32BigEndianStringEncoding;	
	
	// Load JSON string
	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"] encoding:stringEncoding error:nil];
	NSData *jsonData = [jsonString dataUsingEncoding:dataEncoding];
	NSArray *array = (NSArray *)[[CJSONDeserializer deserializer] deserialize:jsonData error:nil];
	NSUInteger x = 0;
	
	// Read with TouchJSON
	NSTimeInterval touchJSONReadTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		CJSONDeserializer *parser = [CJSONDeserializer deserializer];
		NSDate *before = [NSDate date];
		id object = [parser deserialize:jsonData error:nil];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		touchJSONReadTotal += time;
		[object description]; // Eliminate warning
		[pool release];
	}
	NSLog(@"TouchJSON average read time: %f", (touchJSONReadTotal / times));
	
	// Write with TouchJSON
	NSTimeInterval touchJSONWriteTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		CJSONSerializer *writer = [CJSONSerializer serializer];
		NSDate *before = [NSDate date];
		NSString *writtenString = [writer serializeArray:array];
		NSDate *after = [NSDate date];
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		touchJSONWriteTotal += time;
		[writtenString description]; // Eliminate warning
		[pool release];
	}
	NSLog(@"TouchJSON average write time: %f", (touchJSONWriteTotal / times));
	
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
	NSLog(@"JSON Framework average read time: %f", (jsonFrameworkReadTotal / times));
	
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
	NSLog(@"JSON Framework average write time: %f", (jsonFrameworkWriteTotal / times));
	
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
	NSLog(@"YAJL average read time: %f", (yajlReadTotal / times));
	
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
	NSLog(@"YAJL average write time: %f", (yajlWriteTotal / times));
	
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
	NSLog(@"Apple JSON average read time: %f", (appleJSONReadTotal / times));
	
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
	NSLog(@"Apple JSON average write time: %f", (appleJSONWriteTotal / times));
	
	NSLog(@"Done. Quitting...");
	abort();
}

@end

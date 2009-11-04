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
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

// Apple JSON
#import "JSONParser.h"
#import "JSONWriter.h"

@implementation JBAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSUInteger times = 100;
	NSUInteger x = 0;
	
	NSLog(@"Loading JSON string");
	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"]];
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSArray *array = (NSArray *)[[CJSONDeserializer deserializer] deserialize:jsonData error:nil];
	
	NSLog(@"*** Parsing with TouchJSON");
	NSTimeInterval touchJSONParseTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		id object = [[CJSONDeserializer deserializer] deserialize:jsonData error:nil];
		NSDate *after = [NSDate date];
		[object description]; // Eliminate warning
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		touchJSONParseTotal += time;
		[pool release];
	}
	NSLog(@"  * TouchJSON average parse time: %f", (touchJSONParseTotal / times));
	
	NSLog(@"*** Parsing with JSON Framework");
	NSTimeInterval jsonFrameworkParseTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		id object = [jsonString JSONValue];
		NSDate *after = [NSDate date];
		[object description]; // Eliminate warning
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		jsonFrameworkParseTotal += time;
		[pool release];
	}
	NSLog(@"  * JSON Framework average parse time: %f", (jsonFrameworkParseTotal / times));
	
	NSLog(@"*** Parsing with Apple JSON");
	NSTimeInterval appleJSONParseTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		id object = [JSON objectWithData:jsonData options:0 error:nil];
		NSDate *after = [NSDate date];
		[object description]; // Eliminate warning
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		appleJSONParseTotal += time;
		[pool release];
	}
	NSLog(@"  * Apple JSON average parse time: %f", (appleJSONParseTotal / times));
	
	NSLog(@"*** Writing with TouchJSON");
	NSTimeInterval touchJSONWriteTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		NSString *writtenString = [[CJSONSerializer serializer] serializeArray:array];
		NSDate *after = [NSDate date];
		[writtenString description]; // Eliminate warning
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		touchJSONWriteTotal += time;
		[pool release];
	}
	NSLog(@"  * TouchJSON average write time: %f", (touchJSONWriteTotal / times));
	
	NSLog(@"*** Parsing with JSON Framework");
	NSTimeInterval jsonFrameworkWriteTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		NSString *writtenString = [array JSONRepresentation];
		NSDate *after = [NSDate date];
		[writtenString description]; // Eliminate warning
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		jsonFrameworkWriteTotal += time;
		[pool release];
	}
	NSLog(@"  * JSON Framework average write time: %f", (jsonFrameworkWriteTotal / times));
	
	NSLog(@"*** Parsing with Apple JSON");
	NSTimeInterval appleJSONWriteTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSDate *before = [NSDate date];
		NSString *writtenString = [JSON stringWithObject:array options:0 error:nil];
		NSDate *after = [NSDate date];
		[writtenString description]; // Eliminate warning
		NSTimeInterval time = [after timeIntervalSinceDate:before];
		appleJSONWriteTotal += time;
		[pool release];
	}
	NSLog(@"  * Apple JSON average write time: %f", (appleJSONWriteTotal / times));
	
	NSLog(@"*** DONE");
}

@end

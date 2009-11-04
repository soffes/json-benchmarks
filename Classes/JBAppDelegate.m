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

// JSON Framework
#import "NSString+SBJSON.h"

// Apple JSON
#import "JSONParser.h"

@implementation JBAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSUInteger times = 500;
	NSUInteger x = 0;
	
	NSLog(@"Loading JSON string");
	NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twitter_public_timeline" ofType:@"json"]];
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	
	NSLog(@"*** Parsing with TouchJSON");
	NSTimeInterval touchJSONParseTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSDate *before = [NSDate date];
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
		NSDate *after = [NSDate date];
		[dictionary description]; // Eliminate warning
		NSTimeInterval parseTime = [after timeIntervalSinceDate:before];
//		NSLog(@"  * TouchJSON parse time: %f", parseTime);
		touchJSONParseTotal += parseTime;
	}
	NSLog(@" ** TouchJSON average parse time: %f", (touchJSONParseTotal / times));
	
	NSLog(@"*** Parsing with JSON Framework");
	NSTimeInterval jsonFrameworkParseTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSDate *before = [NSDate date];
		NSDictionary *dictionary = [jsonString JSONValue];
		NSDate *after = [NSDate date];
		[dictionary description]; // Eliminate warning
		NSTimeInterval parseTime = [after timeIntervalSinceDate:before];
//		NSLog(@"  * JSON Framework parse time: %f", parseTime);
		jsonFrameworkParseTotal += parseTime;
	}
	NSLog(@" ** JSON Framework average parse time: %f", (jsonFrameworkParseTotal / times));
	
	NSLog(@"*** Parsing with Apple JSON");
	NSTimeInterval appleJSONParseTotal = 0.0;
	for (x = 0; x < times; x++) {
		NSDate *before = [NSDate date];
		NSDictionary *dictionary = [JSON objectWithData:jsonData options:0 error:nil];
		NSDate *after = [NSDate date];
		[dictionary description]; // Eliminate warning
		NSTimeInterval parseTime = [after timeIntervalSinceDate:before];
//		NSLog(@"  * Apple JSON parse time: %f", parseTime);
		appleJSONParseTotal += parseTime;
	}
	NSLog(@" ** Apple JSON average parse time: %f", (appleJSONParseTotal / times));
}

@end

//
//  JBResultsViewController.m
//  JSONBenchmarks
//
//  Created by Sam Soffes on 9/12/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "JBResultsViewController.h"
#import "JBConstants.h"

@interface JBResultsViewController (PrivateMethods)
- (void)_didFinishBenchmarks:(NSNotification *)notification;
- (NSArray *)_results;
@end


@implementation JBResultsViewController

#pragma mark NSObject

- (id)init {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didFinishBenchmarks:) name:JBDidFinishBenchmarksNotification object:nil];
	}
    return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_segmentedControl release];
	[_allResults release];
	[super dealloc];
}


#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Segmented control
	NSArray *items = [[NSArray alloc] initWithObjects:@"Reading", @"Writing", nil];
	_segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
	[items release];
	_segmentedControl.enabled = NO;
	_segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	_segmentedControl.selectedSegmentIndex = 0;
	_segmentedControl.frame = CGRectMake(0.0, 0.0, 280.0, 32.0);
	[_segmentedControl addTarget:self.tableView action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = _segmentedControl;
	
	// Indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[indicator startAnimating];
	UIBarButtonItem *indicatorItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
	[indicator release];
	self.navigationItem.rightBarButtonItem = indicatorItem;
	[indicatorItem release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark Private Methods

- (void)_didFinishBenchmarks:(NSNotification *)notification {	
	[_allResults release];
	_allResults = [[notification object] retain];
	
	// Update UI
	self.navigationItem.rightBarButtonItem = nil;
	_segmentedControl.enabled = YES;
	[self.tableView reloadData];
}

- (NSArray *)_results {
	return [_allResults objectForKey:((_segmentedControl.selectedSegmentIndex == 0) ? JBReadingKey : JBWritingKey)];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self _results] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	NSDictionary *result = [[self _results] objectAtIndex:indexPath.row];
	cell.textLabel.text = [result objectForKey:JBLibraryKey];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%.08f seconds", [[result objectForKey:JBAverageTimeKey] floatValue]];
    
    return cell;
}

@end

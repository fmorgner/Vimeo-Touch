//
//  ChannelsList.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 11.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "ChannelsList.h"

@implementation ChannelsList

@synthesize appDelegate;
@synthesize channelList;
@synthesize loadedData;
@synthesize connection;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		{
		[self setAppDelegate:[[UIApplication sharedApplication] delegate]];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Channels" image:[UIImage imageNamed:@"70-tv"] tag:0];
		self.title = @"Channels";
		channelList = nil;
		}

	return self;
	}

- (void)viewDidAppear:(BOOL)animated
	{
	NSURL* url = [NSURL URLWithString:kVimeoRestURL];
	OAuthParameter* parameter = [OAuthParameter parameterWithKey:@"method" andValue:kVimeoMethodChannelsGetAll];
	url = [url URLByAppendingParameter:parameter];
	OAuthRequest* request = [OAuthRequest requestWithURL:url consumer:appDelegate.consumer token:nil realm:nil signerClass:nil];
	[request prepare];

	OAuthRequestFetcher* fetcher = [[OAuthRequestFetcher alloc] init];
	[fetcher fetchRequest:request completionHandler:^(NSData *fetchedData) {
		VimeoAPIResponse* response = [[VimeoAPIResponse alloc] initWithData:fetchedData];
		[self setChannelList:[[response content] objectForKey:@"channels"]];
		[(UITableView*)self.view reloadData];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[super viewDidAppear:animated];
	}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
	return YES;
	}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
	{
	return 1;
	}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
	{
	return [channelList count];
	}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
		{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	[cell.textLabel setText:[[channelList objectAtIndex:indexPath.row] name]];    
    
	return cell;
	}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
	}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
	{
	[super didReceiveMemoryWarning];
	}

- (void)viewDidUnload
	{
	}


- (void)dealloc
	{
	[loadedData release];
	[super dealloc];
	}


@end


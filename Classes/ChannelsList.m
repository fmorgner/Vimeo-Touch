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

#pragma mark - View lifecycle

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
	if(!channelList)
		{
		[appDelegate.vimeoController callMethod:kVimeoMethodChannelsGetAll withParameters:nil delegate:self sign:NO];	
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		}
	else
		{
		[(UITableView*)self.view reloadData];
		}
	[super viewDidAppear:animated];
	}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
	return YES;
	}

- (void)reloadChannels
	{
	[appDelegate.vimeoController callMethod:kVimeoMethodChannelsGetAll withParameters:nil delegate:self sign:NO];	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}

#pragma mark - Table view data source

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

#pragma mark - Table View Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
	}
	
#pragma mark - Vimeo Controller Delegate

- (void)vimeoController:(VimeoController *)aController didFetchResponse:(VimeoAPIResponse *)theResponse
	{
	if([theResponse.type isEqualToString:kVimeoChannelsResponseType] && !theResponse.error)
		{
		[self setChannelList:[[theResponse content] valueForKey:@"channels"]];
		[(UITableView*)self.view reloadData];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		}
	}

- (void)vimeoController:(VimeoController *)aController didFailFetchingWithError:(NSError *)theError
	{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}

#pragma mark - Memory Management

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


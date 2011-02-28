//
//  ChannelDetail.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 28.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "ChannelDetail.h"
#import "AppDelegate.h"

@implementation ChannelDetail

@synthesize channel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
	{
	[super viewDidLoad];
	self.title = channel.name;
	channelNameLabel.text = channel.name;
	channelDescriptionView.text = channel.desc;
	[channel loadVideos:[(AppDelegate*)[[UIApplication sharedApplication] delegate] consumer]];
	[[NSNotificationCenter defaultCenter] addObserver:videosTableView selector:@selector(reloadData) name:@"kVimeoChannelVideosLoadedNotification" object:channel];
	}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View Data Source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
	{
	return 1;
	}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
	{
	return [channel.videos count];
	}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
		{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	[cell.textLabel setText:[[channel.videos objectAtIndex:indexPath.row] title]];    
    
	return cell;
	}


@end

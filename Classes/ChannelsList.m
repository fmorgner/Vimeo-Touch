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

	
	connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[super viewDidAppear:animated];
	}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
	return YES;
	}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [channelList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	[cell.textLabel setText:[[channelList objectAtIndex:indexPath.row] name]];    
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	if(!loadedData)
		loadedData = [[NSMutableData alloc] init];
		
	[loadedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	VimeoAPIResponse* response = [[VimeoAPIResponse alloc] initWithData:loadedData];
	if(!response.error)
		{
		[self setChannelList:[response.content objectForKey:@"channels"]];
		[self.view reloadData];
		}
	[response release];
	[loadedData release];
	loadedData = nil;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[loadedData release];
    [super dealloc];
}


@end


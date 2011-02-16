//
//  ChannelsList.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 11.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vimeo.h"
#import "AppDelegate.h"

@interface ChannelsList : UITableViewController <UITableViewDataSource>
	{
	AppDelegate* appDelegate;
	NSArray* channelList;
	}

@property(nonatomic, retain) AppDelegate* appDelegate;
@property(nonatomic, retain) NSArray* channelList;

@end
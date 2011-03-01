//
//  ChannelDetail.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 28.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VimeoChannel.h"

@interface ChannelDetail : UIViewController <UITableViewDataSource,UITableViewDelegate>
	{
	IBOutlet UILabel* channelNameLabel;
	IBOutlet UITextView* channelDescriptionView;
	IBOutlet UITableView* videosTableView;
	
	VimeoChannel* channel;
	}

@property(nonatomic, retain) VimeoChannel* channel;

@end

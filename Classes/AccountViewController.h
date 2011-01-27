//
//  AccountViewController.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuth.h"


@interface AccountViewController : UIViewController <UIWebViewDelegate>
	{
	OAuthConsumer* consumer;
	}

- (IBAction)login:(id)sender;

@property(nonatomic, retain) OAuthConsumer* consumer;

@end

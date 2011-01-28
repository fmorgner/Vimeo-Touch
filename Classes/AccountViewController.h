//
//  AccountViewController.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "VimeoController.h"
#import "VimeoAuthorizationViewController.h"
#import "OAuth.h"
#import "NSMutableURLRequest+OAuthParameters.h"

@interface AccountViewController : UIViewController <UIWebViewDelegate>
	{
	VimeoController* vimeoController;
	AppDelegate* appDelegate;
	}

- (IBAction)login:(id)sender;

@property(nonatomic, retain) VimeoController* vimeoController;
@property(nonatomic, retain) AppDelegate* appDelegate;

@end

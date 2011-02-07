//
//  AccountViewController.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "OAuth.h"
#import "Vimeo.h"

@interface AccountViewController : UIViewController <VimeoAuthorizationViewControllerDelegate, UITableViewDataSource>
	{
	VimeoController* vimeoController;
	AppDelegate* appDelegate;
	
	NSArray* userInformation;
	}

- (IBAction)login:(id)sender;
- (OAuthToken*)fetchAccessTokenWithVerifier:(NSString*)verifier;


@property(nonatomic, retain) VimeoController* vimeoController;
@property(nonatomic, retain) AppDelegate* appDelegate;
@property(nonatomic, retain) NSArray* userInformation;

@end

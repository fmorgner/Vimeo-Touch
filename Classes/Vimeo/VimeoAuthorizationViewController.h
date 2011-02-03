//
//  VimeoAuthorizationViewController.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 27.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuth.h"
#import "VimeoConstants.h"


@interface VimeoAuthorizationViewController : UIViewController <UIWebViewDelegate>
	{
	UIWebView* webView;
	NSURL* authorizationURL;
	OAuthToken* token;
	id delegate;
	}

- (id)initWithToken:(OAuthToken*)aToken;
+ (VimeoAuthorizationViewController*)authorizationViewControllerWithToken:(OAuthToken*)aToken;

@property(nonatomic, retain) UIWebView* webView;
@property(nonatomic, retain) NSURL* authorizationURL;
@property(nonatomic, assign) OAuthToken* token;
@property(nonatomic, assign) id delegate;

@end

@protocol VimeoAuthorizationViewControllerDelegate <NSObject>

- (void)authorizationViewController:(VimeoAuthorizationViewController*)authViewController didReceiveVerifier:(NSString*)theVerifier;

@end
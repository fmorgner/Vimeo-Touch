//
//  VimeoAuthorizationViewController.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 27.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OAuth.h"
#import "VimeoConstants.h"
#import "VimeoLoadingOverlay.h"


@interface VimeoAuthorizationViewController : UIViewController <UIWebViewDelegate>
	{
	UIWebView* webView;
	VimeoLoadingOverlay* loadingOverlay;
	OAuthToken* token;
	id delegate;
	}

- (id)initWithToken:(OAuthToken*)aToken delegate:(id)aDelegate;
+ (VimeoAuthorizationViewController*)authorizationViewControllerWithToken:(OAuthToken*)aToken delegate:(id)aDelegate;

@property(nonatomic, retain) UIWebView* webView;
@property(nonatomic, retain) VimeoLoadingOverlay* loadingOverlay;
@property(nonatomic, assign) OAuthToken* token;
@property(nonatomic, assign) id delegate;

@end

@protocol VimeoAuthorizationViewControllerDelegate <NSObject>

- (void)authorizationViewController:(VimeoAuthorizationViewController*)authViewController didReceiveVerifier:(NSString*)theVerifier;

@end
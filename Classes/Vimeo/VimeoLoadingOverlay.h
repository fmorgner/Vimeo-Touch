//
//  VimeoLoadingOverlay.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 04.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface VimeoLoadingOverlay : UIView 
	{
	UIActivityIndicatorView* loadingIndicator;
	UILabel* messageLabel;
	UIView* overlayView;
	}

@property(nonatomic, retain) UIActivityIndicatorView* loadingIndicator;
@property(nonatomic, retain) UILabel* messageLabel;
@property(nonatomic, retain) UIView* overlayView;

@end

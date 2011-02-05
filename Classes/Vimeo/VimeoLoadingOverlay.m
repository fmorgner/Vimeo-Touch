//
//  VimeoLoadingOverlay.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 04.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoLoadingOverlay.h"

#define kOffsetCenterY 15

@implementation VimeoLoadingOverlay

@synthesize overlayView;
@synthesize loadingIndicator;
@synthesize messageLabel;

- (id)initWithFrame:(CGRect)frame
	{
	if ((self = [super initWithFrame:frame]))
		{
		[self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];

		overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
		overlayView.center = self.center;
		overlayView.layer.backgroundColor = [[UIColor blackColor] CGColor];
		overlayView.layer.cornerRadius = 10;
		overlayView.layer.opacity = 0.75f;
		
		loadingIndicator  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		loadingIndicator.frame = CGRectMake(0, 0, 25, 25);
		loadingIndicator.center = CGPointMake(overlayView.center.x, overlayView.center.y - kOffsetCenterY);
		loadingIndicator.hidesWhenStopped = YES;

		messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
		messageLabel.text = @"Loading";
		messageLabel.font = [UIFont systemFontOfSize:15];
		messageLabel.textColor = [UIColor whiteColor];
		messageLabel.userInteractionEnabled = NO;
		messageLabel.textAlignment = UITextAlignmentCenter;
		messageLabel.center = CGPointMake(overlayView.center.x, overlayView.center.y + kOffsetCenterY);
		messageLabel.backgroundColor = [UIColor clearColor];
		
		self.userInteractionEnabled = NO;
		
		[self addSubview:overlayView];
		[self addSubview:loadingIndicator];
		[self addSubview:messageLabel];
		}
	return self;
	}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
	{
	if([keyPath isEqualToString:@"hidden"] && [[change valueForKey:NSKeyValueChangeNewKey] boolValue])
		{
		[loadingIndicator stopAnimating];  
		}
	else if ([keyPath isEqualToString:@"hidden"] && ![[change valueForKey:NSKeyValueChangeNewKey] boolValue])
		{
		[loadingIndicator startAnimating];
		}
	}

- (BOOL)canBecomeFirstResponder
	{
	return NO;
	}

- (void)dealloc
	{
	[overlayView release];
	[loadingIndicator release];
	[super dealloc];
	}

@end

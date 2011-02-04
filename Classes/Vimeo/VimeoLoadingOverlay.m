//
//  VimeoLoadingOverlay.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 04.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoLoadingOverlay.h"


@implementation VimeoLoadingOverlay

@synthesize overlayView;
@synthesize loadingIndicator;

- (id)initWithFrame:(CGRect)frame
	{
	if ((self = [super initWithFrame:frame]))
		{
		[self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];

		overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		overlayView.center = self.center;
		overlayView.layer.backgroundColor = [[UIColor blackColor] CGColor];
		overlayView.layer.cornerRadius = 10;
		overlayView.layer.opacity = 0.75f;
		
		loadingIndicator  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		loadingIndicator.frame = CGRectMake(0, 0, 30, 30);
		loadingIndicator.center = overlayView.center;
		loadingIndicator.hidesWhenStopped = YES;
		[loadingIndicator startAnimating];
		
		[self addSubview:overlayView];
		[self addSubview:loadingIndicator];
		}
	return self;
	}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
	{
	if([keyPath isEqualToString:@"hidden"] && [change valueForKey:NSKeyValueChangeNewKey])
		{
		[loadingIndicator stopAnimating];  
		}
	else if ([keyPath isEqualToString:@"hidden"] && ![change valueForKey:NSKeyValueChangeNewKey])
		{
		[loadingIndicator startAnimating];
		}
	
//	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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

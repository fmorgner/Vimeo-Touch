//
//  VimeoVideo.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface VimeoVideo : NSObject <UIWebViewDelegate>
	{
	NSUInteger ID;
	NSString* title;
	BOOL HD;
	
	@private
	UIWebView* loadingWebView;
	NSTimer* urlFetchTimer;
	}

- (id)initWithXMLElement:(CXMLElement*)aElement;
- (void)loadMobileVideoURL;
- (void)generateURL:(NSTimer*)theTimer;

@property(nonatomic,assign) NSUInteger ID;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,assign,getter = isHD) BOOL HD; 
@end

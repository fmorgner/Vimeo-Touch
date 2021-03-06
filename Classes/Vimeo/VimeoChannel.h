//
//  VimeoChannel.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"
#import "VimeoController.h"


@interface VimeoChannel : NSObject <NSCoding>
	{
	NSUInteger ID;
	BOOL featured;
	BOOL sponsored;
	
	NSString* name;
	NSString* desc;
	NSDate* createdOn;
	NSDate* modifiedOn;

	NSUInteger videoCount;
	NSUInteger subscriberCount;
	
	NSURL* logoURL;
	NSURL* badgeURL;
	NSURL* url;
	
	NSArray* videos;
	}

- (id)initWithXMLElement:(CXMLElement*)aElement;
- (void)loadVideos:(OAuthConsumer*)consumer;

@property(nonatomic,assign) NSUInteger ID, videoCount, subscriberCount;
@property(nonatomic,copy) NSString* name, *desc;
@property(nonatomic,copy) NSURL* logoURL, *badgeURL, *url;
@property(nonatomic,copy) NSDate* createdOn, *modifiedOn;
@property(nonatomic,copy) NSArray* videos;
@property(nonatomic,assign,getter = isFeatured) BOOL featured;
@property(nonatomic,assign,getter = isSponsored) BOOL sponsored;
@end

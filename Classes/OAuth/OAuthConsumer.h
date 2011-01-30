//
//  OAuthConsumer.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OAuthConsumer : NSObject
	{
	NSString* key;
	NSString* secret;
	}

- (id)initWithKey:(NSString*)theKey secret:(NSString*)theSecret;

+ (OAuthConsumer*)consumerWithKey:(NSString*)theKey secret:(NSString*)theSecret;

@property(nonatomic, retain) NSString* key;
@property(nonatomic, retain) NSString* secret;

@end

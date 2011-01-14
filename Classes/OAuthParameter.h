//
//  OAuthParameter.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OAuthParameter : NSObject
	{
	NSString* key;
	NSString* value;
	}
	
- (id)initWithKey:(NSString*)theKey andValue:(NSString*)theValue;
+ (id)parameterWithKey:(NSString*)theKey andValue:(NSString*)theValue;

- (NSString*)OAuthURLEncodedKey;
- (NSString*)OAuthURLEncodedValue;
- (NSString*)OAuthURLEncodedKeyValuePair;

@property(nonatomic, retain) NSString* key;
@property(nonatomic, retain) NSString* value;


@end

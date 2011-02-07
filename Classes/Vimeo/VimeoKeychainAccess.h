//
//  VimeoKeychainAccess.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 07.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth.h"
#import "VimeoConstants.h"
#import <Security/Security.h>

@interface VimeoKeychainAccess : NSObject
	{
	}

+ (OAuthToken*)fetchTokenForItemID:(NSData*)theItemID error:(NSError**)error;
+ (BOOL)writeToken:(OAuthToken*)token itemID:(NSData*)theItemID error:(NSError**)error;

@end

//
//  VimeoError.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 11.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

enum VimeoErrorCode
	{
  VimeoNotFoundError = 1,
  VimeoUserNotModeratorError = 2,
  VimeoNotAllowedError = 3,
  VimeoInvalidSignatureError = 96,
	VimeoMissingSignatureError = 97,
	VimeoLoginFailedError = 98,
	VimeoInvalidAPIKeyError = 100,
	VimeoServiceUnavailableError = 105,
	VimeoFormatNoFoundError  = 111,
	VimeoMethodNotFoundError = 112,
	VimeoOAuthInvalidConsumerKeyError = 301,
	VimeoOAuthInvalidTokenError = 302,
	VimeoOAuthInvalidSignatureError = 303,
	VimeoOAuthInvalidNonceError = 304,
	VimeoOAuthUnsupportedSignatureMethodError = 306,
	VimeoOAuthMissingRequiredParameterError = 307,
	VimeoOAuthDuplicateParameterError = 308,
	VimeoRateLimitExceeded = 999
	};

@interface VimeoError : NSObject
	{
	NSUInteger code;
	NSString* explanation;
	NSString* name;
	}

- (id) initWithCode:(NSUInteger)theCode explanation:(NSString*)theExplanation name:(NSString*)theName;

@property(nonatomic, readonly) NSUInteger code;
@property(nonatomic, readonly) NSString* explanation;
@property(nonatomic, readonly) NSString* name;

@end

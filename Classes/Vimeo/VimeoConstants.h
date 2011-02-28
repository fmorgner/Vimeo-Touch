//
//  VimeoConstants.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 03.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

// Vimeo keychain access error domain
static NSString* kVimeoKeychainAccessErrorDomain = @"VimeoKeychainAccessErrorDomain";

// Vimeo application access permissions
static NSString* kVimeoPermissionRead = @"read";
static NSString* kVimeoPermissionWrite = @"write";
static NSString* kVimeoPermissionDelete = @"delete";

// Vimeo API Endpoints
static NSString* kVimeoUserAuthorizationURL = @"http://vimeo.com/oauth/authorize?oauth_token=%@&permission=%@";
static NSString* kVimeoAccessTokenVerificationURL = @"http://vimeo.com/oauth/access_token";
static NSString* kVimeoAccessTokenRequestURL = @"http://vimeo.com/oauth/request_token";
static NSString* kVimeoRestURL = @"http://vimeo.com/api/rest/v2";

static NSString* kVimeoAuthorizationVerifierNotification = @"VimeoAuthorizationViewControllerDidReceiveVerifier";
static NSString* kVimeoVerifierKey = @"vimeoVerifier";

// Vimeo API methods
static NSString* kVimeoMethodOAuthCheckAccessToken = @"vimeo.oauth.checkAccessToken";
static NSString* kVimeoMethodChannelsGetAll = @"vimeo.channels.getAll";
static NSString* kVimeoMethodChannelsGetVideos = @"vimeo.channels.getVideos";

// Vimeo API response types
static NSString* kVimeoOAuthResponseType = @"oauth";
static NSString* kVimeoChannelsResponseType = @"channels";
static NSString* kVimeoVideosResponseType = @"videos";
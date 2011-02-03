//
//  VimeoConstants.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 03.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* kVimeoPermissionRead = @"read";
static NSString* kVimeoPermissionWrite = @"write";
static NSString* kVimeoPermissionDelete = @"delete";

static NSString* kVimeoUserAuthorizationURL = @"http://vimeo.com/oauth/authorize?oauth_token=%@&permission=%@";
static NSString* kVimeoAccessTokenVerificationURL = @"http://vimeo.com/oauth/access_token";
static NSString* kVimeoAccessTokenRequestURL = @"http://vimeo.com/oauth/request_token";

static NSString* kVimeoAuthorizationVerifierNotification = @"VimeoAuthorizationViewControllerDidReceiveVerifier";
static NSString* kVimeoVerifierKey = @"vimeoVerifier";

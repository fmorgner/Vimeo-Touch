//
//  VimeoAuthorizationViewControllerDelegate.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 22.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VimeoAuthorizationViewController;

@protocol VimeoAuthorizationViewControllerDelegate <NSObject>

- (void)authorizationViewController:(VimeoAuthorizationViewController*)authViewController didReceiveVerifier:(NSString*)theVerifier;

@end

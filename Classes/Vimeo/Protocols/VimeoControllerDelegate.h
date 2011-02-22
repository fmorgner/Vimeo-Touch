//
//  VimeoControllerDelegate.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 22.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VimeoController;
@class VimeoAPIResponse;

@protocol VimeoControllerDelegate <NSObject>

- (void)vimeoController:(VimeoController*)aController didFetchResponse:(VimeoAPIResponse*)theResponse;
- (void)vimeoController:(VimeoController*)aController didFailFetchingWithError:(NSError*)theError;

@end

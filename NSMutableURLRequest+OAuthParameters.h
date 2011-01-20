//
//  Parameters.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 20.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthParameter.h"

@interface NSMutableURLRequest (OAuthParameters)

- (NSArray*)parameters;
- (void)setParameters;

@end

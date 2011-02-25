//
//  Vimeo.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoController.h"

@implementation VimeoController

@synthesize consumer;
@synthesize user;

- (id)initWithConsumer:(OAuthConsumer*)aConsumer user:(VimeoUser*)aUser
	{
	if((self = [super init]))
		{
		consumer = aConsumer;
		user = aUser;
		requestFetcher = [[OAuthRequestFetcher alloc] init];
		}
	return self;
	}

- (void)callMethod:(NSString*)aMethod withParameters:(NSArray*)theParameters delegate:(id<VimeoControllerDelegate>)aDelegate sign:(BOOL)shouldSign
	{
	if(!aDelegate)
		{
		NSException* exception = [NSException exceptionWithName:@"VimeoControllerDelegateException" reason:@"The delegate must not be nil!" userInfo:nil];
		[exception raise];
		return;
		}
	if(!consumer)
		{
		NSError* error = [NSError errorWithDomain:@"VimeoControllerErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"The consumer must not be nil!" forKey:NSLocalizedDescriptionKey]];
		[aDelegate vimeoController:self didFailFetchingWithError:error];
		return;
		}
	if(shouldSign && !user)
		{
		NSError* error = [NSError errorWithDomain:@"VimeoControllerErrorDomain" code:2 userInfo:[NSDictionary dictionaryWithObject:@"The user must not be nil!" forKey:NSLocalizedDescriptionKey]];
		[aDelegate vimeoController:self didFailFetchingWithError:error];
		return;
		}
		
	OAuthParameter* methodParameter = [OAuthParameter parameterWithKey:@"method" andValue:aMethod];	
	NSURL* url = [[NSURL URLWithString:kVimeoRestURL] URLByAppendingParameter:methodParameter];
	
	if(theParameters)
		url = [url URLByAppendingParameters:theParameters];
	
	OAuthRequest* request;
	
	if(shouldSign && user)
		{
		request = [OAuthRequest requestWithURL:url consumer:consumer token:user.token realm:nil signerClass:nil];
		}
	else
		{
		request = [OAuthRequest requestWithURL:url consumer:consumer token:nil realm:nil signerClass:nil];
		}
		
	[request prepare];	

	[requestFetcher fetchRequest:request completionHandler:^(id fetchResult) {
		if([fetchResult isKindOfClass:[NSData class]])
			{
			VimeoAPIResponse* response = [VimeoAPIResponse responseWithData:fetchResult];
			[aDelegate vimeoController:self didFetchResponse:response];
			}
		else
			{
			[aDelegate vimeoController:self didFailFetchingWithError:fetchResult];
			}
	}];
	}

- (void)fetchUnauthorizedRequestToken
	{
	
	}

@end
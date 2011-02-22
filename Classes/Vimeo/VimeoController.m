//
//  Vimeo.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoController.h"

@interface VimeoController(Private)

- (BOOL)checkForNilValuesIncludingUser:(BOOL)includingUser;

@end

@implementation VimeoController

@synthesize consumer;
@synthesize user;

- (id)initWithConsumer:(OAuthConsumer*)aConsumer user:(VimeoUser*)aUser delegate:(id<VimeoControllerDelegate>)aDelegate
	{
	if((self = [super init]))
		{
		consumer = aConsumer;
		user = aUser;
		delegate = aDelegate;
		requestFetcher = [[OAuthRequestFetcher alloc] init];
		}
	return self;
	}


- (void)verifyUserToken
	{
	if([self checkForNilValuesIncludingUser:YES])
		return;
	
	NSURL* url = [NSURL URLWithString:kVimeoRestURL];
	OAuthParameter* methodParameter = [OAuthParameter parameterWithKey:@"method" andValue:kVimeoMethodOAuthCheckAccessToken];
	OAuthRequest* request = [OAuthRequest requestWithURL:[url URLByAppendingParameter:methodParameter] consumer:consumer token:user.token realm:nil signerClass:nil];
	[request prepare];
	
	[requestFetcher fetchRequest:request completionHandler:^(NSData *fetchedData) {
		VimeoAPIResponse* response = [VimeoAPIResponse responseWithData:fetchedData];
		[delegate vimeoController:self didFetchResponse:response];
	}];
	}


@end

@implementation VimeoController(Private)

- (BOOL)checkForNilValuesIncludingUser:(BOOL)includingUser
	{
	if(!delegate)
		{
		NSException* exception = [NSException exceptionWithName:@"VimeoControllerDelegateException" reason:@"The delegate must not be nil!" userInfo:nil];
		[exception raise];
		return YES;
		}
	if(!consumer)
		{
		NSError* error = [NSError errorWithDomain:@"VimeoControllerErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"The consumer must not be nil!" forKey:NSLocalizedDescriptionKey]];
		[delegate vimeoController:self didFailFetchingWithError:error];
		return YES;
		}
	if(!user && includingUser)
		{
		NSError* error = [NSError errorWithDomain:@"VimeoControllerErrorDomain" code:2 userInfo:[NSDictionary dictionaryWithObject:@"The user must not be nil!" forKey:NSLocalizedDescriptionKey]];
		[delegate vimeoController:self didFailFetchingWithError:error];
		return YES;
		}
	return NO;
	}

@end

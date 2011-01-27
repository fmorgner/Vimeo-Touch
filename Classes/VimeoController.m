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

- (OAuthRequest*)prepareRequestWithParameters:(NSArray*)theParameters
	{
	NSMutableString* parameterString = [NSMutableString string];
	
	for(OAuthParameter* parameter in theParameters)
		{
		[parameterString appendFormat:@"%@", [parameter concatenatedKeyValuePair]];
		}
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://vimeo.com/api/rest/v2?%@", parameterString]];
	
	OAuthRequest* request = [[OAuthRequest alloc] initWithURL:url consumer:consumer token:nil realm:nil signerClass:[OAuthSignerHMAC class]];
	[request prepare];
	return request;
	}

- (NSArray*)allChannels
	{
	NSURLResponse* receivedResponse = nil;
	NSError* error = nil;
	OAuthRequest* channelRequest = [self prepareRequestWithParameters:[NSArray arrayWithObject:[OAuthParameter parameterWithKey:@"method" andValue:kVimeoChannelMethodGetAll]]];
	NSData* receivedData = [NSURLConnection sendSynchronousRequest:channelRequest returningResponse:&receivedResponse error:&error];	
	[receivedData release];
	return nil;
	}


@end

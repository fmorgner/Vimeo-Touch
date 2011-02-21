//
//  OAuthRequestFetcher.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 21.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthRequestFetcher.h"


@implementation OAuthRequestFetcher

@synthesize request;
@synthesize connection;
@synthesize completionHandler;
@synthesize receivedData;

- (id)init
	{
	if ((self = [super init]))
		{
		receivedData = [[NSData alloc] init];
    }
    
	return self;
	}

- (void)fetchRequest:(NSURLRequest*)aRequest completionHandler:(void (^)(NSData* fetchedData))block
	{
	if(!block)
		{
		NSException* exception = [NSException exceptionWithName:@"OAuthRequestFetcherCompletionHandlerNULLException" reason:@"The completion handler must not be NULL" userInfo:nil];
		[exception raise];
		return;
		}
	if(!aRequest)
		{
		NSException* exception = [NSException exceptionWithName:@"OAuthRequestFetcherRequestNilException" reason:@"The request must not be nil" userInfo:nil];
		[exception raise];
		return;
		}
	
	completionHandler = block;
	request = aRequest;
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}

- (void)dealloc {
    [receivedData release];
		[request release];
		[connection release];
    [super dealloc];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
	{
	[receivedData appendData:data];
	}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
	{
	completionHandler(receivedData);
	}

@end

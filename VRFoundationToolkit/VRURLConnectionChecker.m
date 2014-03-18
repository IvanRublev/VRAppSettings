//
//  VRURLConnectionChecker.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 3/12/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRURLConnectionChecker.h"

NSString *const VRURLConnectionCheckerDefaultSiteToCheck = @"http://apple.com";

@interface VRURLConnectionChecker () <NSURLConnectionDataDelegate>
@property (nonatomic, copy) VRURLConnectionCheckerAccessibleBlock accessible;
@property (nonatomic, copy) VRURLConnectionCheckerFailureBlock failure;
@end

@implementation VRURLConnectionChecker

+ (void)checkURLWithRequest:(NSURLRequest *)request
                 accessible:(VRURLConnectionCheckerAccessibleBlock)accessible
                    failure:(VRURLConnectionCheckerFailureBlock)failure
{
    VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN(request, [[[NSRunLoop currentRunLoop] currentMode] isEqualToString:NSDefaultRunLoopMode]);

    VRURLConnectionChecker * checker = [VRURLConnectionChecker alloc];
    checker = [checker initWithRequest:request delegate:checker startImmediately:NO];
    checker.accessible = accessible;
    checker.failure = failure;
    [checker start];
}

+ (void)checkURLWithString:(NSString *)urlString andTimeout:(NSTimeInterval)timeout
                accessible:(VRURLConnectionCheckerAccessibleBlock)accessible
                   failure:(VRURLConnectionCheckerFailureBlock)failure
{
    VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN(urlString, [[[NSRunLoop currentRunLoop] currentMode] isEqualToString:NSDefaultRunLoopMode]);
    
    NSURL * url = [NSURL URLWithString:urlString];
    if (!url) {
        VRLOG_ERROR_ASSERT_RETURN(@"Can't create request, bad urlString: %@", urlString);
    }
    
    NSMutableURLRequest * request =
    [NSMutableURLRequest requestWithURL:url
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                        timeoutInterval:[[self class] defaultFailureTimeout]];
    request.allowsCellularAccess = YES;
    [[self class] checkURLWithRequest:request
                           accessible:accessible
                              failure:failure];
}

+ (void)checkURLWithString:(NSString *)urlString accessible:(VRURLConnectionCheckerAccessibleBlock)accessible failure:(VRURLConnectionCheckerFailureBlock)failure
{
    [[self class] checkURLWithString:urlString
                          andTimeout:[[self class] defaultFailureTimeout]
                          accessible:accessible
                             failure:failure];
}

+ (NSTimeInterval)defaultFailureTimeout
{
    return 10.0;
}

+ (void)checkDefaultSiteIsAccessible:(VRURLConnectionCheckerAccessibleBlock)accessible failure:(VRURLConnectionCheckerFailureBlock)failure
{
    [[self class] checkURLWithString:VRURLConnectionCheckerDefaultSiteToCheck
                          accessible:accessible
                             failure:failure];
}

#pragma mark -
#pragma mark NSURLConnection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [connection cancel]; //good enough; don't download any more data
    if (self.accessible) {
        self.accessible();
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.failure) {
        self.failure(error);
    }
}

@end

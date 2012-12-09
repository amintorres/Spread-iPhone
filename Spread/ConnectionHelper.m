//
//  EnhancedURLConnection.m
//  Spread
//
//  Created by Joseph Lin on 12/9/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "ConnectionHelper.h"


@interface ConnectionHelper ()
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) void (^didReceiveResponse)(NSURLResponse *response);
@property (nonatomic, strong) void (^didSendData)(float progress);
@property (nonatomic, strong) void (^didWriteData)(float progress);
@property (nonatomic, strong) void (^completion)(id data, BOOL success, NSError *error);
@end


@implementation ConnectionHelper

+ (ConnectionHelper *)sendAsynchronousRequest:(NSURLRequest *)request
                           didReceiveResponse:(void (^)(NSURLResponse *response))didReceiveResponse
                                  didSendData:(void (^)(float progress))didSendData
                                 didWriteData:(void (^)(float progress))didWriteData
                                   completion:(void (^)(id data, BOOL success, NSError *error))completion
{
    ConnectionHelper *helper = [ConnectionHelper new];
    helper.data = [NSMutableData data];
    helper.didReceiveResponse = didReceiveResponse;
    helper.didSendData = didSendData;
    helper.didWriteData = didWriteData;
    helper.completion = completion;
    helper.connection = [NSURLConnection connectionWithRequest:request delegate:helper];
    
    return helper;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    self.data.length = 0;

    if (self.didReceiveResponse) {
        self.didReceiveResponse(response);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    self.uploadProgress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    if (self.uploadProgress) {
        self.didSendData(self.uploadProgress);
    }
}

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    self.downloadProgress = (float)totalBytesWritten / expectedTotalBytes;
    if (self.didWriteData) {
        self.didWriteData(self.downloadProgress);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.completion) {
        self.completion(self.data, YES, nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@", error.localizedDescription, error.userInfo[NSURLErrorFailingURLStringErrorKey]);
    self.error = error;
    
    if (self.completion) {
        self.completion(nil, NO, error);
    }
}

@end

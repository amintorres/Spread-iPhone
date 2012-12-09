//
//  EnhancedURLConnection.h
//  Spread
//
//  Created by Joseph Lin on 12/9/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConnectionHelper : NSObject

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSError *error;
@property (nonatomic) float uploadProgress;
@property (nonatomic) float downloadProgress;

+ (ConnectionHelper *)sendAsynchronousRequest:(NSURLRequest *)request
                           didReceiveResponse:(void (^)(NSURLResponse *response))didReceiveResponse
                                  didSendData:(void (^)(float progress))didSendData
                                 didWriteData:(void (^)(float progress))didWriteData
                                   completion:(void (^)(id data, BOOL success, NSError *error))completion;

@end

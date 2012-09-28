//
//  FourImagesCell.m
//  Spread
//
//  Created by Joseph Lin on 8/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "FourImagesCell.h"
#import "Photo+Spread.h"


@implementation FourImagesCell


- (void)setPhotos:(NSArray *)thePhotos
{
    _photos = thePhotos;
    NSArray* buttons = @[self.button0, self.button1, self.button2, self.button3];
    
    for (int i = 0; i < 4; i++ )
    {
        UIButton* button = buttons[i];
        
        if ( i < [_photos count] )
        {
            Photo* photo = _photos[i];
            
            NSURL* URL = [NSURL URLWithString:photo.gridImageURLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (data)
                {
                    UIImage* image = [UIImage imageWithData:data];
                    [button setImage:image forState:UIControlStateNormal];
                    button.hidden = NO;
                }
            }];
        }
        else
        {
            button.hidden = YES;
        }
    }
}

- (void)prepareForReuse
{
    
}

@end

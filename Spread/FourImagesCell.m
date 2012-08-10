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
@synthesize button0, button1, button2, button3;
@synthesize photos;


- (void)setPhotos:(NSArray *)thePhotos
{
    photos = thePhotos;
    NSArray* buttons = [NSArray arrayWithObjects:self.button0, self.button1, self.button2, self.button3, nil];
    
    for (int i = 0; i < [photos count]; i++ )
    {
        Photo* photo = [photos objectAtIndex:i];
        UIButton* button = [buttons objectAtIndex:i];
        
        NSURL* URL = [NSURL URLWithString:photo.gridImageURLString];
        NSURLRequest* request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (data)
            {
                UIImage* image = [UIImage imageWithData:data];
                [button setImage:image forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)prepareForReuse
{
    
}

@end

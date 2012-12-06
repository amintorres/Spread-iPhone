//
//  ThumbCell.m
//  Spread
//
//  Created by Joseph Lin on 12/6/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "ThumbCell.h"
#import "UIButton+WebCache.h"


@implementation ThumbCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    
    NSURL *URL = [NSURL URLWithString:photo.gridImageURLString];
    [self.thumbButton setImageWithURL:URL forState:UIControlStateNormal placeholderImage:nil];
}

@end

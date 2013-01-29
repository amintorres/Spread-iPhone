//
//  RequestFilterViewController.h
//  Spread
//
//  Created by Joseph Lin on 1/28/13.
//  Copyright (c) 2013 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FilterType) {
    FilterTypeDate = 0,
    FilterTypeHighestPrice,
    FilterTypeLowestPrice,
};



@protocol RequestFilterViewControllerDelegate;

@interface RequestFilterViewController : UIViewController
@property (nonatomic) FilterType filterType;
@property (nonatomic, weak) id <RequestFilterViewControllerDelegate> delegate;
@end


@protocol RequestFilterViewControllerDelegate <NSObject>
- (void)dismissFilterViewController:(RequestFilterViewController *)controller;
@end
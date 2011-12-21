//
//  GridViewController.h
//  Spread
//
//  Created by Joseph Lin on 12/16/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"



@interface GridViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate>

@property (strong, nonatomic) IBOutlet AQGridView *gridView;

@end

//
//  WelcomeViewController.m
//  Spread
//
//  Created by Joseph Lin on 1/28/12.
//  Copyright (c) 2012 R/GA. All rights reserved.
//

#import "WelcomeViewController.h"
#import "User+Spread.h"

typedef enum{
    ScrollDirectionToRight = -1,
    ScrollDirectionToLeft = 1,
}ScrollDirection;



@interface WelcomeViewController ()

@property (strong, nonatomic) UIView *currentView;
@property (nonatomic, getter = isAnimating) BOOL animating;

@end


@implementation WelcomeViewController

@synthesize containerView;
@synthesize contentViews;
@synthesize welcomeLabel;
@synthesize currentView;
@synthesize animating;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentView = [self.contentViews objectAtIndex:0];
    [self.containerView addSubview:self.currentView];
    
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@.\nWe look forward to all the great moments you'll capture!", [User currentUser].name];    
}

- (void)viewDidUnload
{
    [self setWelcomeLabel:nil];
    [self setContentViews:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}

- (void)changePageInDirection:(ScrollDirection)scrollDirection
{
    if ( !self.isAnimating )
    {
        NSInteger index = [self.contentViews indexOfObject:self.currentView];
        
        if ( index == 0 && scrollDirection == ScrollDirectionToRight )
        {
            // Don't allow scroll to right on landing page
            return;
        }
        
        index = (index + scrollDirection) % [self.contentViews count];
        UIView* nextView = [self.contentViews objectAtIndex:index];
        nextView.frame = CGRectOffset(self.view.bounds, scrollDirection * 320, 0);
        [self.containerView addSubview:nextView];
                
        self.animating = YES;

        [UIView animateWithDuration:0.5 animations:^(void){
            
            self.currentView.frame = CGRectOffset(self.view.bounds, -scrollDirection * 320, 0);
            nextView.frame = self.view.bounds;
            
        } completion:^(BOOL finished){
           
            [self.currentView removeFromSuperview];
            self.currentView = nextView;
            self.animating = NO;
        }];
    }
}

- (IBAction)leftButtonTapped:(id)sender
{
    [self changePageInDirection:ScrollDirectionToRight];
}

- (IBAction)rightButtonTapped:(id)sender
{
    [self changePageInDirection:ScrollDirectionToLeft];
}



@end

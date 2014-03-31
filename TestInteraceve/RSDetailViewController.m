//
//  RSDetailViewController.m
//  TestInteraceve
//
//  Created by Robert Saunders on 23/03/2014.
//  Copyright (c) 2014 Robert Saunders. All rights reserved.
//

#import "RSDetailViewController.h"

@interface RSDetailViewController ()
- (void)configureView;
@end

@implementation RSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    id<UIViewControllerTransitionCoordinator> coordinator = self.transitionCoordinator;
//    
//    if (![coordinator isCancelled])
//    {
//        self.detailDescriptionLabel.alpha = 0.0;
//        
//        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//            
//            self.detailDescriptionLabel.alpha = 1.0;
//            
//        } completion:nil];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    id<UIViewControllerTransitionCoordinator> coordinator = self.transitionCoordinator;
//    
//    if (![coordinator isCancelled])
//    {
//        self.detailDescriptionLabel.alpha = 1.0;
//        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//            
//            self.detailDescriptionLabel.alpha = 0.0;
//            
//        } completion:nil];
//    }
}

@end





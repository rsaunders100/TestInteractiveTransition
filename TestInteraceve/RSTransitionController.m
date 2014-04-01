//
//  RSTransitionVendor.m
//  TestInteraceve
//
//  Created by Robert Saunders on 30/03/2014.
//  Copyright (c) 2014 Robert Saunders. All rights reserved.
//

#import "RSTransitionController.h"

const static NSTimeInterval RSTransitionVendorAnimationDuration = 0.7;

@interface RSTransitionController ()  <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL isInteractive;

@property (nonatomic) UINavigationControllerOperation opperation;
@property (nonatomic) UINavigationController * parentNavigationController;
@property (nonatomic) UIPercentDrivenInteractiveTransition * percentDrivenInteractiveTransition;

@end

@implementation RSTransitionController

- (id)init
{
    self = [super init];
    if (self) {
        NSAssert(NO, @"Wrong init");
    }
    return self;
}

- (id)initWithParentNavigationController:(UINavigationController *)parentNavigationController;
{
    self = [super init];
    if (self)
    {
        _parentNavigationController = parentNavigationController;
        
        UIScreenEdgePanGestureRecognizer * edgePanGR = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeBack:)];
        edgePanGR.edges = UIRectEdgeLeft;
        edgePanGR.maximumNumberOfTouches = 1;
        [_parentNavigationController.view addGestureRecognizer:edgePanGR];
        
        UIPercentDrivenInteractiveTransition * interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        
        interactiveTransition.completionCurve = UIViewAnimationCurveLinear;
        interactiveTransition.completionSpeed = 0.99;
        
        self.percentDrivenInteractiveTransition = interactiveTransition;
    }
    return self;
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (!self.isInteractive)
    {
        return nil;
    }

    return self.percentDrivenInteractiveTransition;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    self.opperation = operation;
    
    return self;
}

- (void)didSwipeBack:(UIScreenEdgePanGestureRecognizer *)edgePanGestureRecognizer
{
    if ([edgePanGestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        self.isInteractive = YES;
        [self.parentNavigationController popViewControllerAnimated:YES];
    }
    
    if (!self.isInteractive)
    {
        return;
    }
    
    switch ([edgePanGestureRecognizer state])
    {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [edgePanGestureRecognizer translationInView:edgePanGestureRecognizer.view];
            
            CGFloat distanceMovedAcross = translation.x;
            CGFloat totalViewWidth = edgePanGestureRecognizer.view.frame.size.width;
            
            CGFloat percentagePanned = distanceMovedAcross / totalViewWidth;
            if (percentagePanned < 0) percentagePanned = 0;
            
            [self.percentDrivenInteractiveTransition updateInteractiveTransition:percentagePanned];
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            CGPoint velocity = ([edgePanGestureRecognizer velocityInView:edgePanGestureRecognizer.view]);
            CGPoint translation = [edgePanGestureRecognizer translationInView:edgePanGestureRecognizer.view];
            CGFloat distanceMovedAcross = translation.x;
            CGFloat totalViewWidth = edgePanGestureRecognizer.view.frame.size.width;
            
            CGFloat projectedXPositionAfterShortTime = distanceMovedAcross + velocity.x * 0.2;
            
            if ([edgePanGestureRecognizer state] != UIGestureRecognizerStateCancelled &&
                projectedXPositionAfterShortTime >= totalViewWidth / 2)
            {
                [self.percentDrivenInteractiveTransition finishInteractiveTransition];
            }
            else
            {
                [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
            }
            
            self.isInteractive = NO;
            break;
        }
            
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return RSTransitionVendorAnimationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGRect finalToViewControllerFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect initialFromViewControllerFrame = [transitionContext initialFrameForViewController:fromViewController];
    
    CGFloat toViewStartX;
    CGFloat fromViewEndX;
    
    CGFloat width = self.parentNavigationController.view.bounds.size.width;
    
    if (self.opperation == UINavigationControllerOperationPush)
    {
        toViewStartX = width;
        fromViewEndX = -width;
    }
    else
    {
        toViewStartX = -width;
        fromViewEndX = width;
    }
    
    CGRect finalFromViewControllerFrame = CGRectMake(fromViewEndX, 0,
                                                     finalToViewControllerFrame.size.width,
                                                     finalToViewControllerFrame.size.height);
    
    CGRect initalToViewControllerFrame = CGRectMake(toViewStartX, 0,
                                                    finalToViewControllerFrame.size.width,
                                                    finalToViewControllerFrame.size.height);
    
    toViewController.view.frame = initalToViewControllerFrame;
    fromViewController.view.frame = initialFromViewControllerFrame;
    
    [UIView animateWithDuration:RSTransitionVendorAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
       
        toViewController.view.frame = finalToViewControllerFrame;
        fromViewController.view.frame = finalFromViewControllerFrame;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end






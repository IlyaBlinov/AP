//
//  IBTransitionDismissViewController.m
//  Retrowave Player
//
//  Created by Илья Блинов on 06.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBTransitionDismissViewController.h"

@implementation IBTransitionDismissViewController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    
    UIView *containerView = [transitionContext containerView];
    UIView *presentedView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    NSLog(@"containerView = %@",NSStringFromCGRect(containerView.frame));
    
    NSLog(@"presentedView = %@",NSStringFromCGRect(presentedView.frame));
   
    
    CGAffineTransform transform = presentedView.transform;
    
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:10
                        options:0
                     animations:^{
                         
                        presentedView.transform = CGAffineTransformTranslate(transform,  - presentedView.bounds.size.width,0);
                         
                     } completion:^(BOOL finished) {
                         [presentedView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                         
                     }];
    
    
    //[transitionContext completeTransition:YES];
}





@end

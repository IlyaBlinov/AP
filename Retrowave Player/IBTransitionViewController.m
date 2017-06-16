//
//  IBTransitionViewController.m
//  Retrowave Player
//
//  Created by Илья Блинов on 02.05.17.
//  Copyright © 2017 Илья Блинов. All rights reserved.
//

#import "IBTransitionViewController.h"

@implementation IBTransitionViewController





- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    
    UIView *containerView = [transitionContext containerView];
    UIView *presentedView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    NSLog(@"containerView = %@",NSStringFromCGRect(containerView.frame));
    
    NSLog(@"presentedView = %@",NSStringFromCGRect(presentedView.frame));
    
    UIViewController *vc  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    vc.modalPresentationStyle = [transitionContext presentationStyle];
    //vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if ((CGRectGetHeight(_presetedViewFrame) > CGRectGetHeight(presentedView.frame) ) || (CGRectGetHeight(_presetedViewFrame) == 0)) {
        
        presentedView.frame = CGRectMake(containerView.bounds.origin.x  , containerView.bounds.origin.y , CGRectGetWidth(containerView.bounds)  ,
                                         CGRectGetHeight(containerView.bounds) / 4);
        
        self.presetedViewFrame = presentedView.frame;
    }else{
        
        presentedView.frame = containerView.bounds;
        self.presetedViewFrame = presentedView.frame;
        
    }
    
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
//    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    blurEffectView.frame = containerView.bounds;
//    [containerView addSubview:blurEffectView];
    
    
    
    [containerView addSubview:presentedView];
    
    CGAffineTransform transform = presentedView.transform;
    presentedView.transform = CGAffineTransformTranslate(transform,  -containerView.bounds.size.width,0);
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:10
                        options:0
                     animations:^{
                         presentedView.transform = transform;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
    
    //[transitionContext completeTransition:YES];
}








@end

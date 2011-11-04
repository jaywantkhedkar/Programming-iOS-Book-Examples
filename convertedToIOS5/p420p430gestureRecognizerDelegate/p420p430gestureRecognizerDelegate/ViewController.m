
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

// the user must perform a tap-and-a-half (tap and hold) to “get the view’s attention,” which we will indicate by a pulsing animation on the view; then (and only then) the user can drag the view

@implementation ViewController

{
    CGPoint origC;
}

@synthesize v, longPresser;


- (void)viewDidLoad
{

    UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(panning:)];
    UILongPressGestureRecognizer* lp = [[UILongPressGestureRecognizer alloc] 
                                        initWithTarget:self
                                        action:@selector(longPress:)];
    lp.numberOfTapsRequired = 1;
    [v addGestureRecognizer:p];
    [v addGestureRecognizer:lp];
    self.longPresser = lp;
    p.delegate = self;


}

- (void) longPress: (UILongPressGestureRecognizer*) lp {
    if (lp.state == UIGestureRecognizerStateBegan) {
        CABasicAnimation* anim = 
        [CABasicAnimation animationWithKeyPath: @"transform"];
        anim.toValue = 
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        anim.fromValue = 
        [NSValue valueWithCATransform3D:CATransform3DIdentity];
        anim.repeatCount = HUGE_VALF;
        anim.autoreverses = YES;
        [lp.view.layer addAnimation:anim forKey:nil];
    }
    if (lp.state == UIGestureRecognizerStateEnded) {
        [lp.view.layer removeAllAnimations];
    }
}

- (void) panning: (UIPanGestureRecognizer*) p {
    UIView* vv = p.view;
    if (p.state == UIGestureRecognizerStateBegan)
        self->origC = vv.center;
    CGPoint delta = [p translationInView: v.superview];
    CGPoint c = self->origC;
    c.x += delta.x; c.y += delta.y;
    vv.center = c;
}

- (BOOL) gestureRecognizerShouldBegin: (UIGestureRecognizer*) g {
    if (self.longPresser.state == UIGestureRecognizerStatePossible || 
        self.longPresser.state == UIGestureRecognizerStateFailed)
        return NO;
    return YES;
}

- (BOOL)gestureRecognizer: (UIGestureRecognizer*) g1 
shouldRecognizeSimultaneouslyWithGestureRecognizer: (UIGestureRecognizer*) g2 {
    return YES;
}



@end

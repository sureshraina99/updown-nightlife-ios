//
//  ViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "ViewController.h"
#import "TutorialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "UIView+Animation.h"
#import "EasyDev.h"


@interface ViewController ()

@end

@implementation ViewController

static int curveValues[] = {
    UIViewAnimationOptionCurveEaseInOut,
    UIViewAnimationOptionCurveEaseIn,
    UIViewAnimationOptionCurveEaseOut,
    UIViewAnimationOptionCurveLinear };

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    curvesList = [[NSMutableArray alloc] initWithObjects:@"EaseInOut",@"EaseIn",@"EaseOut",@"Linear", nil];
    selectedCurveIndex = 0;
    
    self.logoImageView.hidden = YES;
    self.btnUpdown.titleLabel.textColor = [UIColor clearColor];
    self.lblNightLife.textColor = [UIColor clearColor];
    [self rotateLogo];
    [self performSelector:@selector(showAndMoveLogoToUdownButton) withObject:nil afterDelay:1];
}

-(void) showAndMoveLogoToUdownButton
{
    self.logoImageView.hidden = NO;
    [self performSelector:@selector(moveLogoToUpDownButton:) withObject:self.btnUpdown afterDelay:0];
}

-(void) rotateLogo
{
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = 0.0f;
        animation.repeatCount = INFINITY;
        [self.logoImageView.layer addAnimation:animation forKey:@"SpinAnimation"];
}

- (IBAction) moveLogoToUpDownButton:(id)sender //mobve to here button
{
    UIButton* button= (UIButton*)sender;
    CGFloat moveToPointX = button.center.x - (self.logoImageView.frame.size.width/2);
    CGFloat moveToPointY = button.frame.origin.y - (self.logoImageView.frame.size.height + 5.0);
    [self.logoImageView moveTo:CGPointMake(moveToPointX,moveToPointY)
                duration:1.0f
                  option:curveValues[selectedCurveIndex]];	//move to above the tapped button
    
    [self performSelector:@selector(stopAnimationAndShowTitle) withObject:nil afterDelay:1.0f];
}

-(void)stopAnimationAndShowTitle
{
    [self.logoImageView.layer removeAnimationForKey:@"SpinAnimation"];
    [self performSelector:@selector(showButtonTitle) withObject:nil afterDelay:0.5f];
}

-(void) showButtonTitle
{
    [UIView transitionWithView:self.btnUpdown
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.btnUpdown.titleLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(40/255.0) blue:(82/255.0) alpha:1];
                        self.btnUpdown.userInteractionEnabled = NO;
                    }
                    completion:^(BOOL finished){
                    }];
    
    [self performSelector:@selector(showLabelTitle) withObject:nil afterDelay:0.5f];
}

-(void) showLabelTitle
{
    [UIView transitionWithView:self.btnUpdown
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.lblNightLife.textColor = [UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1];
                        self.btnUpdown.userInteractionEnabled = NO;
                    }
                    completion:^(BOOL finished){
                    }];
    
    [self performSelector:@selector(gotoAppropriateView) withObject:nil afterDelay:2.0f];
}


-(void) gotoAppropriateView
{
    //AppDelegate *appdel = [[UIApplication sharedApplication]delegate];
    //[appdel showHomeView];
    
    if([self isUserLoggedIn] == NO)
    {
        [GlobalAppDel showLoginView];
    }
    else
    {
        [GlobalAppDel showHomeView];
    }
}

-(BOOL) isUserLoggedIn
{
    NSDictionary *loggedUserData =  [EasyDev offlineObjectForKey:@"LOGIN_USER_DATA"];
    
    if([loggedUserData[@"message"] isEqualToString:@"User login successfully."] || [loggedUserData[@"message"] isEqualToString:@"Profile updated successfully"])
    {
        return YES;
    }
    
    return NO;
}


//-(void) gotoTutorialView
//{
//    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    TutorialViewController *SignUpVC = (TutorialViewController *)[mainSB instantiateViewControllerWithIdentifier:@"TutorialViewController"];
//    [self presentViewController:SignUpVC animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

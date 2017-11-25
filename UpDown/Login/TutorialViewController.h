//
//  TutorialViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController <UIScrollViewDelegate>

@property(nonatomic,weak) IBOutlet UIButton *btnSignUp;
@property(nonatomic,weak) IBOutlet UIButton *btnSignIn;
@property(nonatomic,weak) IBOutlet UIView *scrollBackView;
@property(nonatomic,weak) IBOutlet UIView *btnBackView;

@property (nonatomic,weak) IBOutlet UIScrollView *helpScrollView;
@property (nonatomic,weak) IBOutlet UIPageControl *helpPagingView;

-(IBAction)ClickButtonSignUp:(id)sender;
-(IBAction)ClickButtonSignIn:(id)sender;

@end

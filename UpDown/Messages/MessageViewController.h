//
//  MessageViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 09/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPlaceholderTextView.h"

@interface MessageViewController : UIViewController
@property(nonatomic,weak) IBOutlet LPlaceholderTextView *messageTextView;
@property(nonatomic,weak) IBOutlet UIView *viewBackContactSupport;
@property(nonatomic,weak) IBOutlet UITextField *txtUsername;
@property(nonatomic,weak) IBOutlet UITextField *txtEmailId;
@property(nonatomic,weak) IBOutlet UIButton *btnSubmit;

-(IBAction)openLeftMenu:(id)sender;

-(IBAction)btnSubmitMsgTap:(id)sender;

@end

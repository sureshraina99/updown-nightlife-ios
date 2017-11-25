//
//  ShareViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 15/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKKTagWriteView.h"

@interface ShareViewController : UIViewController <HKKTagWriteViewDelegate>

@property(nonatomic,weak) IBOutlet UIView *backViewCaption;
@property(nonatomic,weak) IBOutlet UIView *backViewTagPeople;
@property(nonatomic,weak) IBOutlet UIView *backViewAddLocation;

@property(nonatomic,weak) IBOutlet UIImageView *shareImageView;
@property(nonatomic,strong) UIImage *sharingImage;
@property(nonatomic,weak) IBOutlet UITextField *txtCaption;
@property(nonatomic,strong) NSString *mediaType;
@property(nonatomic,strong) NSData *mediaVideoData;

@property(nonatomic,strong) NSURL *compressedFileURL;
@property(nonatomic,strong) NSString *compressedFileName;

@property (nonatomic, assign) IBOutlet HKKTagWriteView *peopleTagView;
@property (nonatomic, assign) IBOutlet HKKTagWriteView *locationTagView;


-(IBAction)tapNavBack:(id)sender;
-(IBAction)tapShareFacebook:(id)sender;
-(IBAction)tapShareTwitter:(id)sender;
-(IBAction)tapShareGooglePlus:(id)sender;
-(IBAction)tapOnShareFeed:(id)sender;

@end

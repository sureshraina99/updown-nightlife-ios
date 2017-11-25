//
//  GuestListView.h
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@protocol GuestListViewDelegate
-(void)GuestListViewCloseWithSelectedGuest:(NSArray*)selectedGuests;
-(void)CloseGuestListView;
@end

@interface GuestListView : UIView <UITableViewDataSource , UITableViewDelegate,BEMCheckBoxDelegate,UITextFieldDelegate>

@property(nonatomic,weak) IBOutlet UIView *backView;
@property(nonatomic,weak) IBOutlet UITextField *txtSearch;
@property(nonatomic,weak) IBOutlet UITableView *guestTableView;
@property(nonatomic,weak) IBOutlet UIButton *btnDone;
@property(nonatomic,weak) IBOutlet UIButton *btnClose;

@property(nonatomic,strong) NSArray *GuestList;

@property(nonatomic,strong) NSMutableArray *EditableGuestList;

@property(nonatomic,strong) BEMCheckBox *SelectedGuest;

@property (nonatomic,weak)id<GuestListViewDelegate> delegate;

-(IBAction)btnDoneClick:(id)sender;
-(IBAction)btnCloseClick:(id)sender;

@end

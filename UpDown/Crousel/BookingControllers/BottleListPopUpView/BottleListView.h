//
//  GuestListView.h
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@protocol BottleListViewDelegate
-(void)BottleListViewCloseWithSelectedBottle:(NSArray*)selectedBottles;
-(void)CloseBottleListView;
@end

@interface BottleListView : UIView <UITableViewDataSource , UITableViewDelegate,BEMCheckBoxDelegate,UITextFieldDelegate>

@property(nonatomic,weak) IBOutlet UIView *backView;
@property(nonatomic,weak) IBOutlet UITextField *txtSearch;
@property(nonatomic,weak) IBOutlet UITableView *bottleTableView;
@property(nonatomic,weak) IBOutlet UIButton *btnDone;
@property(nonatomic,weak) IBOutlet UIButton *btnClose;

@property(nonatomic,strong) NSString *Club_ID;

@property(nonatomic,strong) NSArray *BottleList;

@property(nonatomic,strong) NSMutableArray *EditableBottleList;

@property(nonatomic,strong) BEMCheckBox *SelectedBottle;

@property (nonatomic,weak)id<BottleListViewDelegate> delegate;

-(IBAction)btnDoneClick:(id)sender;
-(IBAction)btnCloseClick:(id)sender;

@end

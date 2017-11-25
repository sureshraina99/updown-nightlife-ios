//
//  FeedCommentView.m
//  UpDown
//
//  Created by RANJIT MAHTO on 23/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "FeedCommentView.h"
#import "EasyDev.h"
#import "RZNewWebService.h"

@implementation FeedCommentView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
     self.keyBoardBackView.backgroundColor = [UIColor clearColor];
    [self.commentTextView becomeFirstResponder];
}

-(IBAction)tapOnCancel:(id)sender
{
    [self.commentTextView resignFirstResponder];
    [self.delegate closeFeedCommentView];
}

-(BOOL) checkValidInput
{
    if([EasyDev checkValidStringLengh:self.commentTextView.text])
    {
        return YES;
    }
    
    return NO;
}

-(IBAction)tapOnSend:(id)sender
{
    if(![self checkValidInput])
    {
        [EasyDev showAlert:@"Comment" message:@"Comment text is not valid please check your input"];
    }
    else
    {
        [self.commentTextView resignFirstResponder];
        
        [self uploadComment];
    }
}

-(void) uploadComment
{
    [EasyDev showProcessViewWithText:@"Adding Comment..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"makeCommentOnFeed.php"];
    
    NSDictionary *feedCommentDict = @{
                                      @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                      @"feed_id":self.FeedID,
                                      @"comment":self.commentTextView.text,
                                      };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedCommentDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
                                         
                                         [self.commentTextView resignFirstResponder];
                                         [self.delegate closeFeedCommentView];
                                     }
                                     else
                                     {
                                         [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
                                     }
                                 }
     serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
     }
      networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
     }];

}

@end

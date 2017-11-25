//
//  BookingPreviewViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 23/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "BookingPreviewController.h"
#import "PDFGenerator.h"

@interface BookingPreviewController ()
{
   
}
@end

@implementation BookingPreviewController

- (void)viewDidLoad
{
    self.btnConfirm.layer.cornerRadius = 20;
    self.btnConfirm.clipsToBounds = YES;
    
    NSMutableDictionary *bookingInfoDict = [[NSMutableDictionary alloc]init];
    
    [bookingInfoDict setObject:self.personalInfoArr forKey:@"personalInfos"];
    [bookingInfoDict setObject:self.bottlesInfoArr forKey:@"BottlesInfos"];
    [bookingInfoDict setObject:self.bottlesCountArr forKey:@"BottlesCount"];
    [bookingInfoDict setObject:self.guestInfoArr forKey:@"allGuestInfos"];
    [bookingInfoDict setObject:self.vipTableSelect forKey:@"vipTableInfo"];
    [bookingInfoDict setObject:self.bookingDate forKey:@"bookingDateInfo"];
    [bookingInfoDict setObject:self.clubInfoDict forKey:@"clubInfo"];
    
    NSString* fileName = [self getPDFFileName];
    
    CGSize selViewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    [PDFGenerator drawPDF:fileName inSize:selViewSize andInfoDict:bookingInfoDict];
    
    [self showPDFFile];

    [super viewDidLoad];
}

-(NSString*)getPDFFileName
{
    NSString* fileName = @"Invoice.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
    
}

-(void)showPDFFile
{
    NSString* fileName = @"Invoice.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    //UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.pdfPreviewView setScalesPageToFit:YES];
    [self.pdfPreviewView loadRequest:request];
}

-(IBAction)tapOnBtnBackToEdit:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)tapOnBtnClose:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)tapOnBtnConfirm:(id)sender
{
    
    NSString* fileName = @"Invoice.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    //UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];

    NSData *pdfData = [NSData dataWithContentsOfURL:url];
    
    [self showEmailControllerWithAttachedData:pdfData andFileName:fileName];
}

-(void) showEmailControllerWithAttachedData:(NSData*)pdfData andFileName:(NSString*)pdfFileName
{
    NSString *emailTitle = @"Reservation";
    // Email Content
    NSString *messageBody = @"Your Booking Details in attached PDF";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    [mc addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfFileName];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

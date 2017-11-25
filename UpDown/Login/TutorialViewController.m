//
//  TutorialViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "TutorialViewController.h"
#import "SignExViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"

@interface TutorialViewController ()
{
    NSArray *imageNameArray;
    NSTimer *myTimer;
    CGRect  sizeOfView;
}

@end

@implementation TutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUISetUp];
    [self setUpOnboardScreens];
    
}

-(void)customUISetUp
{
    self.btnBackView.backgroundColor = [UIColor whiteColor];
    self.btnSignUp.layer.cornerRadius = 20;
    self.btnSignUp.clipsToBounds = YES;
    self.btnSignIn.layer.cornerRadius = 0;
}

-(void)setUpOnboardScreens
{
    
    self.helpScrollView.delegate = self;
    
    float xPos = 0;
    float yPos = 0;
    
    imageNameArray = @[@"introBg1.png",@"introBg2.png",@"introBg3.png",@"introBg4.png"];
    
    CGRect helpViewFrame = self.scrollBackView.frame;
    
    long int numOfScreen = imageNameArray.count;
    self.helpPagingView.numberOfPages = numOfScreen;
    
    for(int i=0; i< numOfScreen; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, self.view.frame.size.width,self.view.frame.size.height - self.btnBackView.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        //view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //view.layer.borderWidth = 1;
        [self.helpScrollView addSubview:view];
        
        
        UIImageView *helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        NSLog(@"Help Image : %@", NSStringFromCGRect(helpImageView.frame));
        //helpImageView.backgroundColor = [UIColor cyanColor];
        helpImageView.image = [UIImage imageNamed:[imageNameArray objectAtIndex:i]];
        helpImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:helpImageView];
        
        xPos = xPos + self.view.frame.size.width;
    }
    
    self.helpScrollView.pagingEnabled = YES;
    self.helpScrollView.showsHorizontalScrollIndicator = NO;
    self.helpScrollView.showsVerticalScrollIndicator = NO;
    self.helpScrollView.bounces = NO;
    self.helpScrollView.bouncesZoom = NO;
    self.helpScrollView.contentSize =  CGSizeMake(numOfScreen * self.view.frame.size.width, helpViewFrame.size.height-20);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.helpScrollView.frame.size.width;
    int page = floor((self.helpScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.helpPagingView.currentPage = page;
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.helpScrollView.frame.size.width;
    int page = floor((self.helpScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.helpPagingView.currentPage = page;
    
    NSLog(@"__________________Current Page : %ld", self.helpPagingView.currentPage);
    //self.view.backgroundColor = [self getRandomColor];
    
    if(page == (imageNameArray.count-1))
    {
        // show done button
    }
    else
    {
        // hide done button
    }
}


-(IBAction)ClickButtonSignUp:(id)sender
{
    // goTo SignExView
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignExViewController *SignEx = (SignExViewController *)[mainSB instantiateViewControllerWithIdentifier:@"SignExViewController"];
    [self presentViewController:SignEx animated:YES completion:nil];
    
//    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    SignUpViewController *SignEx = (SignUpViewController *)[mainSB instantiateViewControllerWithIdentifier:@"SignUpViewController"];
//    [self presentViewController:SignEx animated:YES completion:nil];
}

-(IBAction)ClickButtonSignIn:(id)sender
{
    NSLog(@"SignIn From Tutorial Remain To Implement");
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignInViewController *SignEx = (SignInViewController *)[mainSB instantiateViewControllerWithIdentifier:@"SignInViewController"];
    //[self.navigationController pushViewController:SignEx animated:YES];
    [self presentViewController:SignEx animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
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

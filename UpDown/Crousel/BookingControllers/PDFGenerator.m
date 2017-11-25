//
//  PDFGenerator.m
//  UpDown
//
//  Created by RANJIT MAHTO on 23/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "PDFGenerator.h"
//#import <objc/runtime.h>

@implementation PDFGenerator

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

+(void) drawDetailText:(NSString*)textToDraw inRect:(CGRect)drawFrame withAttribute:(NSDictionary*)drawTextAttrib
{
    
//    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    style.alignment = NSTextAlignmentCenter;
//    NSDictionary *attr = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
    
    [textToDraw drawInRect:drawFrame withAttributes:drawTextAttrib];

}

+(void)drawText
{
    
    //    NSString *myString = @"My PDF Heading";
    
    //    [myString drawInRect:CGRectMake(100, 500, 200, 34)
    //                withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
    //           lineBreakMode:NSLineBreakByWordWrapping
    //               alignment:NSTextAlignmentLeft];
    

    
//    NSString* textToDraw = @"Hello World";
//    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
//    // Prepare the text using a Core Text Framesetter
//    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
//    
//    CGRect frameRect = CGRectMake(0, 0, 300, 50);
//    CGMutablePathRef framePath = CGPathCreateMutable();
//    CGPathAddRect(framePath, NULL, frameRect);
//    
//    // Get the frame that will do the rendering.
//    CFRange currentRange = CFRangeMake(0, 0);
//    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
//    CGPathRelease(framePath);
//    
//    // Get the graphics context.
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    
//    // Put the text matrix into a known state. This ensures
//    // that no old scaling factors are left in place.
//    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
//    
//    // Core Text draws from the bottom-left corner up, so flip
//    // the current transform prior to drawing.
//    CGContextTranslateCTM(currentContext, 0, 100);
//    CGContextScaleCTM(currentContext, 1.0, -1.0);
//    
//    // Draw the frame.
//    CTFrameDraw(frameRef, currentContext);
//    
//    CFRelease(frameRef);
//    CFRelease(stringRef);
//    CFRelease(framesetter);
    
}

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{
    [image drawInRect:rect];
}

+(void)drawPDF:(NSString*)fileName inSize:(CGSize)frameSize andInfoDict:(NSDictionary*)infoDict
{
    
     NSDictionary *clubDetail = infoDict[@"clubInfo"];
     NSString *getBookingDate = infoDict[@"bookingDateInfo"];
     NSArray *invitedGuests = (NSArray*)infoDict[@"allGuestInfos"];
     NSArray *selectedBottles = (NSArray*)infoDict[@"BottlesInfos"];
     NSArray *selBottleCount = (NSArray*)infoDict[@"BottlesCount"];
    
     CGFloat pageHeight =   330 + (20 * invitedGuests.count) + 50 + (20 * selectedBottles.count) + 50;
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, frameSize.width, pageHeight), nil);
    
    //Draw Logo Image
    UIImage* logo = [UIImage imageNamed:@"logo_doc.png"];
    CGFloat centerImgPoint = (frameSize.width/2 - logo.size.width/2);
    CGRect frame = CGRectMake(centerImgPoint, 20, logo.size.width, logo.size.height);
    [PDFGenerator drawImage:logo inRect:frame];

     //Draw Line
    CGFloat PX = 0;
    CGFloat PY = 20 + logo.size.height + 10;
    CGPoint from = CGPointMake(PX, PY);
    CGPoint to = CGPointMake(frameSize.width, PY);
    [PDFGenerator drawLineFromPoint:from toPoint:to];
    
    //Draw Headline Text
    NSString *headingText = @"*** RESERVATION DETAILS ***";
    
    NSDictionary *headingTextAttt =  @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    
    CGSize textSizeFrame = [self createTextSizeWithText:headingText andAttribute:headingTextAttt];
    CGFloat centerPHeadText = (frameSize.width/2 - textSizeFrame.width/2);
    CGRect textHeadframe = CGRectMake(centerPHeadText, PY+10, textSizeFrame.width, textSizeFrame.height);
    [self drawDetailText:headingText inRect:textHeadframe withAttribute:headingTextAttt];
    
    CGFloat leftMargin = 20;
    
    //Draw Venu Heading
    NSString *venueHeadingText = @"Venue : ";
    CGFloat newYPosForVenueHead = textHeadframe.origin.y + textHeadframe.size.height + 30;
    CGSize textFrame = [self createTextSizeWithText:headingText andAttribute:[self headAttribDict]];
    CGRect venueHeadingTextFrame = CGRectMake(leftMargin, newYPosForVenueHead, textFrame.width, textFrame.height);
    [self drawDetailText:venueHeadingText inRect:venueHeadingTextFrame withAttribute:[self headAttribDict]];
    
    //Draw Venu Details
   
    NSString *venueDetailsText = [NSString stringWithFormat:@"%@, %@, Ph : %@",clubDetail[@"clubName"],clubDetail[@"clubPlace"],clubDetail[@"clubPhone"]];
    CGFloat newYPosForVenueDetails = venueHeadingTextFrame.origin.y + venueHeadingTextFrame.size.height + 5;
    CGSize detailTextSize = [self createTextSizeWithText:venueDetailsText andAttribute:[self detailTextAttr]];
    CGRect venueHeadingDetailTextFrame = CGRectMake(leftMargin, newYPosForVenueDetails, detailTextSize.width, detailTextSize.height);
    [self drawDetailText:venueDetailsText inRect:venueHeadingDetailTextFrame withAttribute:[self detailTextAttr]];
    
    //Draw Booking Date Heading
    NSString *bookingHeadingText = @"Booking Date : ";
    CGFloat newYPosForBookingHead = venueHeadingDetailTextFrame.origin.y + venueHeadingDetailTextFrame.size.height + 15;
    CGSize bookingTextFrame = [self createTextSizeWithText:bookingHeadingText andAttribute:[self headAttribDict]];
    CGRect BookingHeadingTextFrame = CGRectMake(leftMargin, newYPosForBookingHead, bookingTextFrame.width, bookingTextFrame.height);
    [self drawDetailText:bookingHeadingText inRect:BookingHeadingTextFrame withAttribute:[self headAttribDict]];
    
    //Draw Booking Date Detail
    
    NSString *bookingDetailText = getBookingDate;
    CGFloat newYPosForBookingDetail = venueHeadingDetailTextFrame.origin.y + venueHeadingDetailTextFrame.size.height + 15;
    CGSize bookingDetailTextSize = [self createTextSizeWithText:bookingDetailText andAttribute:[self detailTextAttr]];
    CGRect BookingDetailTextFrame = CGRectMake(leftMargin + bookingTextFrame.width, newYPosForBookingDetail, bookingDetailTextSize.width, bookingDetailTextSize.height);
    [self drawDetailText:bookingDetailText inRect:BookingDetailTextFrame withAttribute:[self detailTextAttr]];
    
    //Draw Vip Table Heading
    
     NSString *vipHeadingText = @"VIP Table Selected : ";
    CGFloat newYPosForVipHead = BookingDetailTextFrame.origin.y + BookingDetailTextFrame.size.height + 15;
    CGSize vipHeadTextFrame = [self createTextSizeWithText:vipHeadingText andAttribute:[self headAttribDict]];
    CGRect vipHeadingTextFrame = CGRectMake(leftMargin, newYPosForVipHead, vipHeadTextFrame.width, vipHeadTextFrame.height);
    [self drawDetailText:vipHeadingText inRect:vipHeadingTextFrame withAttribute:[self headAttribDict]];
    
    //Draw Vip Table Detail
    NSString *getIsVipTableSelect = infoDict[@"vipTableInfo"];
    NSString *vipDetailText = getIsVipTableSelect;
    
    CGFloat newYPosForVipDetail = BookingDetailTextFrame.origin.y + BookingDetailTextFrame.size.height + 15;
    CGSize vipDetailTextFrame = [self createTextSizeWithText:vipDetailText andAttribute:[self detailTextAttr]];
    CGRect vipDetailsTextFrame = CGRectMake(leftMargin + vipHeadTextFrame.width , newYPosForVipDetail, vipDetailTextFrame.width, vipDetailTextFrame.height);
    [self drawDetailText:vipDetailText inRect:vipDetailsTextFrame withAttribute:[self detailTextAttr]];
    
    
    //Draw Guest Heading
    long int totalGuest  =  invitedGuests.count;
    NSString *guestHeadingText = [NSString stringWithFormat:@"Invited Total Guest : %ld",totalGuest];
    CGFloat newYPosForGuestHead = vipDetailsTextFrame.origin.y + vipDetailsTextFrame.size.height + 15;
    CGSize guestHeadTextFrame = [self createTextSizeWithText:guestHeadingText andAttribute:[self headAttribDict]];
    CGRect guestHeadingTextFrame = CGRectMake(leftMargin, newYPosForGuestHead, guestHeadTextFrame.width, guestHeadTextFrame.height);
    [self drawDetailText:guestHeadingText inRect:guestHeadingTextFrame withAttribute:[self headAttribDict]];
    
    
    //DrawGuest Table Header
    NSString *guestNameText = @"Guest Name";
    CGFloat newYPosForGuestName = guestHeadingTextFrame.origin.y + guestHeadingTextFrame.size.height + 15;
    CGSize guestNameTextSize = [self createTextSizeWithText:guestNameText andAttribute:[self headAttribDict]];
    CGRect guestNameTextFrame = CGRectMake(leftMargin, newYPosForGuestName, guestNameTextSize.width, guestNameTextSize.height);
    [self drawDetailText:guestNameText inRect:guestNameTextFrame withAttribute:[self headAttribDict]];
    
    //DrawEmail Table Header
    NSString *guestEmialText = @"Guest Email";
    CGFloat newYPosForGuestEmial = guestHeadingTextFrame.origin.y + guestHeadingTextFrame.size.height + 15;
    CGSize guestEmialTextSize = [self createTextSizeWithText:guestEmialText andAttribute:[self headAttribDict]];
    CGRect guestEmialTextFrame = CGRectMake(leftMargin + (frameSize.width/2)-20 , newYPosForGuestEmial, guestEmialTextSize.width, guestEmialTextSize.height);
    [self drawDetailText:guestEmialText inRect:guestEmialTextFrame withAttribute:[self headAttribDict]];

    // Draw Header Table Line
    CGPoint startP = CGPointMake(20, newYPosForGuestEmial + guestNameTextSize.height + 5);
    CGPoint endP = CGPointMake(frameSize.width - 20 , newYPosForGuestEmial + guestNameTextSize.height + 5);
    [PDFGenerator drawLineFromPoint:startP toPoint:endP];

    
    //Draw Guest List Guest Name And Email
    
    CGFloat newYPosForGuestList = startP.y + 5;
    
    for(int i = 0; i < invitedGuests.count; i++)
    {
        NSDictionary *dict = [invitedGuests objectAtIndex:i];
        
        //Draw User Name
        NSString *nameText = dict[@"username"];
        CGSize nameTextSize = [self createTextSizeWithText:nameText andAttribute:[self detailTextAttr]];
        CGRect nameTextFrame = CGRectMake(leftMargin, newYPosForGuestList, nameTextSize.width, nameTextSize.height);
        [self drawDetailText:nameText inRect:nameTextFrame withAttribute:[self detailTextAttr]];
        
        // Draw Emial Id
        NSString *emailText = dict[@"email"];
        CGSize emialTextSize = [self createTextSizeWithText:emailText andAttribute:[self detailTextAttr]];
        CGRect emailTextFrame = CGRectMake(leftMargin + (frameSize.width/2)-20 , newYPosForGuestList, emialTextSize.width, emialTextSize.height);
        [self drawDetailText:emailText inRect:emailTextFrame withAttribute:[self detailTextAttr]];
        
         newYPosForGuestList =  newYPosForGuestList + nameTextSize.height + 5;
    }
    
    //Draw Bottle Heading
    NSString *bottleHeadingText = @"Selected Bottle List :";
    CGFloat newYPosForBottleHead = newYPosForGuestList + 20;
    CGSize bottleHeadTextSize = [self createTextSizeWithText:bottleHeadingText andAttribute:[self headAttribDict]];
    CGRect bottleHeadingTextFrame = CGRectMake(leftMargin, newYPosForBottleHead, bottleHeadTextSize.width, bottleHeadTextSize.height);
    [self drawDetailText:bottleHeadingText inRect:bottleHeadingTextFrame withAttribute:[self headAttribDict]];
    
    
    //DrawBottle Table Header
    NSString *bottleNameText = @"Bottle Name";
    CGFloat newYPosForBottleName = bottleHeadingTextFrame.origin.y + bottleHeadingTextFrame.size.height + 15;;
    CGSize bottleNameTextSize = [self createTextSizeWithText:bottleNameText andAttribute:[self headAttribDict]];
    CGRect bottleNameTextFrame = CGRectMake(leftMargin, newYPosForBottleName, bottleNameTextSize.width, bottleNameTextSize.height);
    [self drawDetailText:bottleNameText inRect:bottleNameTextFrame withAttribute:[self headAttribDict]];
    
    //DrawBottle Quantity Table Header
    NSString *BottleCountText = @"Bottle Quantity";
    CGFloat newYPosForBottleCount =  bottleHeadingTextFrame.origin.y + bottleHeadingTextFrame.size.height + 15;
    CGSize bottleCountTextSize = [self createTextSizeWithText:BottleCountText andAttribute:[self headAttribDict]];
    CGRect bottleCountTextFrame = CGRectMake(leftMargin + (frameSize.width/2)-20 , newYPosForBottleCount, bottleCountTextSize.width, bottleCountTextSize.height);
    [self drawDetailText:BottleCountText inRect:bottleCountTextFrame withAttribute:[self headAttribDict]];
    
    // Draw Header Table Line
    CGPoint bstartP = CGPointMake(20, newYPosForBottleName + bottleNameTextSize.height + 5);
    CGPoint bendP = CGPointMake(frameSize.width - 20 , newYPosForBottleName + bottleNameTextSize.height + 5);
    [PDFGenerator drawLineFromPoint:bstartP toPoint:bendP];

    
     CGFloat newYPosForBottleList = bstartP.y + 5;
    
    for(int i = 0; i < selectedBottles.count; i++)
    {
        NSDictionary *dictBottle = [selectedBottles objectAtIndex:i];
        //NSDictionary *dictBCount = [selBottleCount objectAtIndex:i];
        
//                NSArray *keys = [dict allKeys];
//                NSString *key = [keys objectAtIndex:0];
//                NSString *value = [dict valueForKey:key];
//                 NSLog(@"%@ : %@",key,value);
        
        //Draw User Name
        NSString *bottleText = dictBottle[@"bottel_name"];
        CGSize bottleTextSize = [self createTextSizeWithText:bottleText andAttribute:[self detailTextAttr]];
        CGRect bottleTextFrame = CGRectMake(leftMargin, newYPosForBottleList, bottleTextSize.width, bottleTextSize.height);
        [self drawDetailText:bottleText inRect:bottleTextFrame withAttribute:[self detailTextAttr]];
        
        // Draw Emial Id
        NSString *countText = [NSString stringWithFormat:@"%@",[selBottleCount objectAtIndex:i]];;
        CGSize countTextSize = [self createTextSizeWithText:countText andAttribute:[self detailTextAttr]];
        CGRect countTextFrame = CGRectMake(leftMargin + (frameSize.width/2)-20 , newYPosForBottleList, countTextSize.width, countTextSize.height);
        [self drawDetailText:countText inRect:countTextFrame withAttribute:[self detailTextAttr]];
        
        newYPosForBottleList =  newYPosForBottleList + countTextSize.height + 5;
    }

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(CGSize) createTextSizeWithText:(NSString*)string andAttribute:(NSDictionary*)attribDict
{
    CGSize size = [string sizeWithAttributes:attribDict];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return adjustedSize;
}

+(NSDictionary*) headAttribDict
{
    UIColor *blue_Theme = [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1];
    
    NSDictionary *headingTextAttr =  @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName : blue_Theme};
    
    return headingTextAttr;
}

+(NSDictionary*) detailTextAttr
{
    UIColor *gray_Theme = [UIColor colorWithRed:(105/255.0) green:(105/255.0) blue:(105/255.0) alpha:1];
    
    NSDictionary *textAttr =  @{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : gray_Theme};
    
    return textAttr;
}

@end

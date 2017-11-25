//
//  PDFGenerator.h
//  UpDown
//
//  Created by RANJIT MAHTO on 23/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface PDFGenerator : NSObject

+(void)drawPDF:(NSString*)fileName inSize:(CGSize)frameSize andInfoDict:(NSDictionary*)infoDict;

@end

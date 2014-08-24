//
//  UIImage+PDFUtility.m
//  Hello World
//
//  Created by Erica Sadun on 8/14/14.
//  Copyright (c) 2014 Erica Sadun. All rights reserved.
//

#import "UIImage+PDFUtility.h"

static CGFloat AspectScaleFit(CGSize sourceSize, CGRect destRect)
{
    CGSize destSize = destRect.size;
    CGFloat scaleW = destSize.width / sourceSize.width;
    CGFloat scaleH = destSize.height / sourceSize.height;
    return fmin(scaleW, scaleH);
}

static CGRect RectAroundCenter(CGPoint center, CGSize size)
{
    CGFloat halfWidth = size.width / 2.0f;
    CGFloat halfHeight = size.height / 2.0f;
    
    return CGRectMake(center.x - halfWidth, center.y - halfHeight, size.width, size.height);
}

static CGRect RectByFittingRect(CGRect sourceRect, CGRect destinationRect)
{
    CGFloat aspect = AspectScaleFit(sourceRect.size, destinationRect);
    CGSize targetSize = CGSizeMake(sourceRect.size.width * aspect, sourceRect.size.height * aspect);
    CGPoint center = CGPointMake(CGRectGetMidX(destinationRect), CGRectGetMidY(destinationRect));
    return RectAroundCenter(center, targetSize);
}

void DrawPDFPageInRect(CGPDFPageRef pageRef, CGRect destinationRect)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        NSLog(@"Error: No context to draw to");
        return;
    }
    
    CGContextSaveGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Flip the context to Quartz space
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    transform = CGAffineTransformTranslate(transform, 0.0f, -image.size.height);
    CGContextConcatCTM(context, transform);
    
    // Flip the rect, which remains in UIKit space
    CGRect d = CGRectApplyAffineTransform(destinationRect, transform);
    
    // Calculate a rectangle to draw to
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    CGFloat drawingAspect = AspectScaleFit(pageRect.size, d);
    CGRect drawingRect = RectByFittingRect(pageRect, d);
    
    // Adjust the context
    CGContextTranslateCTM(context, drawingRect.origin.x, drawingRect.origin.y);
    CGContextScaleCTM(context, drawingAspect, drawingAspect);
    
    // Draw the page
    CGContextDrawPDFPage(context, pageRef);
    CGContextRestoreGState(context);
}

UIImage *ImageFromPDFFile(NSString *pdfPath, CGSize targetSize)
{
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:pdfPath]);
    if (pdfRef == NULL)
    {
        NSLog(@"Error loading PDF");
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0);
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(pdfRef, 1);
    DrawPDFPageInRect(pageRef, (CGRect){.size = targetSize});
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGPDFDocumentRelease(pdfRef);
    return image;
}

CGFloat GetPDFFileAspect(NSString *pdfPath)
{
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:pdfPath]);
    if (pdfRef == NULL)
    {
        NSLog(@"Error loading PDF");
        return 0.0;
    }
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(pdfRef, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    CGPDFDocumentRelease(pdfRef);
    return pageRect.size.width / pageRect.size.height;
}

UIImage *ImageFromPDFFileWithWidth(NSString *pdfPath, CGFloat targetWidth)
{
    CGFloat aspect = GetPDFFileAspect(pdfPath);
    if (aspect == 0.0) return nil;
    return ImageFromPDFFile(pdfPath, CGSizeMake(targetWidth, targetWidth / aspect));
}

UIImage *ImageFromPDFFileWithHeight(NSString *pdfPath, CGFloat targetHeight)
{
    CGFloat aspect = GetPDFFileAspect(pdfPath);
    if (aspect == 0.0) return nil;
    return ImageFromPDFFile(pdfPath, CGSizeMake(targetHeight * aspect, targetHeight));
}

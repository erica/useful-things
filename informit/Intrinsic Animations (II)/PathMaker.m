//
//  PathMaker.m
//  Hello World
//
//  Created by Erica Sadun on 5/19/14.
//  Copyright (c) 2014 Erica Sadun. All rights reserved.
//

#import "PathMaker.h"

@implementation PathMaker
+ (UIBezierPath *) carrot
{
    // Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(259.19, 149.52)];
    [bezierPath addCurveToPoint: CGPointMake(217.07, 187.24) controlPoint1: CGPointMake(242.69, 157.51) controlPoint2: CGPointMake(224.61, 170.84)];
    [bezierPath addCurveToPoint: CGPointMake(259.82, 249.48) controlPoint1: CGPointMake(209.49, 206.7) controlPoint2: CGPointMake(248.17, 244.41)];
    [bezierPath addCurveToPoint: CGPointMake(260.45, 250.74) controlPoint1: CGPointMake(260.03, 249.9) controlPoint2: CGPointMake(260.24, 250.32)];
    [bezierPath addCurveToPoint: CGPointMake(245.36, 271.48) controlPoint1: CGPointMake(255.42, 257.65) controlPoint2: CGPointMake(250.39, 264.57)];
    [bezierPath addCurveToPoint: CGPointMake(196.32, 215.53) controlPoint1: CGPointMake(229.9, 266.92) controlPoint2: CGPointMake(201.38, 231.68)];
    [bezierPath addLineToPoint: CGPointMake(195.07, 215.53)];
    [bezierPath addCurveToPoint: CGPointMake(165.52, 262.05) controlPoint1: CGPointMake(185.22, 231.04) controlPoint2: CGPointMake(175.37, 246.55)];
    [bezierPath addCurveToPoint: CGPointMake(203.87, 312.97) controlPoint1: CGPointMake(167.8, 283.13) controlPoint2: CGPointMake(187.71, 305.57)];
    [bezierPath addCurveToPoint: CGPointMake(191.3, 334.35) controlPoint1: CGPointMake(205.59, 318.77) controlPoint2: CGPointMake(194.06, 327.92)];
    [bezierPath addCurveToPoint: CGPointMake(189.41, 335.61) controlPoint1: CGPointMake(190.67, 334.77) controlPoint2: CGPointMake(190.04, 335.19)];
    [bezierPath addCurveToPoint: CGPointMake(149.18, 292.86) controlPoint1: CGPointMake(175.36, 325.96) controlPoint2: CGPointMake(155.21, 309.92)];
    [bezierPath addLineToPoint: CGPointMake(148.55, 292.86)];
    [bezierPath addCurveToPoint: CGPointMake(137.86, 314.23) controlPoint1: CGPointMake(144.98, 299.98) controlPoint2: CGPointMake(141.42, 307.11)];
    [bezierPath addCurveToPoint: CGPointMake(107.06, 395.96) controlPoint1: CGPointMake(125.23, 338.98) controlPoint2: CGPointMake(113.85, 365.31)];
    [bezierPath addCurveToPoint: CGPointMake(142.26, 443.11) controlPoint1: CGPointMake(100.88, 423.8) controlPoint2: CGPointMake(110.95, 448.98)];
    [bezierPath addCurveToPoint: CGPointMake(221.47, 404.13) controlPoint1: CGPointMake(174.92, 436.98) controlPoint2: CGPointMake(198.66, 420.28)];
    [bezierPath addCurveToPoint: CGPointMake(362.29, 265.82) controlPoint1: CGPointMake(270.13, 369.67) controlPoint2: CGPointMake(331.78, 317.3)];
    [bezierPath addCurveToPoint: CGPointMake(356, 210.5) controlPoint1: CGPointMake(373.6, 246.74) controlPoint2: CGPointMake(365.78, 225.11)];
    [bezierPath addCurveToPoint: CGPointMake(259.19, 149.52) controlPoint1: CGPointMake(338.07, 183.72) controlPoint2: CGPointMake(304.09, 148.72)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(403.78, 153.92)];
    [bezierPath addCurveToPoint: CGPointMake(442.13, 104.26) controlPoint1: CGPointMake(414.86, 139.64) controlPoint2: CGPointMake(441.59, 127.46)];
    [bezierPath addCurveToPoint: CGPointMake(376.12, 120.61) controlPoint1: CGPointMake(426.9, 97.25) controlPoint2: CGPointMake(387.61, 115.9)];
    [bezierPath addLineToPoint: CGPointMake(375.49, 120.61)];
    [bezierPath addCurveToPoint: CGPointMake(384.92, 55.23) controlPoint1: CGPointMake(377.34, 106.92) controlPoint2: CGPointMake(392.11, 69.24)];
    [bezierPath addLineToPoint: CGPointMake(384.92, 53.97)];
    [bezierPath addCurveToPoint: CGPointMake(337.77, 96.09) controlPoint1: CGPointMake(365.86, 56.06) controlPoint2: CGPointMake(350.89, 85.66)];
    [bezierPath addLineToPoint: CGPointMake(337.77, 97.35)];
    [bezierPath addCurveToPoint: CGPointMake(318.91, 40.77) controlPoint1: CGPointMake(330.58, 80.83) controlPoint2: CGPointMake(336.79, 45.67)];
    [bezierPath addCurveToPoint: CGPointMake(307.59, 137.58) controlPoint1: CGPointMake(305.11, 61.21) controlPoint2: CGPointMake(307.16, 104.2)];
    [bezierPath addCurveToPoint: CGPointMake(326.45, 148.27) controlPoint1: CGPointMake(313.88, 141.14) controlPoint2: CGPointMake(320.17, 144.7)];
    [bezierPath addCurveToPoint: CGPointMake(368.57, 187.24) controlPoint1: CGPointMake(341.56, 157.65) controlPoint2: CGPointMake(359.67, 171.74)];
    [bezierPath addCurveToPoint: CGPointMake(463.5, 162.1) controlPoint1: CGPointMake(401.95, 185.35) controlPoint2: CGPointMake(442.25, 177.62)];
    [bezierPath addLineToPoint: CGPointMake(463.5, 160.84)];
    [bezierPath addCurveToPoint: CGPointMake(403.78, 153.92) controlPoint1: CGPointMake(454.05, 148.42) controlPoint2: CGPointMake(422.69, 153.12)];
    [bezierPath closePath];
    return bezierPath;
}

+ (UIBezierPath *) checkMark
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(433.74, 82.28)];
    [bezierPath addCurveToPoint: CGPointMake(361.09, 18.88) controlPoint1: CGPointMake(384.42, 48.46) controlPoint2: CGPointMake(361.09, 18.88)];
    [bezierPath addCurveToPoint: CGPointMake(173.27, 263.12) controlPoint1: CGPointMake(270, 72.55) controlPoint2: CGPointMake(173.27, 263.12)];
    [bezierPath addCurveToPoint: CGPointMake(82.35, 181.51) controlPoint1: CGPointMake(127.93, 199.31) controlPoint2: CGPointMake(82.35, 181.51)];
    [bezierPath addCurveToPoint: CGPointMake(26.54, 245.38) controlPoint1: CGPointMake(61.86, 208.89) controlPoint2: CGPointMake(26.54, 245.38)];
    [bezierPath addCurveToPoint: CGPointMake(178.07, 348.99) controlPoint1: CGPointMake(108.92, 267.57) controlPoint2: CGPointMake(178.07, 348.99)];
    [bezierPath addCurveToPoint: CGPointMake(433.74, 82.28) controlPoint1: CGPointMake(327.56, 114.3) controlPoint2: CGPointMake(433.74, 82.28)];
    [bezierPath closePath];
    return bezierPath;
}
@end

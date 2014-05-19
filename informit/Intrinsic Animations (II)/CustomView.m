//
//  CustomView.m
//  Hello World
//
//  Created by Erica Sadun on 5/19/14.
//  Copyright (c) 2014 Erica Sadun. All rights reserved.
//

#import "CustomView.h"
#import "CustomLayer.h"

@implementation CustomView
+ (Class) layerClass
{
    return [CustomLayer class];
}

- (instancetype) init
{
    if (!(self = [super init])) return self;
    return self;
}
@end

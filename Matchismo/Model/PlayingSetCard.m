//
//  PlayingSetCard.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "PlayingSetCard.h"

@implementation PlayingSetCard

- (void)setShading:(NSString *)shading
{
    if ([[[self class] validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (void)setColor:(NSString *)color
{
    if ([[[self class] validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *)contents
{
    NSString *description = @"";
    for (NSInteger number = 1; number <= self.rank; number++) {
        description = [description stringByAppendingString:self.suit];
    }
    return description;
}

+ (NSArray *)validSuits
{
    return [NSArray arrayWithObjects:@"▲", @"■", @"●", nil];
}

+ (NSArray *)rankStrings
{
    return [NSArray arrayWithObjects:@"?", @"1", @"2", @"3", nil];
}

+ (NSArray *)validShadings
{
    return [NSArray arrayWithObjects:@"solid", @"striped", @"open", nil];
}

+ (NSArray *)validColors
{
    return [NSArray arrayWithObjects:@"redColor", @"greenColor", @"purpleColor", nil];
}

@end

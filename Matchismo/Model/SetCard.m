//
//  PlayingSetCard.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetCard.h"

@implementation PlayingSetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int symbolSum = [[PlayingSetCard validSuits] indexOfObject:self.suit];
    int numberSum = self.rank;
    int shadingSum = [[PlayingSetCard validShadings] indexOfObject:self.shading];
    int colorSum = [[PlayingSetCard validColors] indexOfObject:self.color];
    
    if (otherCards.count==2) {
        
        for (PlayingSetCard *otherCard in otherCards) {
            symbolSum += [[PlayingSetCard validSuits] indexOfObject:otherCard.suit];
            numberSum += otherCard.rank;
            shadingSum += [[PlayingSetCard validShadings] indexOfObject:otherCard.shading];
            colorSum += [[PlayingSetCard validColors] indexOfObject:otherCard.color];
        }
        
        if ((symbolSum%3==0)&&(numberSum%3==0)&&(shadingSum%3==0)&&(colorSum%3==0))
            score = 1;
    }
    return score;
}

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

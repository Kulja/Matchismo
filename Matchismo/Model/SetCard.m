//
//  PlayingSetCard.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int symbolSum = [[SetCard validSymbol] indexOfObject:self.symbol];
    int numberSum = self.number;
    int shadingSum = [[SetCard validShadings] indexOfObject:self.shading];
    int colorSum = [[SetCard validColors] indexOfObject:self.color];
    
    if (otherCards.count==2) {
        
        for (SetCard *otherCard in otherCards) {
            symbolSum += [[SetCard validSymbol] indexOfObject:otherCard.symbol];
            numberSum += otherCard.number;
            shadingSum += [[SetCard validShadings] indexOfObject:otherCard.shading];
            colorSum += [[SetCard validColors] indexOfObject:otherCard.color];
        }
        
        if ((symbolSum%3==0)&&(numberSum%3==0)&&(shadingSum%3==0)&&(colorSum%3==0))
            score = 1;
    }
    return score;
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbol] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d%@ (%@ & %@)", self.number, self.symbol, self.shading, self.color];
}

+ (NSUInteger)maxNumber
{
    return [SetCard numberStrings].count - 1;
}

+ (NSArray *)numberStrings
{
    return [NSArray arrayWithObjects:@"?", @"1", @"2", @"3", nil];
}

+ (NSArray *)validSymbol
{
    return [NSArray arrayWithObjects:@"diamond", @"squiggle", @"oval", nil];
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

//
//  PlayingCard.m
//  Matchismo
//
//  Created by Marko Kuljanski on 1/27/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)contents
{
    return [[[PlayingCard rankStrings] objectAtIndex:self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    return [NSArray arrayWithObjects:@"♣", @"♥", @"♦", @"♠", nil];
}

+ (NSArray *)rankStrings
{
    return [NSArray arrayWithObjects:@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", nil];
}

+ (NSUInteger)maxRank
{
    return [PlayingCard rankStrings].count - 1;
}

@end

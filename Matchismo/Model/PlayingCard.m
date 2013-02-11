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
    if ([[[self class] validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [[self class] maxRank]) {
        _rank = rank;
    }
}

- (NSString *)contents
{
    return [[[PlayingCard rankStrings] objectAtIndex:self.rank] stringByAppendingString:self.suit];
}

// all cards need to match a suit or a rank to get any points
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (PlayingCard *cardSuitCheck in otherCards) {
        if ([cardSuitCheck.suit isEqualToString:self.suit]) {
            score += 1;
        } else {
            for (PlayingCard *cardRankCheck in otherCards) {
                if (cardRankCheck.rank == self.rank) {
                    score += 4;
                } else {
                    return 0;
                }
            }
        }
    }
    
    return score;
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
    return [[self class] rankStrings].count - 1;
}

@end

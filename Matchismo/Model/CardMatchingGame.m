//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/2/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)flipResultHistory
{
    if (!_flipResultHistory) _flipResultHistory = [[NSMutableArray alloc] init];
    return _flipResultHistory;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = deck.drawRandomCard;
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            
            NSMutableArray *flippedUpCards = [[NSMutableArray alloc] init];
            
            self.score -= FLIP_COST;
            // creating description of a flipped up card
            [self.flipResultHistory addObject:[NSString stringWithFormat:@"Flipped up %@", card.contents]];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [flippedUpCards addObject:otherCard];
                    // continue if number of face up cards (not including self) is equal to numberOfMatchesRequired
                    if ([flippedUpCards count] == self.numberOfMatchesRequired) {
                        int matchScore = [card match:flippedUpCards];
                        if (matchScore) {
                            card.unplayable = YES;
                            for (Card *flippedUpCard in flippedUpCards) {
                                flippedUpCard.unplayable = YES;
                            }
                            self.score += matchScore * MATCH_BONUS;
                            // removing last Flipped up card from our flips history
                            [self.flipResultHistory removeLastObject];
                            // creating description of a match
                            [self.flipResultHistory addObject:[NSString stringWithFormat:@"Matched %@ & %@ for %d points!", card, [flippedUpCards componentsJoinedByString:@" & "], matchScore * MATCH_BONUS]];
                        } else {
                            for (Card *flippedUpCard in flippedUpCards) {
                                flippedUpCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            // creating description of a mismatch
                            [self.flipResultHistory removeLastObject];
                            // creating description of a mismatch
                            [self.flipResultHistory addObject:[NSString stringWithFormat:@"%@ & %@ don't match! -%d points!", card, [flippedUpCards componentsJoinedByString:@" & "], MISMATCH_PENALTY]];
                        }
                        break;
                    }
                }
            }
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end

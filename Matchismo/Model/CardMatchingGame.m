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
@property (readwrite, strong, nonatomic) NSMutableArray *flipResultHistory;
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
            [flippedUpCards addObject:card];
            
            self.score -= FLIP_COST;
            // creating description of a flipped up card
            [self.flipResultHistory addObject:[NSArray arrayWithObject:card]];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [flippedUpCards addObject:otherCard];
                    // continue if number of face up cards is equal to numberOfCardsToMatch
                    if ([flippedUpCards count] == self.numberOfCardsToMatch) {
                        int matchScore = [card match:flippedUpCards];
                        if (matchScore) {
                            for (Card *flippedUpCard in flippedUpCards) {
                                flippedUpCard.unplayable = YES;
                            }
                            self.score += matchScore * MATCH_BONUS;
                            // removing last Flipped up card from our flips history
                            [self.flipResultHistory removeLastObject];
                            // creating description of a match
                            [self.flipResultHistory addObject:[NSArray arrayWithObjects:flippedUpCards, @(matchScore * MATCH_BONUS), nil]];
                        } else {
                            for (Card *flippedUpCard in flippedUpCards) {
                                flippedUpCard.faceUp = NO;
                            }
                            self.score -= MISMATCH_PENALTY;
                            // removing last Flipped up card from our flips history
                            [self.flipResultHistory removeLastObject];
                            // creating description of a mismatch
                            [self.flipResultHistory addObject:[NSArray arrayWithObjects:flippedUpCards, @(-MISMATCH_PENALTY), nil]];
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

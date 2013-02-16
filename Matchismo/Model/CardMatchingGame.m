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
@property (readwrite, strong, nonatomic) NSMutableArray *cards; // of Card
@property (readwrite, strong, nonatomic) NSMutableArray *flipResultHistory;
@property (strong, nonatomic) Deck *deck;
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
        self.deck = deck;
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

- (NSArray *)getIndexPathsForInsertedCards:(NSUInteger)numberOfCards
{
    NSMutableArray *arrayOfIndexPathsOfDeletedCards = [NSMutableArray array];
    for (int i = 0; i < numberOfCards; i++) {
        Card *card = self.deck.drawRandomCard;
        if (card) {
            [arrayOfIndexPathsOfDeletedCards addObject:[NSIndexPath indexPathForItem:[self.cards count] inSection:0]];
            [self.cards addObject:card];
        } else {
            break;
        }
    }
    
    return arrayOfIndexPathsOfDeletedCards;
}

- (NSArray *)getIndexPathsForDeletedCards:(NSArray *)cards
{
    NSMutableArray *arrayOfIndexPathsOfDeletedCards = [NSMutableArray array];
    for (Card *card in cards) {
        [arrayOfIndexPathsOfDeletedCards addObject:[NSIndexPath indexPathForItem:[self.cards indexOfObject:card] inSection:0]];
    }
    [self.cards removeObjectsInArray:cards];

    return arrayOfIndexPathsOfDeletedCards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            
            NSMutableArray *flippedUpCards = [[NSMutableArray alloc] init];
            [flippedUpCards addObject:card];
            
            self.score -= self.flipCost;
            // creating description of a flipped up card
            [self.flipResultHistory addObject:[NSMutableArray arrayWithObject:flippedUpCards]];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [flippedUpCards addObject:otherCard];
                    // continue if number of face up cards is equal to numberOfCardsToMatch
                    if ([flippedUpCards count] == self.numberOfCardsToMatch) {
                        // removing card from flippedUpCards so that it won't be evaluated with self
                        [flippedUpCards removeObjectAtIndex:0];
                        int matchScore = [card match:flippedUpCards];
                        // putting card back in flippedUpCards
                        [flippedUpCards insertObject:card atIndex:0];
                        if (matchScore) {
                            for (Card *flippedUpCard in flippedUpCards) {
                                flippedUpCard.unplayable = YES;
                            }
                            self.score += matchScore * self.matchBonus;
                            // creating description of a match by adding score 
                            [[self.flipResultHistory lastObject] addObject:@(matchScore * self.matchBonus)];
                        } else {
                            for (Card *flippedUpCard in flippedUpCards) {
                                flippedUpCard.faceUp = NO;
                            }
                            self.score -= self.mismatchPenalty;
                            // creating description of a mismatch by adding score
                            [[self.flipResultHistory lastObject] addObject:@(-self.mismatchPenalty)];
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

//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Marko Kuljanski on 1/27/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck; // abstract
@property (nonatomic) NSUInteger startingCardCound; // abstract
@property (nonatomic) NSUInteger numberOfCardsToMatch; // abstract
@property (nonatomic) NSUInteger matchBonus; // abstract
@property (nonatomic) NSUInteger mismatchPenalty; // abstract
@property (nonatomic) NSUInteger flipCost; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; // abstract

- (void)updateLastFlipStatusView:(UIView *)view usingLastFlipResult:(NSArray *)flipResult andInfoLabel:(UILabel *)infoLabel; // abstract
@property (nonatomic) NSUInteger numberOfCardsToGetOnHitMeClick; // abstract

- (void)deleteCards:(NSArray *)cards;
@end

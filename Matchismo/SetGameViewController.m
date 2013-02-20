//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)startingCardCound
{
    return 12;
}

- (NSUInteger)numberOfCardsToMatch
{
    return 3;
}

- (NSUInteger) matchBonus
{
    return 16;
}

- (NSUInteger)mismatchPenalty
{
    return 2;
}

- (NSUInteger)flipCost
{
    return 0;
}

- (NSUInteger)numberOfCardsToGetOnHitMeClick
{
    return 3;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            setCardView.faceUp = setCard.isFaceUp;
            setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (void)updateLastFlipStatusView:(UIView *)view usingLastFlipResult:(NSArray *)flipResult andInfoLabel:(UILabel *)infoLabel
{
    CGFloat xOffset = 0;
    
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
    
    for (Card *card in [flipResult objectAtIndex:0]) {
        if ([card isKindOfClass:[SetCard class]]) {
            SetCardView *setCardView = [[SetCardView alloc] initWithFrame:CGRectMake(xOffset, 0, 50, view.bounds.size.height)];
            setCardView.opaque = NO;
            [setCardView setBackgroundColor:[UIColor clearColor]];
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            [view addSubview:setCardView];
            xOffset += setCardView.bounds.size.width + 10;
        }
    }
    
    if ([flipResult count] == 1) {
        if ([[flipResult objectAtIndex:0] count] == 0) {
            infoLabel.text = @" ";
        } else {
            infoLabel.text = @"Flipped up";
        }
    } else if ([flipResult count] == 2){
        if ([[flipResult objectAtIndex:1] doubleValue] > 0) {
            infoLabel.text = [NSString stringWithFormat:@"Matched! (%i points)", [[flipResult objectAtIndex:1] intValue]];
            // delete cards
            [super deleteCards:[flipResult objectAtIndex:0]];
        } else {
            infoLabel.text = [NSString stringWithFormat:@"No match! (%i points)", [[flipResult objectAtIndex:1] intValue]];
        }
    } else {
        infoLabel.text = @" ";
    }
}

@end

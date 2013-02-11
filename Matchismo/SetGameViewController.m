//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetGameViewController.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[super.cardButtons count]
                                                  usingDeck:[[PlayingSetCardDeck alloc] init]];
        self.game.numberOfCardsToMatch = 3;
        self.game.matchBonus = 16;
        self.game.mismatchPenalty = 2;
        self.game.flipCost = 0;
    }
    return _game;
}

- (NSAttributedString *)getAttributedstringForACard:(PlayingSetCard *)playingSetCard
{
    NSDictionary *cardAttributes = @{};
    if ([playingSetCard.shading isEqualToString:@"open"]) {
        cardAttributes = @{ NSForegroundColorAttributeName : [UIColor clearColor],
                            NSStrokeWidthAttributeName : @-10,
                            NSStrokeColorAttributeName : [UIColor valueForKey:playingSetCard.color] };
    } else if ([playingSetCard.shading isEqualToString:@"striped"]) {
        cardAttributes = @{ NSForegroundColorAttributeName : [[UIColor valueForKey:playingSetCard.color] colorWithAlphaComponent:0.3],
                            NSStrokeWidthAttributeName : @-10,
                            NSStrokeColorAttributeName : [UIColor valueForKey:playingSetCard.color]};
    } else if ([playingSetCard.shading isEqualToString:@"solid"]) {
        cardAttributes = @{ NSForegroundColorAttributeName : [UIColor valueForKey:playingSetCard.color] };
    }
    return [[NSAttributedString alloc] initWithString:playingSetCard.contents attributes:cardAttributes];
}

- (void)reportMatchMismatchOrFlippedUpCard:(NSArray *)history
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@" "];

    for (PlayingSetCard *playingSetCard in [history objectAtIndex:0]) {
        [mutableAttributedString appendAttributedString:[self getAttributedstringForACard:playingSetCard]];
        [mutableAttributedString appendAttributedString:space];
    }
    
    if ([history count] == 1) {
        [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"selected!"]];
    } else if ([history count] == 2){
        if ([[history objectAtIndex:1] doubleValue] > 0) {
            [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"match! (%i points)", [[history objectAtIndex:1] intValue]]]];
        } else {
            [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" don't match (%i points)", [[history objectAtIndex:1] intValue]]]];
        }
    } else {
        self.infoLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@""];
    }
    
    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, mutableAttributedString.length)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, mutableAttributedString.length)];
    self.infoLabel.attributedText = mutableAttributedString;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        PlayingSetCard *card = (PlayingSetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        cardButton.selected = card.faceUp;
        cardButton.backgroundColor = (card.faceUp ? [UIColor lightGrayColor] : [UIColor whiteColor]);
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        [cardButton setAttributedTitle:[self getAttributedstringForACard:card] forState:UIControlStateNormal];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self reportMatchMismatchOrFlippedUpCard:[self.game.flipResultHistory lastObject]];
}

@end

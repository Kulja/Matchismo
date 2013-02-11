//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marko Kuljanski on 1/27/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        self.game.numberOfCardsToMatch = 2;
        self.game.matchBonus = 4;
        self.game.mismatchPenalty = 2;
        self.game.flipCost = 1;
    }
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for (UIButton *cardButton in self.cardButtons) {
        [cardButton setImage:[UIImage new] forState:UIControlStateSelected];
        [cardButton setImage:[UIImage new] forState:UIControlStateSelected|UIControlStateDisabled];
    }
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)reportMatchMismatchOrFlippedUpCard:(NSArray *)history
{
    if ([history count] == 1) {
        self.infoLabel.text = [NSString stringWithFormat:@"Flipped up %@", [[history lastObject] lastObject]];
    } else if ([history count] > 1){
        if ([[history objectAtIndex:1] doubleValue] > 0) {
            self.infoLabel.text = [NSString stringWithFormat:@"Matched %@ for %i points", [[history objectAtIndex:0] componentsJoinedByString:@" & "], [[history objectAtIndex:1] intValue]];
        } else {
            self.infoLabel.text = [NSString stringWithFormat:@"%@ don't match (%i points)", [[history objectAtIndex:0] componentsJoinedByString:@" & "], [[history objectAtIndex:1] intValue]];
        }
    } else {
        self.infoLabel.text = @"";
    }
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.faceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self reportMatchMismatchOrFlippedUpCard:[self.game.flipResultHistory lastObject]];
    self.infoLabel.alpha = 1.0;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    
    self.historySlider.maximumValue = [self.game.flipResultHistory count];
    self.historySlider.value = [self.game.flipResultHistory count];
    
    [self updateUI];
}

- (IBAction)startNewGame:(UIButton *)sender
{
    self.flipCount = 0;
    self.historySlider.maximumValue = 1;
    self.game = nil;
    
    [self updateUI];
}

- (IBAction)showHistoryResults:(UISlider *)sender
{
    // shows history result by flooring value of slider to represent index in flipResultHistory
    if (self.historySlider.maximumValue >= 2) {
        [self reportMatchMismatchOrFlippedUpCard:[self.game.flipResultHistory objectAtIndex:ceil(sender.value) - 1]];
        self.infoLabel.alpha = 0.3;
    }
}

- (void)viewDidUnload {
    [self setCardButtons:nil];
    [self setFlipsLabel:nil];
    [self setScoreLabel:nil];
    [self setInfoLabel:nil];
    [self setHistorySlider:nil];
    [super viewDidUnload];
}
@end

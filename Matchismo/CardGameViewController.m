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
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameChangerSC;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for (UIButton *cardButton in self.cardButtons) {
        [cardButton setBackgroundImage:[UIImage imageNamed:@"orangeCard.png"] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage new] forState:UIControlStateSelected];
        [cardButton setBackgroundImage:[UIImage new] forState:UIControlStateSelected|UIControlStateDisabled];
    }
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)setGameChangerSC:(UISegmentedControl *)gameChangerSC
{
    _gameChangerSC = gameChangerSC;
    // setting game to 2-card match game by default
    self.game.numberOfMatchesRequired = self.gameChangerSC.selectedSegmentIndex + 1;
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
    self.infoLabel.text = [self.game.flipResultHistory lastObject];
    self.infoLabel.alpha = 1.0;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.gameChangerSC.hidden = YES;
    self.historySlider.hidden = NO;
    self.historySlider.maximumValue = [self.game.flipResultHistory count];
    self.historySlider.value = [self.game.flipResultHistory count];
    
    [self updateUI];
}

- (IBAction)startNewGame:(UIButton *)sender
{
    self.flipCount = 0;
    self.game = nil;
    self.gameChangerSC.hidden = NO;
    self.historySlider.hidden = YES;
    
    [self updateUI];
}
- (IBAction)cardGameSelector:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) self.game.numberOfMatchesRequired = 1;
    else if (sender.selectedSegmentIndex == 1) self.game.numberOfMatchesRequired = 2;
}
- (IBAction)showHistoryResults:(UISlider *)sender
{
    // shows history result by flooring value of slider to represent index in flipResultHistory
    self.infoLabel.text = [self.game.flipResultHistory objectAtIndex:floor(sender.value) - 1];
    self.infoLabel.alpha = 0.3;
}

- (void)viewDidUnload {
    [self setCardButtons:nil];
    [self setFlipsLabel:nil];
    [self setScoreLabel:nil];
    [self setInfoLabel:nil];
    [self setGameChangerSC:nil];
    [self setHistorySlider:nil];
    [super viewDidUnload];
}
@end

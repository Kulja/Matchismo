//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Marko Kuljanski on 1/27/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@end

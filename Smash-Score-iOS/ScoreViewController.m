//
//  ViewController.m
//  Smash-Score-iOS
//
//  Created by Lukas Carvajal on 7/7/15.
//  Copyright (c) 2015 Lukas Carvajal. All rights reserved.
//

#import "ScoreViewController.h"
#import <Parse/Parse.h>

@interface ScoreViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *winnerImage;

// First place text fields.
@property (strong, nonatomic) IBOutlet UITextField *firstNameTF;
@property (strong, nonatomic) IBOutlet UITextField *firstScoreTF;
@property (strong, nonatomic) IBOutlet UITextField *firstFirstTF;
@property (strong, nonatomic) IBOutlet UITextField *firstSecondTF;
@property (strong, nonatomic) IBOutlet UITextField *firstThirdTF;

// Second place text fields.
@property (strong, nonatomic) IBOutlet UITextField *secondNameTF;
@property (strong, nonatomic) IBOutlet UITextField *secondScoreTF;
@property (strong, nonatomic) IBOutlet UITextField *secondFirstTF;
@property (strong, nonatomic) IBOutlet UITextField *secondSecondTF;
@property (strong, nonatomic) IBOutlet UITextField *secondThirdTF;

// Third place text fields.
@property (strong, nonatomic) IBOutlet UITextField *thirdNameTF;
@property (strong, nonatomic) IBOutlet UITextField *thirdScoreTF;
@property (strong, nonatomic) IBOutlet UITextField *thirdFirstTF;
@property (strong, nonatomic) IBOutlet UITextField *thirdSecondTF;
@property (strong, nonatomic) IBOutlet UITextField *thirdThirdTF;

// Alex 1st, 2nd, 3rd place buttons.
- (IBAction)alex1Button:(id)sender;
- (IBAction)alex2Button:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *alex1B;
@property (strong, nonatomic) IBOutlet UIButton *alex2B;

// Jonah 1st, 2nd, 3rd place buttons.
- (IBAction)jonah1Button:(id)sender;
- (IBAction)jonah2Button:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *jonah1B;
@property (strong, nonatomic) IBOutlet UIButton *jonah2B;

// Lukas 1st, 2nd, 3rd place buttons.
- (IBAction)lukas1Button:(id)sender;
- (IBAction)lukas2Button:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *lukas1B;
@property (strong, nonatomic) IBOutlet UIButton *lukas2B;

// Set players.
@property PFObject* alex;
@property PFObject* jonah;
@property PFObject* lukas;

// Set places.
@property PFObject* first;
@property PFObject* second;
@property PFObject* third;

// Check if places exist.
@property BOOL alexIsFirst;
@property BOOL jonahIsFirst;
@property BOOL lukasIsFirst;
@property BOOL alexIsSecond;
@property BOOL jonahIsSecond;
@property BOOL lukasIsSecond;

// Recall last scoring, save score.
- (IBAction)saveScoreButton:(id)sender;


@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self resetAll];
    [self loadPlayers];
    [self loadPlaces];
    [self setTextFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadPlayers {
    
    // Pull player objects from Parse.
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query addAscendingOrder:@"name"];
    
    NSArray *objects = [[NSArray alloc] initWithArray:[query findObjects]];
    if ([objects count] > 0) {
        
        self.alex = objects[0];
        self.jonah = objects[1];
        self.lukas = objects[2];

    } else {
        // Notify no players have been loaded.
        NSLog(@"Error");
    }
}

- (void) loadPlaces {
    
    // Pull player objects from Parse.
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query addDescendingOrder:@"score"];
    
    NSArray *objects = [[NSArray alloc] initWithArray:[query findObjects]];
    if ([objects count] > 0) {
        
        self.first = objects[0];
        self.second = objects[1];
        self.third = objects[2];
        
    } else {
        // Notify no players have been loaded.
        NSLog(@"Error");
    }
}

- (void) setTextFields {
    
    // Set winner image
    [self setWinnerImage];
        
    // Set player info on screen.
    self.firstNameTF.text = [self.first objectForKey:@"name"];
    self.firstScoreTF.text = [NSString stringWithFormat:@"%d", [self calculateScore:self.first]];
    self.firstFirstTF.text = [NSString stringWithFormat:@"%@", [self.first objectForKey:@"firsts"]];
    self.firstSecondTF.text = [NSString stringWithFormat:@"%@", [self.first objectForKey:@"seconds"]];
    self.firstThirdTF.text = [NSString stringWithFormat:@"%@", [self.first objectForKey:@"thirds"]];
        
    self.secondNameTF.text = [self.second objectForKey:@"name"];
    self.secondScoreTF.text = [NSString stringWithFormat:@"%d", [self calculateScore:self.second]];
    self.secondFirstTF.text = [NSString stringWithFormat:@"%@", [self.second objectForKey:@"firsts"]];
    self.secondSecondTF.text = [NSString stringWithFormat:@"%@", [self.second objectForKey:@"seconds"]];
    self.secondThirdTF.text = [NSString stringWithFormat:@"%@", [self.second objectForKey:@"thirds"]];
        
    self.thirdNameTF.text = [self.third objectForKey:@"name"];
    self.thirdScoreTF.text = [NSString stringWithFormat:@"%d", [self calculateScore:self.third]];
    self.thirdFirstTF.text = [NSString stringWithFormat:@"%@", [self.third objectForKey:@"firsts"]];
    self.thirdSecondTF.text = [NSString stringWithFormat:@"%@", [self.third objectForKey:@"seconds"]];
    self.thirdThirdTF.text = [NSString stringWithFormat:@"%@", [self.third objectForKey:@"thirds"]];
    
}

- (void) setWinnerImage {
    
    NSString *firstPlaceName = [[NSString alloc] initWithString:[self.first objectForKey:@"name"]];
    
    // Set background depending on who is in first or set default if there is a tie.
    if ([[self.first objectForKey:@"score"] intValue] == [[self.second objectForKey:@"score"] intValue]) {
        UIImage *image = [UIImage imageNamed:@"smash"];
        self.winnerImage.image = image;
    }
    else if ([firstPlaceName isEqualToString:@"Lukas"]) {
        UIImage *image = [UIImage imageNamed:@"bowser"];
        self.winnerImage.image = image;

    }
    else if ([firstPlaceName isEqualToString:@"Alex"]) {
        UIImage *image = [UIImage imageNamed:@"kirby"];
        self.winnerImage.image = image;

    }
    else if ([firstPlaceName isEqualToString:@"Jonah"]) {
        UIImage *image = [UIImage imageNamed:@"pikachue"];
        self.winnerImage.image = image;
    }
}

- (int) calculateScore:(PFObject*)object {
    
    // Return score based on wins.
    int firsts = [[object objectForKey:@"firsts"] intValue];
    int seconds = [[object objectForKey:@"seconds"] intValue];
    int score = (firsts * 3) + (seconds);
    
    return score;
}

#pragma mark - Button Actions

- (IBAction)alex1Button:(id)sender {
    
    // First place action
    [self pressFirstPlaceButton:@"Alex"];
    
}

- (IBAction)alex2Button:(id)sender {
    
    // Second place action.
    [self pressSecondPlaceButton:@"Alex"];
}

- (IBAction)jonah1Button:(id)sender {
    
    // First place action
    [self pressFirstPlaceButton:@"Jonah"];
}

- (IBAction)jonah2Button:(id)sender {
    
    // Second place action.
    [self pressSecondPlaceButton:@"Jonah"];
}

- (IBAction)lukas1Button:(id)sender {
    
    // First place action
    [self pressFirstPlaceButton:@"Lukas"];
}

- (IBAction)lukas2Button:(id)sender {
    
    // Second place action.
    [self pressSecondPlaceButton:@"Lukas"];
}

- (IBAction)recallScoreButton:(id)sender {
    
    // Update table.
    [self setTextFields];
}

- (IBAction)saveScoreButton:(id)sender {
    
    NSLog(@"HI!");
    
    // Update scores.
    if (self.alexIsFirst) {
        
        [self addWin:self.alex];
        
        if (self.lukasIsSecond)
            [self addSecondPlaceWin:self.lukas];
        else
            [self addThirdPlaceWin:self.lukas];
        
        if (self.jonahIsSecond)
            [self addSecondPlaceWin:self.jonah];
        else
            [self addThirdPlaceWin:self.jonah];
    }
    else if (self.jonahIsFirst) {
        
        [self addWin:self.jonah];
        
        if (self.alexIsSecond)
            [self addSecondPlaceWin:self.alex];
        else
            [self addThirdPlaceWin:self.alex];
        
        if (self.lukasIsSecond)
            [self addSecondPlaceWin:self.lukas];
        else
            [self addThirdPlaceWin:self.lukas];
    }
    else if (self.lukasIsFirst) {
        
        [self addWin:self.lukas];
        
        if (self.alexIsSecond)
            [self addSecondPlaceWin:self.alex];
        else
            [self addThirdPlaceWin:self.alex];
        
        if (self.jonahIsSecond)
            [self addSecondPlaceWin:self.jonah];
        else
            [self addThirdPlaceWin:self.jonah];
    }
    else {
        return;
    }
    
    // Save scores to parse.
    self.alex[@"score"] = [[NSNumber alloc] initWithInt:[self calculateScore:self.alex]];
    self.jonah[@"score"] = [[NSNumber alloc] initWithInt:[self calculateScore:self.jonah]];
    self.lukas[@"score"] = [[NSNumber alloc] initWithInt:[self calculateScore:self.lukas]];
    [self.alex saveInBackground];
    [self.jonah saveInBackground];
    [self.lukas saveInBackground];
    
    // Reset.
    [self resetAll];
    
    // Reload info.
    [self loadPlayers];
    [self loadPlaces];
    
    // Update table with new scores.
    [self setTextFields];
}

- (void)pressFirstPlaceButton:(NSString*) person {
    
    if ([person isEqualToString:@"Alex"]) {
        
        // Set Alex in first place.
        self.alexIsFirst = YES;
        self.alexIsSecond = NO;
        self.jonahIsFirst = NO;
        self.lukasIsFirst = NO;
        
        // Set Buttons in same row.
        self.alex1B.backgroundColor = [UIColor darkGrayColor];
        self.alex2B.backgroundColor = [UIColor whiteColor];
        
        // Unset other first place buttons.
        self.jonah1B.backgroundColor = [UIColor whiteColor];
        self.lukas1B.backgroundColor = [UIColor whiteColor];
    }
    else if ([person isEqualToString:@"Jonah"]) {
        
        // Set Jonah in first place.
        self.alexIsFirst = NO;
        self.jonahIsFirst = YES;
        self.jonahIsSecond = NO;
        self.lukasIsFirst = NO;
        
        // Set Buttons in same row.
        self.jonah1B.backgroundColor = [UIColor darkGrayColor];
        self.jonah2B.backgroundColor = [UIColor whiteColor];
        
        // Unset other first place buttons.
        self.alex1B.backgroundColor = [UIColor whiteColor];
        self.lukas1B.backgroundColor = [UIColor whiteColor];
    }
    else if ([person isEqualToString:@"Lukas"]) {
        
        // Set Lukas in first place.
        self.alexIsFirst = NO;
        self.jonahIsFirst = NO;
        self.lukasIsFirst = YES;
        self.lukasIsSecond = NO;
        
        // Set Buttons in same row.
        self.lukas1B.backgroundColor = [UIColor darkGrayColor];
        self.lukas2B.backgroundColor = [UIColor whiteColor];
        
        // Unset other first place buttons.
        self.jonah1B.backgroundColor = [UIColor whiteColor];
        self.alex1B.backgroundColor = [UIColor whiteColor];
    }
}

- (void)pressSecondPlaceButton:(NSString*) person {

    if ([person isEqualToString:@"Alex"]) {
        
        // Unset if set.
        if (self.alexIsSecond) {
            
            self.alexIsSecond = NO;
            self.alex2B.backgroundColor = [UIColor whiteColor];
            return;
        }
        
        // Set Alex in second place.
        self.alexIsFirst = NO;
        self.alexIsSecond = YES;
        
        // Set Buttons in same row.
        self.alex1B.backgroundColor = [UIColor whiteColor];
        self.alex2B.backgroundColor = [UIColor darkGrayColor];
    }
    else if ([person isEqualToString:@"Jonah"]) {
        
        // Unset if set.
        if (self.jonahIsSecond) {
            
            self.jonahIsSecond = NO;
            self.jonah2B.backgroundColor = [UIColor whiteColor];
            return;
        }
        
        // Set Jonah in second place.
        self.jonahIsFirst = NO;
        self.jonahIsSecond = YES;
        
        // Set Buttons in same row.
        self.jonah1B.backgroundColor = [UIColor whiteColor];
        self.jonah2B.backgroundColor = [UIColor darkGrayColor];
    }
    else if ([person isEqualToString:@"Lukas"]) {
        
        // Unset if set.
        if (self.lukasIsSecond) {
            
            self.lukasIsSecond = NO;
            self.lukas2B.backgroundColor = [UIColor whiteColor];
            return;
        }
        
        // Set Lukas in second place.
        self.lukasIsFirst = NO;
        self.lukasIsSecond = YES;
        
        // Set Buttons in same row.
        self.lukas1B.backgroundColor = [UIColor whiteColor];
        self.lukas2B.backgroundColor = [UIColor darkGrayColor];
    }
}

- (void) resetAll {
    
    self.alexIsFirst = NO;
    self.jonahIsFirst = NO;
    self.lukasIsFirst = NO;
    self.alexIsSecond = NO;
    self.jonahIsSecond = NO;
    self.lukasIsSecond = NO;
    
    self.alex1B.backgroundColor = [UIColor whiteColor];
    self.alex2B.backgroundColor = [UIColor whiteColor];
    self.lukas1B.backgroundColor = [UIColor whiteColor];
    self.lukas2B.backgroundColor = [UIColor whiteColor];
    self.jonah1B.backgroundColor = [UIColor whiteColor];
    self.jonah2B.backgroundColor = [UIColor whiteColor];
}

- (void) addWin: (PFObject*)player {
    
    // Add win to player.
    int firsts = [[player objectForKey:@"firsts"] intValue];
    firsts = firsts + 1;
    player[@"firsts"] = [[NSNumber alloc] initWithInt:firsts];
}

- (void) addSecondPlaceWin: (PFObject*)player {
    
    // Add second place win to player.
    int seconds = [[player objectForKey:@"seconds"] intValue];
    seconds = seconds + 1;
    player[@"seconds"] = [[NSNumber alloc] initWithInt:seconds];
}

- (void) addThirdPlaceWin: (PFObject*)player {
    
    // Add third place win to player.
    int thirds = [[player objectForKey:@"thirds"] intValue];
    thirds = thirds + 1;
    player[@"thirds"] = [[NSNumber alloc] initWithInt:thirds];
}

- (BOOL) checkForSecondPlace {
    
    // Return true if
    if (self.alexIsSecond)
        return true;
    else if (self.jonahIsSecond)
        return true;
    else if (self.lukasIsSecond)
        return true;
    else
        return false;
}

@end

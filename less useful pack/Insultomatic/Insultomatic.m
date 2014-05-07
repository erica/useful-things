//
//  Insultomatic.m
//  cocoabot
//
//  Created by Erica Sadun on 5/1/14.
//  Copyright (c) 2014 Erica Sadun. All rights reserved.
//

// Courtesy of http://www.pangloss.com/seidel/shake_rule.html

#import "Insultomatic.h"

@implementation Insultomatic
NSUInteger RandomInteger(NSUInteger max)
{
    return arc4random_uniform((unsigned int) max);
}

id RandomItemInArray(NSArray *array)
{
    SeedRandom();
    NSUInteger index = RandomInteger(array.count);
    return array[index];
}

NSString *insult()
{
    NSArray *words = @[@"artless", @"base-court", @"apple-john",
                       @"bawdy", @"bat-fowling", @"baggage",
                       @"beslubbering", @"beef-witted", @"barnacle",
                       @"bootless", @"beetle-headed", @"bladder",
                       @"churlish", @"boil-brained", @"boar-pig",
                       @"cockered", @"clapper-clawed", @"bugbear",
                       @"clouted", @"clay-brained", @"bum-bailey",
                       @"craven", @"common-kissing", @"canker-blossom",
                       @"currish", @"crook-pated", @"clack-dish",
                       @"dankish", @"dismal-dreaming", @"clotpole",
                       @"dissembling", @"dizzy-eyed", @"coxcomb",
                       @"droning", @"doghearted", @"codpiece",
                       @"errant", @"dread-bolted", @"death-token",
                       @"fawning", @"earth-vexing", @"dewberry",
                       @"fobbing", @"elf-skinned", @"flap-dragon",
                       @"froward", @"fat-kidneyed", @"flax-wench",
                       @"frothy", @"fen-sucked", @"flirt-gill",
                       @"gleeking", @"flap-mouthed", @"foot-licker",
                       @"goatish", @"fly-bitten", @"fustilarian",
                       @"gorbellied", @"folly-fallen", @"giglet",
                       @"impertinent", @"fool-born", @"gudgeon",
                       @"infectious", @"full-gorged", @"haggard",
                       @"jarring", @"guts-griping", @"harpy",
                       @"loggerheaded", @"half-faced", @"hedge-pig",
                       @"lumpish", @"hasty-witted", @"horn-beast",
                       @"mammering", @"hedge-born", @"hugger-mugger",
                       @"mangled", @"hell-hated", @"joithead",
                       @"mewling", @"idle-headed", @"lewdster",
                       @"paunchy", @"ill-breeding", @"lout",
                       @"pribbling", @"ill-nurtured", @"maggot-pie",
                       @"puking", @"knotty-pated", @"malt-worm",
                       @"puny", @"milk-livered", @"mammet",
                       @"qualling", @"motley-minded", @"measle",
                       @"rank", @"onion-eyed", @"minnow",
                       @"reeky", @"plume-plucked", @"miscreant",
                       @"roguish", @"pottle-deep", @"moldwarp",
                       @"ruttish", @"pox-marked", @"mumble-news",
                       @"saucy", @"reeling-ripe", @"nut-hook",
                       @"spleeny", @"rough-hewn", @"pigeon-egg",
                       @"spongy", @"rude-growing", @"pignut",
                       @"surly", @"rump-fed", @"puttock",
                       @"tottering", @"shard-borne", @"pumpion",
                       @"unmuzzled", @"sheep-biting", @"ratsbane",
                       @"vain", @"spur-galled", @"scut",
                       @"venomed", @"swag-bellied", @"skainsmate",
                       @"villainous", @"tardy-gaited", @"strumpet",
                       @"warped", @"tickle-brained", @"varlot",
                       @"wayward", @"toad-spotted", @"vassal",
                       @"weedy", @"unchin-snouted", @"whey-face",
                       @"yeasty", @"weather-bitten", @"wagtail",
                       @"cullionly", @"whoreson", @"knave",
                       @"fusty", @"malmsey-nosed", @"blind-worm",
                       @"caluminous", @"rampallian", @"popinjay",
                       @"wimpled", @"lily-livered", @"scullian",
                       @"burly-boned", @"scurvy-valiant", @"jolt-head",
                       @"misbegotten", @"brazen-faced", @"malcontent",
                       @"odiferous", @"unwash'd", @"devil-monk",
                       @"poisonous", @"bunch-back'd", @"toad",
                       @"fishified", @"leaden-footed", @"rascal",
                       @"Wart-necked", @"muddy-mettled", @"Basket-Cockle",];
    
    NSMutableArray *w1 = @[].mutableCopy;
    NSMutableArray *w2 = @[].mutableCopy;
    NSMutableArray *w3 = @[].mutableCopy;
    
    int j = 0;
    for (int i = 0; i < words.count / 3; i++)
    {
        [w1 addObject:words[j++]];
        [w2 addObject:words[j++]];
        [w3 addObject:words[j++]];
    }
    
    NSString *word1 = RandomItemInArray(w1);
    NSString *word2 = RandomItemInArray(w2);
    NSString *word3 = RandomItemInArray(w3);
    return [NSString stringWithFormat:@"Thou %@ %@ %@", word1, word2, word3];
}

+ (NSString *) insult
{
    return insult();
}
@end

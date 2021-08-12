//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

enum Student {
    case thomas, miro, shane, james
    
    var name: String {
        switch self {
        case .thomas:
            return "Thomas Kauran"
        case .miro:
            return "Miroslav Petkovic"
        case .shane:
            return "Shane Rogers"
        case .james:
            return "James Coutie"
        }
    }
    
    var number: String {
        switch self {
        case .thomas:
            return "s3305113"
        case .miro:
            return "s3666906"
        case .shane:
            return "s3292697"
        case .james:
            return "s3760330"
        }
    }
    
    var imageName: String {
        switch self {
        case .thomas:
            return "thomas"
        case .miro:
            return "miro"
        case .shane:
            return "shane"
        case .james:
            return "james"
        }
    }
    
    var desc: String {
        switch self {
        case .thomas:
            return "Nobody has ever seen Thomas in real life. You may think that is him in the photo above, but in reality, it is cleverly crafted computer simulation. Some say that Thomas is really the pseudonym of a group of stealth network analysts, dedicated to ridding the world of phones with non-user-replaceable batteries, and games you have to buy and pay a monthly fee too. Whoever he/she/they are, their autolayout skills are working over time making this the best app out there."
        case .miro:
            return "Do you think Neil Armstrong was the first man on the Moon? Well you’re wrong! Miro beat him there by two decades! Founding his own space agency out of just the items he found hidden away in his parents attic, Miro was the first person ever to land on the Sun. However, Miro wanted a change of pace and sold his company to Elon Musk who ended up renaming it. Miro now passes his time in retirement crawling the web for little-known APIs to make his apps the most powerful software you have ever seen."
        case .shane:
            return "Secret Agent 002, Shane can often be found in all corners of the globe, solving the worlds greatest crimes and defusing bombs with only 1 second left on the clock. Living the millionaire high-life, Shane spends his free time flying his private jet from the island to island, helping set up wifi networks for the locals, and bringing them reliable, high speed internet. He now brings his skill to app development, ensuring the best possible network connection for our data sources."
        case .james:
            return "Born in the wilds of Indianapolic, James took over the streets as the best hip hop dancer the world has ever seen. His dancing skills helped form the peace treaty between the West Side Elms and the East Side Oaks, putting an end to the centuries long war that had taken the lives of thousands of young, promising dancers. He now brings those skills into the world of iOS apps where his enums are a force to be reckoned with."
        }
    }
}

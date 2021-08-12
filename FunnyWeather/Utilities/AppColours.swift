//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Colour names
    static var sysPurpleFeint:UIColor  { return #colorLiteral(red: 0.8824167212, green: 0.8511641205, blue: 0.9686274529, alpha: 1) }
    static var sysPurpleLight:UIColor  { return #colorLiteral(red: 0.7217932361, green: 0.6593029712, blue: 0.9686274529, alpha: 1) }
    static var sysPurpleMedium:UIColor { return #colorLiteral(red: 0.6173561362, green: 0.4300078785, blue: 0.9686274529, alpha: 1) }
    static var sysPurpleDark:UIColor   { return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) }
    
    static var sysBlueFeint:UIColor    { return #colorLiteral(red: 0.7624064115, green: 0.9397056148, blue: 0.9764705896, alpha: 1) }
    static var sysBlueLight:UIColor    { return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) }
    static var sysBlueMedium:UIColor   { return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) }
    static var sysBlueDark:UIColor     { return #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) }
    
    static var sysGreenFeint:UIColor   { return #colorLiteral(red: 0.8199148937, green: 0.9421120801, blue: 0.7872819207, alpha: 1) }
    static var sysGreenLight:UIColor   { return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) }
    static var sysGreenMedium:UIColor  { return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) }
    static var sysGreenDark:UIColor    { return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) }
    
    static var sysYellowFeint:UIColor  { return #colorLiteral(red: 0.9764705896, green: 0.9410816181, blue: 0.7312759818, alpha: 1) }
    static var sysYellowLight:UIColor  { return #colorLiteral(red: 0.9764705896, green: 0.9333361755, blue: 0.4400272969, alpha: 1) }
    static var sysYellowMedium:UIColor { return #colorLiteral(red: 0.9607843161, green: 0.8962465596, blue: 0.1142379015, alpha: 1) }
    static var sysYellowDark:UIColor   { return #colorLiteral(red: 0.9796954315, green: 0.8254419128, blue: 0, alpha: 1) }
    
    static var sysOrangeFeint:UIColor  { return #colorLiteral(red: 0.9254901961, green: 0.7975098649, blue: 0.7447033185, alpha: 1) }
    static var sysOrangeLight:UIColor  { return #colorLiteral(red: 0.9254901961, green: 0.6321000837, blue: 0.553479431, alpha: 1) }
    static var sysOrangeMedium:UIColor { return #colorLiteral(red: 0.9254901961, green: 0.431372549, blue: 0.2980392157, alpha: 1) }
    static var sysOrangeDark:UIColor   { return #colorLiteral(red: 0.9001094854, green: 0.300501742, blue: 0, alpha: 1) }
    
    static var sysRedFeint:UIColor     { return #colorLiteral(red: 0.9098039269, green: 0.6911361089, blue: 0.73402521, alpha: 1) }
    static var sysRedLight:UIColor     { return #colorLiteral(red: 0.9098039269, green: 0.4638216098, blue: 0.4638216098, alpha: 1) }
    static var sysRedMedium:UIColor    { return #colorLiteral(red: 0.8650542537, green: 0.2768668598, blue: 0.3336543577, alpha: 1) }
    static var sysRedDark:UIColor      { return #colorLiteral(red: 0.7875385802, green: 0, blue: 0, alpha: 1) }
    
    static var sysGrayFeint:UIColor    { return #colorLiteral(red: 0.8923531175, green: 0.8923531175, blue: 0.8923531175, alpha: 1) }
    static var sysGrayLight:UIColor    { return #colorLiteral(red: 0.7658758759, green: 0.7658758759, blue: 0.7658758759, alpha: 1) }
    static var sysGrayMedium:UIColor   { return #colorLiteral(red: 0.5358575583, green: 0.5358575583, blue: 0.5358575583, alpha: 1) }
    static var sysGrayDark:UIColor     { return #colorLiteral(red: 0.255923152, green: 0.255923152, blue: 0.255923152, alpha: 1) }
    
    // Usage names
    static var appButton:UIColor                  { return sysBlueLight    }
    static var appHighlight:UIColor               { return sysOrangeMedium }
    
    static var appNavBarTint:UIColor              { return black  }
    
    static var appPlacesBanner:UIColor            { return sysBlueLight    }
    static var appTodayBanner:UIColor             { return sysGreenLight   }
    static var appForecastBanner:UIColor          { return sysOrangeLight  }
    static var appHistoryBanner:UIColor           { return sysGrayLight    }
    
    static var appSwipeRename:UIColor             { return sysGreenMedium  }
    static var appSwipeDelete:UIColor             { return sysRedMedium    }

    static var appJokeBackground:UIColor          { return sysOrangeMedium }
    
    static var appChartLines:UIColor              { return sysGrayMedium   }
    static var appChartForecastFill:UIColor       { return sysBlueLight    }
    static var appChartForecastBackground:UIColor { return sysOrangeFeint  }
    static var appChartHistoryFill:UIColor        { return sysGrayLight    }
    static var appChartHistoryBackground:UIColor  { return sysGrayFeint    }
}

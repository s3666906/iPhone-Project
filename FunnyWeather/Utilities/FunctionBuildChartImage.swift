///
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

// This enum holds the list of possible values that can be passed in the direction parameter
enum ChartImageDirection {
    case forecast
    case history
}

struct ChartImageTemperatureRange {
    var dt:Int
    var highValueInCelsius:Double
    var lowValueInCelsius:Double
}

func buildChartImage(forIndex index:Int,
                     withSize canvasSize:CGSize,
                     withData receivedData:[ChartImageTemperatureRange],
                     currentTemp:Double,
                     direction:ChartImageDirection) -> UIImage? {

    // Make a mutatable data variable
    var data = receivedData
    if data.count == 0 { return nil }
    
    // Sort the data
    data = data.sorted(by: ( {$0.dt < $1.dt }))
    
    // Limit the data to today plus 5 days
    let limit = min(5, data.count)
    let slicedData = data[ 0 ... limit]
    data = Array(slicedData)
    
    // Not coming in pre-sorted so names use j index but data uses i index
    // Forecast Data            History Data
    // [0] Today                [0] Today
    // [1] Tomorrow             [1] Yesterday
    // [2] Tomorrow + 1 day     [2] Yesterday - 1 day
    // [3] Tomorrow + 2 days    [3] Yesterday - 2 days
    // [4] Tomorrow + 3 days    [4] Yesterday - 3 days
    
    // Constants
    let padding:CGFloat = 10
    let fontSize:CGFloat = 18
    let lineWidth:CGFloat = 3
    let highLowBarWidth:CGFloat = 15.0
    
    // Calculated values
    let sliderLineTop = padding + fontSize + padding
    let sliderLineLength = canvasSize.height - sliderLineTop - padding
    let singleSliderWidth = (canvasSize.width - padding - padding) / CGFloat(data.count)
    
    // Calculate the dayLabels
    var dayLabels:[String] = []
    
    let dayFormat = DateFormatter()
    dayFormat.dateFormat = "E"
    
    if direction == .forecast {
        dayLabels.append("Today")
    }
    for i in 1 ..< data.count {
        switch direction {
        case .forecast:
            dayLabels.append(dayFormat.string(from: Date() + Double(i * 86400)))
        case .history:
            dayLabels.append(dayFormat.string(from: Date() - Double(abs(i - (data.count)) * 86400)))
        }
    }
    if direction == .history {
        dayLabels.append("Today")
    }
    
    // Calculate the overall high and low across all days
    var maxHigh:Double = data[0].highValueInCelsius
    var minLow:Double = data[0].lowValueInCelsius
    for i in 1 ..< data.count {
        maxHigh = max(maxHigh, data[i].highValueInCelsius)
        minLow = min(minLow, data[i].lowValueInCelsius)
    }
    
    // Text formatting options
    let centeredText = NSMutableParagraphStyle()
    centeredText.alignment = .center
    let attrs:[NSAttributedString.Key : Any] = [
        .paragraphStyle: centeredText,
        .font: UIFont.systemFont(ofSize:fontSize)]
    
    // Setup the drawing canvas
    let canvas = UIGraphicsImageRenderer(size: canvasSize)
    
    // Draw the sliders
    let img = canvas.image { ctx in
        
        switch direction {
        case .forecast:
            ctx.cgContext.setFillColor(UIColor.appChartForecastBackground.cgColor)
        case .history:
            ctx.cgContext.setFillColor(UIColor.appChartHistoryBackground.cgColor)
        }
        ctx.cgContext.setStrokeColor(UIColor.appChartLines.cgColor)
        ctx.cgContext.setLineWidth(lineWidth)
        
        // Draw background
        let rectangle = CGRect(x: 0,
                               y: 0,
                               width: canvasSize.width,
                               height: canvasSize.height)
        ctx.cgContext.fill(rectangle)
        
        // Write the day labels
        for i in 0 ..< data.count {
            let thisDayName = dayLabels[i]
            let attributedString = NSAttributedString(string: thisDayName, attributes: attrs)

            let rectX:CGFloat = padding + (CGFloat(i) * singleSliderWidth)
            let rectY:CGFloat = 30
            let rectWidth:CGFloat = singleSliderWidth
            let rectHeight:CGFloat = fontSize
            let rect = CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight)
                
            attributedString.draw(with: rect,
                                  options: .truncatesLastVisibleLine,
                                  context: nil)
        }
        
        // Draw slider lines
        for i in 0 ..< data.count {
            let x = padding + (CGFloat(i) * singleSliderWidth) + (singleSliderWidth / 2)
            ctx.cgContext.move(to: CGPoint(x: x, y: sliderLineTop))
            ctx.cgContext.addLine(to: CGPoint(x: x, y: sliderLineTop + sliderLineLength))
        }
        ctx.cgContext.strokePath()
        
        // Configure the HighLow Bars
        let maximumHigh:CGFloat = CGFloat(maxHigh)
        let minimumLow:CGFloat = CGFloat(minLow)
        let span:CGFloat = canvasSize.height - fontSize - (padding * CGFloat(6))
        let range:CGFloat = maximumHigh - minimumLow
        let units:CGFloat = span / range
        
        // Draw the HighLow Bars
        // for forecast we want to show the bars [0]  [1]  [2]  [3]  [4]  [5]
        // for history we want to show the bars  [5]  [4]  [3]  [2]  [1]  [0]
        for i in 0 ..< data.count {
            
            var j = i
            if direction == .history {
                // j is effectively the reversed index order of i
                j = abs(i - (data.count - 1))
            }
            
            let high:CGFloat = CGFloat(data[j].highValueInCelsius)
            let low:CGFloat = CGFloat(data[j].lowValueInCelsius)
            let highLowBarHeight:CGFloat = (high - low) * units
            let x:CGFloat = padding + ((CGFloat(i) + CGFloat(0.5)) * singleSliderWidth) - (highLowBarWidth / 2)
            let y:CGFloat = sliderLineTop + padding + (maximumHigh - high) * units
            let rectangle = CGRect(x: x,
                                   y: y,
                                   width: highLowBarWidth,
                                   height: highLowBarHeight)
            
            // Determine this HighLow Bar's fill colour
            if j == 0 {
                ctx.cgContext.setFillColor(UIColor.appHighlight.cgColor)
            } else {
                switch direction {
                case .forecast:
                    ctx.cgContext.setFillColor(UIColor.appChartForecastFill.cgColor)
                case .history:
                    ctx.cgContext.setFillColor(UIColor.appChartHistoryFill.cgColor)
                }
            }
            // Draw this HighLow Bar
            ctx.cgContext.fill(rectangle)
            ctx.cgContext.stroke(rectangle)
        }
        
        // Draw the current temp marker
        var offset = 0
        switch direction {
        case .forecast:
            offset = 0
        case .history:
            offset = 5
        }
        let x = padding + (CGFloat(offset) * singleSliderWidth) + (singleSliderWidth / 2) - highLowBarWidth
        let y = sliderLineTop + padding + (maximumHigh - CGFloat(currentTemp)) * units
        ctx.cgContext.move(to: CGPoint(x: x, y: y))
        ctx.cgContext.addLine(to: CGPoint(x: x + (2 * highLowBarWidth), y: y))
        
        ctx.cgContext.strokePath()

    }
    return img
}

//
//  ATLrcModel.swift
//  MusicPlayer-Swift
//
//  Created by 洪龙通 on 2017/2/3.
//  Copyright © 2017年 蓝海天网科技. All rights reserved.
//

import UIKit

class ATLrcModel: NSObject {
    
    var timeArray: Array<String>!
    var lrcDictionary: Dictionary<String, String>!
    
    open class func lrcDataWithString(contentStr: String) -> ATLrcModel {
    
        let lrcData = ATLrcModel()

        
        var timeArray = Array<String>()
        var lrcDictionary = Dictionary<String, String>()
        let contentsArray = contentStr.components(separatedBy: "\n")
        
        for i in 0..<contentsArray.count {
            let separateArray = contentsArray[i].components(separatedBy: "]")
            if separateArray.count >= 2 {
                for j in 0..<separateArray.count-1 {
                    if separateArray[j].characters.count < 5 || (separateArray.last?.characters.count)! < 5{
                        continue
                    }
                    let string = separateArray[j]
                    let timeStr = string.substring(with: string.index(string.startIndex, offsetBy: 1)..<string.index(string.startIndex, offsetBy: 6))
                    timeArray.append(timeStr)
                    lrcDictionary[timeStr] = separateArray.last
                    
                }
            }
        }
        
        timeArray.sort()

        lrcData.timeArray = timeArray;
        lrcData.lrcDictionary = lrcDictionary;
        return lrcData;
    }

}

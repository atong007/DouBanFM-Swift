//
//  ATSongInfo.swift
//  MusicPlayer-Swift
//
//  Created by 洪龙通 on 2017/1/23.
//  Copyright © 2017年 蓝海天网科技. All rights reserved.
//

import UIKit

class ATSongInfo: NSObject {
    var title: String!
    var artist: String!
    var length: NSNumber!
    var lyric: String!
    var picture: String!
    var like : Bool!
    var url : String!
    var sid : String!
    var lrcContentStr: String!
    
    static let sharedInstance = ATSongInfo.init()
    private override init(){}
    
    func setSongInfo(with dict: [String : Any]){

        ATSongInfo.sharedInstance.setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}

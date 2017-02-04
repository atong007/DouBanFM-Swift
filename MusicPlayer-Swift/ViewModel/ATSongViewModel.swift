//
//  SongViewModel.swift
//  MusicPlayer-Swift
//
//  Created by 洪龙通 on 2017/1/24.
//  Copyright © 2017年 蓝海天网科技. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import ReactiveSwift
import Alamofire

let kPlaylistURLString = "http://douban.fm/j/mine/playlist?type=%@&sid=%d&pt=%f&channel=%d&from=mainsite"
let kLoadLrcURLString = "http://geci.me/api/lyric/%@/%@"

class ATSongViewModel: NSObject {
        
    var loadSongSignal: SignalProducer<String, NoError> {
        get {
            // 1.通过信号发生器创建（冷信号）
            let producer = SignalProducer<String, NoError>.init { (observer, _) in
//                print("新的订阅，启动操作")
                
                let urlString = String(format: kPlaylistURLString, "n", 0, 0, 0)
                
                Alamofire.request(urlString).responseJSON { response in
//                    print(response.request)  // original URL request
//                    print(response.response) // HTTP URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        let dict: Dictionary = JSON as! [String : Any]
                        let result = dict["song"] as! [Any]
                        ATSongInfo.sharedInstance.setSongInfo(with: result[0] as! [String : Any])

                        observer.send(value: ATSongInfo.sharedInstance.picture)
                    }
                }
                
                
            }
            return producer
            
//            // 2.通过管道创建（热信号）
//            let (signalA, observerA) = Signal<String, NoError>.pipe()
//            let (signalB, observerB) = Signal<String, NoError>.pipe()
//            Signal.combineLatest(signalA, signalB).observeValues { (value) in
//                print("收到的值\(value.0) + \(value.1)")
//            }
//            observerA.send(value: "1")
//            observerA.sendCompleted()
//            observerB.send(value: "2")
//            observerB.sendCompleted()
        }
    }
    
    var loadLrcSignal: SignalProducer<String, NoError> {
        get {
            
            // 1.通过信号发生器创建（冷信号）
            let producer = SignalProducer<String, NoError>.init { (observer, _) in
                
                let lrcURLString = String(format: kLoadLrcURLString, ATSongInfo.sharedInstance.title, ATSongInfo.sharedInstance.artist).addingPercentEscapes(using: String.Encoding.utf8)
                
                Alamofire.request(lrcURLString!).responseJSON { response in
                    
                    if let JSON = response.result.value {
                        let dict = JSON as! [String : Any]
                        let result = dict["result"] as! [Dictionary<String, Any>]
                        if result.count > 0 {
                            let firstLrcResult = result[0]
                            let lrcURLString: String = firstLrcResult["lrc"] as! String
                            let contentData: Data?
                            try! contentData = Data(contentsOf: URL(string: lrcURLString)!)
                            let contentStr = String(data: contentData!, encoding: String.Encoding.utf8)
                            ATSongInfo.sharedInstance.lrcContentStr = contentStr
                            observer.send(value: "歌词获取成功！")

                        }
                    }
                }
                
                
            }
            return producer
        }
    }
    
}

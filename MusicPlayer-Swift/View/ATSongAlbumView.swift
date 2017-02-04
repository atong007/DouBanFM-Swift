//
//  ATSongAlbumView.swift
//  MusicPlayer-Swift
//
//  Created by 洪龙通 on 2017/1/23.
//  Copyright © 2017年 蓝海天网科技. All rights reserved.
//

import UIKit

class ATSongAlbumView: UIImageView {
    
    /**
     *  磁盘专辑封面开始旋转
     */
    open func startRotating() -> Void {
        self.layer.removeAnimation(forKey: "rotation")
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.toValue = M_PI * 2
        animation.duration = 10.0
        animation.repeatCount = MAXFLOAT
        
        self.layer.add(animation, forKey:"rotation")
    }
    
    /**
     *  磁盘专辑封面暂停旋转
     */
    open func stoptRotating() -> Void {
        
        let pauseTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.layer.speed = 0.0
        self.layer.timeOffset = pauseTime
    }
    
    /**
     *  磁盘专辑封面恢复旋转
     */
    open func resumeRotating() -> Void {
        
        let pauseTime = self.layer.timeOffset;
        self.layer.speed = 1.0;
        self.layer.timeOffset = 0.0;
        self.layer.beginTime = 0.0;
        let sinceTimeFromPause = self.layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        self.layer.beginTime = sinceTimeFromPause;
    }
}

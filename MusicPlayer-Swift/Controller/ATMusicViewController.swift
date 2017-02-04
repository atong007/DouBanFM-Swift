//
//  ATMusicViewController.swift
//  MusicPlayer-Swift
//
//  Created by 洪龙通 on 2017/1/22.
//  Copyright © 2017年 蓝海天网科技. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift
import Result
import MediaPlayer
import AVKit


let kHeightForBottomToolView:CGFloat = 80
let producer: SignalProducer<String, NoError> = ATSongViewModel().loadSongSignal
let lrcProducer: SignalProducer<String, NoError> = ATSongViewModel().loadLrcSignal
let kMainColor: UIColor = UIColor.init(red: 199/255.0, green: 46/255.0, blue: 42/255.0, alpha: 1.0)
var count: Int = 0

class ATMusicViewController: UIViewController {
    
    weak var needle: UIImageView?
    weak var songInfoLabel: UILabel?
    weak var albumImageView: UIImageView?
    weak var backgroundImageView: UIImageView?
    weak var remainTimeLabel: UILabel?
    weak var songProgress: UIProgressView?
    weak var lrcView: ATLrcView!
    var avPlayer: AVPlayer!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSubviews()
        
        self.loadSongInfo()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    
    func setupSubviews() -> Void {
        
        // 背景颜色
        view.backgroundColor = UIColor.white
        
        // 背景图
        let backgroundImageView = UIImageView.init(frame: view.bounds)
        self.backgroundImageView = backgroundImageView
        backgroundImageView.image = UIImage.init(named: "login")
        view.addSubview(backgroundImageView)
        // 为背景图添加磨砂效果
        let effect = UIBlurEffect.init(style: UIBlurEffectStyle.light)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.alpha = 1.0
        effectView.frame = backgroundImageView.frame
        backgroundImageView.addSubview(effectView)
        
        // 顶部歌曲信息栏
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 80))
        topView.backgroundColor = kMainColor
        view.addSubview(topView)
        let songInfoLabel = UILabel()
        songInfoLabel.textAlignment = NSTextAlignment.center
        songInfoLabel.numberOfLines = 2
        songInfoLabel.textColor = UIColor.white
        songInfoLabel.font = UIFont.systemFont(ofSize: 13.0)
        self.songInfoLabel = songInfoLabel
        songInfoLabel.backgroundColor = topView.backgroundColor
        topView.addSubview(songInfoLabel)
        songInfoLabel.snp.makeConstraints { (make) in
            make.width.equalTo(topView.frame.size.width/2)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        // 唱针
        let needleImageView = UIImageView()
        needle = needleImageView
        view.insertSubview(needleImageView, belowSubview: topView)
        needleImageView.image = UIImage.init(named: "play_needle_play")
        needleImageView.snp.makeConstraints { (make) in
            make.size.equalTo((needleImageView.image?.size)!)
            make.centerX.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(-90)
        }
        
        
        // 唱片背景光圈
        let musicDiskBackView = UIImageView()
        musicDiskBackView.image = UIImage.init(named: "disk_mask")
        view.insertSubview(musicDiskBackView, belowSubview: needleImageView)
        musicDiskBackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().offset(-70)
            make.width.equalTo(musicDiskBackView.snp.height)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
        
        // 唱片磁盘
        let musicDiskImageView = UIImageView()
        musicDiskImageView.image = UIImage.init(named: "cm2_play_disc")
        musicDiskBackView.addSubview(musicDiskImageView)
        musicDiskImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(musicDiskImageView.snp.height)
            make.center.equalToSuperview()
        }
        // 唱片图片
        let albumImageView = ATSongAlbumView()
        albumImageView.contentMode = UIViewContentMode.scaleAspectFill;
        albumImageView.startRotating()
        self.albumImageView = albumImageView
        musicDiskBackView.addSubview(albumImageView)
        albumImageView.layer.cornerRadius = 66
        albumImageView.clipsToBounds = true
        albumImageView.image = UIImage.init(named: "defaultCover")
        albumImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(133)
            make.center.equalToSuperview()
        }
        
        // 歌曲时间
        let remainTimeLabel = UILabel()
        self.view.addSubview(remainTimeLabel)
        self.remainTimeLabel = remainTimeLabel
        remainTimeLabel.textColor = UIColor.red
        remainTimeLabel.font = UIFont.systemFont(ofSize: 13)
        remainTimeLabel.textAlignment = NSTextAlignment.center
        remainTimeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(musicDiskBackView.snp.bottom).offset(10)
        }

        // 歌词
        let lrcView = ATLrcView()
        self.view.addSubview(lrcView)
        self.lrcView = lrcView
        lrcView.snp.makeConstraints { (make) in
            make.height.equalTo(120)
            make.leftMargin.equalTo(20)
            make.rightMargin.equalTo(-20)
            make.top.equalTo(remainTimeLabel.snp.bottom).offset(5)
        }
        
        // 底部播放工具栏
        let bottomToolView = UIView.init(frame: CGRect.init(x: 0, y: view.frame.size.height - kHeightForBottomToolView, width: view.frame.size.width, height: kHeightForBottomToolView))
        bottomToolView.backgroundColor = UIColor.init(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 0.6)
        view.addSubview(bottomToolView)
        
        let buttonW: CGFloat = bottomToolView.frame.size.width / 3
        let buttonH: CGFloat = bottomToolView.frame.size.height
        let likeButton = UIButton()
        likeButton.setImage(UIImage.init(named: "cm2_play_icn_love"), for: UIControlState.normal)
        bottomToolView.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.width.equalTo(buttonW)
            make.height.equalTo(buttonH)
            make.left.top.equalToSuperview()
        }
        
        let playButton = UIButton()
        playButton.setImage(UIImage.init(named: "playButton"), for: UIControlState.normal)
        playButton.setImage(UIImage.init(named: "pauseButton"), for: UIControlState.selected)
        bottomToolView.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.width.equalTo(buttonW)
            make.height.equalTo(buttonH)
            make.left.equalTo(likeButton.snp.right)
            make.top.equalToSuperview()
        }
        let playSignal = playButton.reactive.controlEvents(.touchUpInside)
        playSignal.observeValues {_ in
            playButton.isSelected = !playButton.isSelected
            playButton.isSelected ? albumImageView.stoptRotating() : albumImageView.resumeRotating()
            playButton.isSelected ? self.avPlayer?.pause() : self.avPlayer?.play()
            playButton.isSelected ? self.timer?.invalidate() : self.startTimer()
            let rotatedAngle = (playButton.isSelected ? -1 : 0) * CGFloat(15 * M_PI/180.0)
            UIView.animate(withDuration: 0.8, animations: {
                needleImageView.transform = CGAffineTransform.init(rotationAngle: rotatedAngle)
            })
        }
        
        let playNextButton = UIButton()
        playNextButton.setImage(UIImage.init(named: "playNextButton"), for: UIControlState.normal)
        bottomToolView.addSubview(playNextButton)
        playNextButton.snp.makeConstraints { (make) in
            make.width.equalTo(buttonW)
            make.height.equalTo(buttonH)
            make.right.top.equalToSuperview()
        }
        playNextButton.reactive.controlEvents(.touchUpInside).observeValues { _ in
            print("---------------Play Next!")
            self.playNextSong()
        }
        
        // 歌曲进度条
        let songProgress = UIProgressView()
        songProgress.progressTintColor = kMainColor
        self.songProgress = songProgress
        self.view.addSubview(songProgress)
        songProgress.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(15)
            make.rightMargin.equalTo(-15)
            make.height.equalTo(2)
            make.top.equalTo(bottomToolView).offset(-20)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if needle?.layer.anchorPoint.x == 0.5 {
            let originFrame = needle?.frame
            needle?.layer.anchorPoint = CGPoint.init(x: 0.25, y: 0.16)
            needle?.frame = originFrame!
        }

    }
    
    func loadSongInfo() {
        
        // 先把上一首所存储的歌曲的歌词先清空
        if self.lrcView.lrcData != nil {
            self.lrcView.lrcData = nil
            self.lrcView.reloadData()
        }
        
        let subscriber1 = Observer<String, NoError>(value: {
            print("观察者1接收到值 \($0)")
            self.loadSongLrc()
            
            let mainQueue = DispatchQueue.main
            mainQueue.async {
                self.updateSongView()
                self.playSong()
            }
            self.startTimer()
        })
        
        print("观察者1订阅信号发生器")
        producer.start(subscriber1)
    }
    
    func loadSongLrc() {
        let subscriber = Observer<String, NoError>(value: {
            print("观察者接收到值 \($0)")
            let mainQueue = DispatchQueue.main
            mainQueue.async {
                let lrcModel = ATLrcModel.lrcDataWithString(contentStr: ATSongInfo.sharedInstance.lrcContentStr)
                self.lrcView?.lrcData = lrcModel
                self.lrcView?.reloadData()
            }
        })
        lrcProducer.start(subscriber)
    }
    
    func updateSongView() {
        
        let pictureURL = URL.init(string: ATSongInfo.sharedInstance.picture)
        try! self.albumImageView?.image = UIImage.init(data: Data.init(contentsOf: pictureURL!))
        try! self.backgroundImageView?.image = UIImage.init(data: Data.init(contentsOf: pictureURL!))

        // 设置歌曲名和演唱者
        let songTitle: NSString = String.init(format: "%@\n%@",ATSongInfo.sharedInstance.title, ATSongInfo.sharedInstance.artist) as! NSString
        let attributedString = NSMutableAttributedString.init(string: songTitle as String, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
        attributedString.setAttributes([NSFontAttributeName : UIFont.boldSystemFont(ofSize: 11)], range: songTitle.range(of: ATSongInfo.sharedInstance.artist))
        self.songInfoLabel?.attributedText = attributedString

    }
    
    func playSong() {
        print(ATSongInfo.sharedInstance.url)
        
        if avPlayer == nil {
            let songUrlString: String = ATSongInfo.sharedInstance.url
            let videoURL = NSURL(string: songUrlString)
            avPlayer = AVPlayer(url: videoURL! as URL)
            let playerLayer = AVPlayerLayer(player: avPlayer)
            playerLayer.frame = CGRect.zero
            self.view.layer.addSublayer(playerLayer)
            avPlayer?.play()
        }else {
            avPlayer?.pause()
            let playerItem = AVPlayerItem.init(url: URL.init(string:ATSongInfo.sharedInstance.url)!)
            avPlayer?.replaceCurrentItem(with: playerItem)
            avPlayer?.play()

        }
    }
    
    func playNextSong() {
        self.timer?.invalidate()
        count = 0
        self.songProgress?.progress = 0.0
        self.loadSongInfo()
    }
    
    func startTimer() {
        let songLength = ATSongInfo.sharedInstance.length
        let timeValue = String.init(format: "%i:%02i", (songLength?.intValue)! / 60, (songLength?.intValue)! % 60)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1,
                                         repeats: true,
                                         block: { (timer) in
                                            if count > ATSongInfo.sharedInstance.length.intValue{
                                                self.playNextSong()
                                            }else {
                                                // 设置歌曲时间
                                                let countingTimeValue = String.init(format: "%02i:%02i", count / 60, count % 60)
                                                self.remainTimeLabel?.text = String.init(format: "%@/%@", countingTimeValue, timeValue)
                                                // 设置播放进度条
                                                self.songProgress?.progress = Float(count) / ATSongInfo.sharedInstance.length.floatValue
                                                
                                                // 如果有歌词，滚动歌词
                                                if self.lrcView.lrcData != nil {
                                                    let timeArray = self.lrcView.lrcData!.timeArray!
                                                    for i in 0..<timeArray.count {
                                                        if timeArray[i] == countingTimeValue {
                                                            self.lrcView?.selectRow(i)
                                                            break
                                                        }
                                                    }
                                                }
                                                count += 1
                                            }
                                            
        })
        
    }
}

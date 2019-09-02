//
//  VideoLauncher.swift
//  VideoAnimation
//
//  Created by Yogendra Tandel on 01/09/19.
//  Copyright © 2019 Yogendra Tandel. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerView:UIView {
    
    var player:AVPlayer?
    var playerLayer :AVPlayerLayer?
    var isPlaying = false
    var isFullScreen = false
    var isControlShowing = true
    fileprivate let seekDuration: Float64 = 10
   
    let controlsContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1.0)
        return view
    }()
    
    let activityIndicatorView : UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let pausePlayButton :UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "pause-button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let rewindButton:UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "rewind"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let forwardButton:UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "forward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let minimizeButton:UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "downarrow"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleMinimize), for: .touchUpInside)
        //button.isHidden = true
        return button
    }()
    
    let resizeButton:UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "resize"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleResize), for: .touchUpInside)
        //button.isHidden = true
        return button
    }()
    
    let videoLengthLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textColor = UIColor.white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let videoLapsedLabel:UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textColor = UIColor.white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var videoSlider :UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.setThumbImage(UIImage(named: "slider"), for: .normal)
        slider.addTarget(self, action: #selector(SliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        NotificationCenter.default.addObserver(self, selector: #selector(self.didOrientationChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(controlsContainerTap(tapGesture:)))
        controlsContainerView.addGestureRecognizer(tapGesture)
        controlsContainerView.isUserInteractionEnabled = true
        
    }
    
    @objc func didOrientationChange(_ notification: Notification) {
        //const_pickerBottom.constant = 394
        print("other")
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            print("landscape")

            //self.playerLayer?.affineTransform().rotated(by: self.degreeToRadian(90))
            //self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect;
            //self.playerLayer?.frame = self.layer.bounds
        case .portrait, .portraitUpsideDown:
            print("portrait")
        default:
            print("other")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePause(){
        if isPlaying{
            player?.pause()
            pausePlayButton.setTitle("", for: .normal)
            pausePlayButton.setImage(UIImage(named: "play-button"), for: .normal)
        }else{
            player?.play()
            pausePlayButton.setTitle("", for: .normal)
            pausePlayButton.setImage(UIImage(named: "pause-button"), for: .normal)
        }
        isPlaying = !isPlaying
        print(isPlaying)
    }
    
    @objc func handleRewind(){
        let playerCurrentTime = CMTimeGetSeconds((player?.currentTime())!)
        var newTime = playerCurrentTime - seekDuration
        
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player?.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    @objc func handleForward(){
        guard let duration  = player?.currentItem?.duration else{
            return
        }
        let playerCurrentTime = CMTimeGetSeconds((player?.currentTime())!)
        let newTime = playerCurrentTime + seekDuration
        
        if newTime < (CMTimeGetSeconds(duration) - seekDuration) {
            
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player?.seek(to: time2, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            
        }
    }
    
    @objc func handleMinimize(){
        if let keyWindow = UIApplication.shared.keyWindow{
            self.backgroundColor = UIColor.clear
            UIView.animate(withDuration: 0.1, animations: {
                self.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            }) { (animationCompleted) in
                UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
                self.controlsContainerView.removeFromSuperview()
                self.player?.pause()
                
//                var playerItem: AVPlayerItem?
//                playerItem = nil
//                self.player?.replaceCurrentItem(with: playerItem)
                self.player?.replaceCurrentItem(with: nil)
                keyWindow.viewWithTag(501)?.removeFromSuperview()
            }
            
        }
    }
    
    @objc func handleResize(){
        
        
        if let keyWindow = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.1, delay: 0, options:.curveEaseIn, animations: {
                if self.isFullScreen {
                    self.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.width * 9/16)
                }else{
                    self.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height)
                }
            }) { (animationCompleted) in
                self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect;
                self.playerLayer?.frame = self.layer.bounds
                self.controlsContainerView.frame = self.layer.bounds
            }
        }
        isFullScreen = !isFullScreen
        
    }
    
    func degreeToRadian(_ x: CGFloat) -> CGFloat {
        return .pi * x / 180.0
    }
    
    @objc func controlsContainerTap(tapGesture: UITapGestureRecognizer) {
        //showNameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        videoLapsedLabel.isHidden = !isControlShowing
        videoLengthLabel.isHidden = !isControlShowing
        videoSlider.isHidden = !isControlShowing
        pausePlayButton.isHidden = !isControlShowing
        rewindButton.isHidden = !isControlShowing
        forwardButton.isHidden = !isControlShowing
        minimizeButton.isHidden = !isControlShowing
        resizeButton.isHidden = !isControlShowing
        
        isControlShowing = !isControlShowing
    }
    
    @objc func SliderValueChanged(){
        print(videoSlider.value)
        guard let duration  = self.player?.currentItem?.duration else{
            print("Error getting duration")
            return
        }
        let totalSeconds = CMTimeGetSeconds(duration)
        let value = Float64(videoSlider.value) * totalSeconds
        let seekTime = CMTime(seconds: value, preferredTimescale: 1)
        player?.seek(to: seekTime, completionHandler: { (completedSeek) in
            
        })
    }
       
    
    func ShowVideo(url:String){
        if let url = URL(string: url){
            print(url)
            player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer ?? AVPlayerLayer())
            playerLayer?.frame = self.frame
            
            controlsContainerView.frame = frame
            addSubview(controlsContainerView)
            
            setUpGradient()
            
            controlsContainerView.addSubview(activityIndicatorView)
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            controlsContainerView.addSubview(pausePlayButton)
            pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            pausePlayButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
            pausePlayButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            controlsContainerView.addSubview(rewindButton)
            rewindButton.rightAnchor.constraint(equalTo: pausePlayButton.leftAnchor, constant: -10).isActive = true
            rewindButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            rewindButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            rewindButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            controlsContainerView.addSubview(forwardButton)
            forwardButton.leftAnchor.constraint(equalTo: pausePlayButton.rightAnchor, constant: 10).isActive = true
            forwardButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            forwardButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            forwardButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            controlsContainerView.addSubview(minimizeButton)
            minimizeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            minimizeButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            minimizeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            minimizeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            controlsContainerView.addSubview(resizeButton)
            resizeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            resizeButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            resizeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            resizeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            controlsContainerView.addSubview(videoLapsedLabel)
            videoLapsedLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
            videoLapsedLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
            videoLapsedLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            videoLapsedLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            controlsContainerView.addSubview(videoLengthLabel)
            videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
            videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
            videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            videoLengthLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            controlsContainerView.addSubview(videoSlider)
            videoSlider.leftAnchor.constraint(equalTo: videoLapsedLabel.rightAnchor).isActive = true
            videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
            videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
            videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            
            player?.play()
            
            
            //get video time duration
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //track progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsStr = String(format: "%02d", Int(seconds) % 60)
                let minuteStr = String(format: "%02d", Int(seconds) / 60)
                self.videoLapsedLabel.text = "\(minuteStr):\(secondsStr)"
                
                // move slider
                guard let duration  = self.player?.currentItem?.duration else{
                    print("Error getting duration")
                    return
                }
                let durationSecs = CMTimeGetSeconds(duration)
                self.videoSlider.value = Float(seconds / durationSecs)
            })
        }
    }
    
    private func setUpGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges"{
            print(change)
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            pausePlayButton.isHidden = false
            rewindButton.isHidden = false
            forwardButton.isHidden = false
            isPlaying = true
            
            
            guard let duration  = player?.currentItem?.duration else{
                print("Error getting duration")
                return
            }
            let seconds = CMTimeGetSeconds(duration)
            let secondsStr = String(format: "%02d", Int(seconds) % 60)
            let minuteStr = String(format: "%02d", Int(seconds) / 60)
            videoLengthLabel.text = "\(minuteStr):\(secondsStr)"
        }
    }
}

class VideoLauncher: NSObject {
    func showVideoPlayer(vp:String){
        print("Showing Video Player Animation - \(vp)")
        
        if let keyWindow = UIApplication.shared.keyWindow{
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            let videoPlayerView = VideoPlayerView(frame: CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.width * 9/16))
            videoPlayerView.ShowVideo(url: vp)
            view.addSubview(videoPlayerView)
            view.tag =  501
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }) { (animationCompleted) in
                UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
                
            }
            
            
        }
    }
    
    
    
    
}

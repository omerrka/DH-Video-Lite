//
//  VideoPlayer.swift
//  DH_Video_Lite
//
//  Created by Aybike Zeynep Tiryaki on 29.11.2022.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayer: UIViewController {
    
    var videoURL: String = ""
    var videoURLFHD: String = ""
    var videoURLHD: String = ""
    var videoURLSD: String = ""
    var videoURLMP3: String = ""
    
    var resumeData: Data?
    private lazy var urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    var downloadTask: URLSessionDownloadTask?
    var download = true
    var pause = true
    var isVideoPlaying = false
    var pauseSetting = true
    var downloadSetting = true
    
    var slider = UISlider()
    var currentTime = UILabel()
    var durationVideo = UILabel()
    var progressLabel = UILabel()
    
    var videoView = UIView()
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    
    var downloadButton = UIButton()
    
    var backButton = UIButton()
    var forwardButton = UIButton()
    var playButton = UIButton()
    var FHDQualityButton = UIButton()
    var HDQualityButton = UIButton()
    var SDQualityButton = UIButton()
    var MP3QualityButton = UIButton()
    var fullScreenButton = UIButton()
    
    override func viewDidLoad() {
        
        setButtonConstraints()
        setSliderConstraints()
        setCurrentTimeConstraints()
        configureCurrentTimeLabel()
        durationVideoConstraints()
        configureDurationVideoLabel()
        buttonAction()
    }
    
    func customPlayer(url:URL) {
        
        player = AVPlayer(url: url)
        playerItem = AVPlayerItem(url: url)
        playerLayer = AVPlayerLayer(player: player)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        playerLayer.videoGravity = .resize
        videoView.layer.addSublayer(playerLayer)
        
    }
    
    func buttonAction() {
        
        slider.addTarget(self, action: #selector(VideoPlayer.changeVlaue(_:)), for: .valueChanged)
        playButton.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardAction(sender:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        FHDQualityButton.addTarget(self, action: #selector(FHDButtonTapped(sender:)), for: .touchUpInside)
        HDQualityButton.addTarget(self, action: #selector(HDButtonTapped(sender:)), for: .touchUpInside)
        SDQualityButton.addTarget(self, action: #selector(SDButtonTapped(sender:)), for: .touchUpInside)
        MP3QualityButton.addTarget(self, action: #selector(MP3ButtonTapped(sender:)), for: .touchUpInside)
        fullScreenButton.addTarget(self, action: #selector(fullScreenButtonTapped(sender:)), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped(sender:)), for: .touchUpInside)
        
    }
    
    @objc
    func playAction(sender: UIButton) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playButton.isHidden = true
            self.backButton.isHidden = true
            self.forwardButton.isHidden = true
            self.HDQualityButton.isHidden = true
            self.FHDQualityButton.isHidden = true
            self.SDQualityButton.isHidden = true
            self.MP3QualityButton.isHidden = true
            self.slider.isHidden = true
            self.durationVideo.isHidden = true
            self.fullScreenButton.isHidden = true
            self.currentTime.isHidden = true
        }
        
        if isVideoPlaying {
            
            player.pause()
            sender.setImage(UIImage(systemName: "play"), for: .normal)
            
        } else {
            
            player.play()
            sender.setImage(UIImage(systemName: "pause"), for: .normal)
        }
        
        isVideoPlaying = !isVideoPlaying
    }
    
    @objc
    func forwardAction(sender: UIButton) {
        
        guard let duration = player.currentItem?.duration else {return}
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 15.0
        
        if newTime < (CMTimeGetSeconds(duration) - 15.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: Int32(1000))
            player.seek(to: time)
        }
        
        hideButtons()
    }
    
    @objc
    func backAction(sender: UIButton) {
        
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 15.0
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: Int32(1000))
        player.seek(to: time)
        
        
        hideButtons()
    }
    
    @objc
    func FHDButtonTapped(sender: UIButton) {
        
        playerItem = AVPlayerItem(url: URL(string: videoURLFHD)!)
        
        let currentTime = CMTimeGetSeconds(self.player.currentTime())
        let time: CMTime = CMTimeMake(value: Int64(currentTime*1000), timescale: Int32(1000))
        
        self.playerItem.seek(to: time)
        self.player.replaceCurrentItem(with: self.playerItem)
        
        frameButton(button: HDQualityButton, bool: false)
        frameButton(button: FHDQualityButton, bool: true)
        frameButton(button: SDQualityButton, bool: false)
        frameButton(button: MP3QualityButton, bool: false)
        
        hideButtons()
        
        
    }
    
    @objc
    func HDButtonTapped(sender: UIButton) {
        playerItem = AVPlayerItem(url: URL(string: videoURLHD)!)
        
        let currentTime = CMTimeGetSeconds(self.player.currentTime())
        let time: CMTime = CMTimeMake(value: Int64(currentTime*1000), timescale: Int32(1000))
        
        self.playerItem.seek(to: time)
        self.player.replaceCurrentItem(with: self.playerItem)
        
        frameButton(button: HDQualityButton, bool: true)
        frameButton(button: FHDQualityButton, bool: false)
        frameButton(button: SDQualityButton, bool: false)
        frameButton(button: MP3QualityButton, bool: false)
        
        hideButtons()
        
    }
    
    @objc
    func SDButtonTapped(sender: UIButton) {
        playerItem = AVPlayerItem(url: URL(string: videoURLSD)!)
        
        let currentTime = CMTimeGetSeconds(self.player.currentTime())
        let time: CMTime = CMTimeMake(value: Int64(currentTime*1000), timescale: Int32(1000))
        
        self.playerItem.seek(to: time)
        self.player.replaceCurrentItem(with: self.playerItem)
        frameButton(button: HDQualityButton, bool: false)
        frameButton(button: FHDQualityButton, bool: false)
        frameButton(button: SDQualityButton, bool: true)
        frameButton(button: MP3QualityButton, bool: false)
        
        hideButtons()
        
    }
    
    @objc
    func MP3ButtonTapped(sender: UIButton) {
        
        playerItem = AVPlayerItem(url: URL(string: videoURLMP3)!)
        
        let currentTime = CMTimeGetSeconds(self.player.currentTime())
        let time: CMTime = CMTimeMake(value: Int64(currentTime*1000), timescale: Int32(1000))
        
        self.playerItem.seek(to: time)
        self.player.replaceCurrentItem(with: self.playerItem)
        frameButton(button: HDQualityButton, bool: false)
        frameButton(button: FHDQualityButton, bool: false)
        frameButton(button: SDQualityButton, bool: false)
        frameButton(button: MP3QualityButton, bool: true)
        videoView.backgroundColor = .lightGray
        
        hideButtons()
        
    }
    
    @objc
    func fullScreenButtonTapped(sender: UIButton) {
        
        var value  = UIInterfaceOrientation.landscapeRight.rawValue
        if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
            value = UIInterfaceOrientation.portrait.rawValue
        }
        
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        
    }
    
    @objc func changeVlaue(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationVideo.text = getTimeString(from: player.currentItem!.duration)
            
        }
    }
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
            
        }
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            
            self?.slider.maximumValue = Float(currentItem.duration.seconds)
            self?.slider.minimumValue = 0
            self?.slider.value = Float(currentItem.currentTime().seconds)
            self?.currentTime.text = self?.getTimeString(from: currentItem.currentTime())
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if touch?.view == self.videoView {
            
            toggleButtons()
            hideButtons()
            
        }
    }
    
    func setButtonConstraints() {
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -85).isActive = true
        backButton.setImage(UIImage(systemName: "backward"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        backButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        backButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        playButton.centerXAnchor.constraint(equalTo: videoView.centerXAnchor).isActive = true
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        playButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        
        forwardButton.setImage(UIImage(systemName: "forward"), for: .normal)
        forwardButton.trailingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 85).isActive = true
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.imageView?.contentMode = .scaleAspectFit
        forwardButton.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        forwardButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        forwardButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        
        FHDQualityButton.translatesAutoresizingMaskIntoConstraints = false
        FHDQualityButton.topAnchor.constraint(equalTo: videoView.topAnchor, constant: 12).isActive = true
        FHDQualityButton.setTitle("FHD", for: .normal)
        FHDQualityButton.trailingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: -12).isActive = true
        
        HDQualityButton.translatesAutoresizingMaskIntoConstraints = false
        HDQualityButton.topAnchor.constraint(equalTo: videoView.topAnchor, constant: 12).isActive = true
        HDQualityButton.setTitle("HD", for: .normal)
        HDQualityButton.trailingAnchor.constraint(equalTo: FHDQualityButton.trailingAnchor, constant: -42).isActive = true
        
        SDQualityButton.translatesAutoresizingMaskIntoConstraints = false
        SDQualityButton.topAnchor.constraint(equalTo: videoView.topAnchor, constant: 12).isActive = true
        SDQualityButton.setTitle("SD", for: .normal)
        SDQualityButton.trailingAnchor.constraint(equalTo: HDQualityButton.trailingAnchor, constant: -42).isActive = true
        frameButton(button: SDQualityButton, bool: true)
        
        
        MP3QualityButton.translatesAutoresizingMaskIntoConstraints = false
        MP3QualityButton.topAnchor.constraint(equalTo: videoView.topAnchor, constant: 12).isActive = true
        MP3QualityButton.setTitle("MP3", for: .normal)
        MP3QualityButton.trailingAnchor.constraint(equalTo: SDQualityButton.trailingAnchor, constant: -42).isActive = true
        
        
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        fullScreenButton.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -4).isActive = true
        fullScreenButton.trailingAnchor.constraint(equalTo: durationVideo.trailingAnchor, constant: 18).isActive = true
        fullScreenButton.setImage(UIImage(systemName: "viewfinder")?.withTintColor(.black), for: .normal)
        fullScreenButton.imageView?.contentMode = .scaleAspectFit
        fullScreenButton.imageEdgeInsets = UIEdgeInsets(top: 19, left: 19, bottom: 19, right: 19)
        
    }
    
    func setDownloadButtonConstraints(backgroundView: UIView) {
        
        backgroundView.addSubview(downloadButton)
        backgroundView.addSubview(progressLabel)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12).isActive = true
        downloadButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12).isActive = true
        downloadButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        downloadButton.tintColor = .white
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.trailingAnchor.constraint(equalTo: downloadButton.leadingAnchor, constant: -16).isActive = true
        progressLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12).isActive = true
        progressLabel.textColor = .white
        
        
    }
    
    func setVideoViewConstraints(view: UIView) {
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        videoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        videoView.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        videoView.heightAnchor.constraint(equalToConstant: (view.frame.size.width)*(9/16)).isActive = true
        
    }
    
    func setSliderConstraints() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.bottomAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: videoView.leadingAnchor, constant: 40).isActive = true
        slider.trailingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: -75).isActive = true
    }
    
    func setCurrentTimeConstraints() {
        currentTime.translatesAutoresizingMaskIntoConstraints = false
        currentTime.widthAnchor.constraint(equalToConstant: 40).isActive = true
        currentTime.leadingAnchor.constraint(equalTo: videoView.leadingAnchor, constant: 3).isActive = true
        currentTime.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -7).isActive = true
        
    }
    
    func configureCurrentTimeLabel() {
        currentTime.numberOfLines = 0
        currentTime.font = currentTime.font.withSize(12)
    }
    
    func durationVideoConstraints() {
        durationVideo.translatesAutoresizingMaskIntoConstraints = false
        durationVideo.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -7).isActive = true
        durationVideo.widthAnchor.constraint(equalToConstant: 40).isActive = true
        durationVideo.trailingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 45).isActive = true
    }
    
    func configureDurationVideoLabel() {
        durationVideo.numberOfLines = 0
        durationVideo.font = durationVideo.font.withSize(12)
    }
    
    func frameButton(button: UIButton, bool: Bool) {
        
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        
        if bool == true {
            
            button.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
            button.layer.cornerRadius = cornerRadius
            
        } else {
            
            button.backgroundColor = UIColor.clear
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
            button.layer.cornerRadius = cornerRadius
            
        }
    }
    
    func hideButtons() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.playButton.isHidden = true
            self.backButton.isHidden = true
            self.forwardButton.isHidden = true
            self.SDQualityButton.isHidden = true
            self.HDQualityButton.isHidden = true
            self.FHDQualityButton.isHidden = true
            self.MP3QualityButton.isHidden = true
            self.slider.isHidden = true
            self.durationVideo.isHidden = true
            self.fullScreenButton.isHidden = true
            self.currentTime.isHidden = true
            
        }
    }
    
    func toggleButtons() {
        
        self.playButton.isHidden.toggle()
        self.backButton.isHidden.toggle()
        self.forwardButton.isHidden.toggle()
        self.HDQualityButton.isHidden.toggle()
        self.FHDQualityButton.isHidden.toggle()
        self.SDQualityButton.isHidden.toggle()
        self.MP3QualityButton.isHidden.toggle()
        self.slider.isHidden.toggle()
        self.durationVideo.isHidden.toggle()
        self.fullScreenButton.isHidden.toggle()
        self.currentTime.isHidden.toggle()
    }
    
    func subviews(view: UIView) {
        
        view.addSubview(videoView)
        view.addSubview(backButton)
        view.addSubview(playButton)
        view.addSubview(forwardButton)
        view.addSubview(slider)
        view.addSubview(currentTime)
        view.addSubview(durationVideo)
        view.addSubview(FHDQualityButton)
        view.addSubview(HDQualityButton)
        view.addSubview(SDQualityButton)
        view.addSubview(MP3QualityButton)
        view.addSubview(fullScreenButton)
        
    }
    
    
    @objc
    func downloadButtonTapped(sender: UIButton) {
        
        progressLabel.isHidden = false
        
        
        if download == true {
            showSimpleActionSheet(controller: self)
            
        }
        if downloadSetting == false {
            downloadOptionsActionSheet(controller: self)
        }
        
        if pauseSetting == false {
            pauseActionSheet(controller: self)
        }
        
    }
    
    func startCancelDownload(url: URL) {
        
        let downloadTask = urlSession.downloadTask(with: url)
        if download == true {
            downloadTask.resume()
            self.downloadTask = downloadTask
            
        } else {
            
            self.downloadTask?.cancel()
            
        }
        
        download = !download
        
    }
    
    func showSimpleActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "FHD Video İndir", style: .default, handler: { (_) in
            self.videoURL = self.videoURLFHD
            guard let url = URL(string: self.videoURL) else {return}
            self.startCancelDownload(url: url)
            self.downloadSetting = false
            
        }))
        
        alert.addAction(UIAlertAction(title: "HD Video İndir", style: .default, handler: { (_) in
            self.videoURL = self.videoURLHD
            guard let url = URL(string: self.videoURL) else {return}
            self.startCancelDownload(url: url)
            self.downloadSetting = false
            
        }))
        
        alert.addAction(UIAlertAction(title: "SD Video İndir", style: .default, handler: { (_) in
            self.videoURL = self.videoURLSD
            guard let url = URL(string: self.videoURL) else {return}
            self.startCancelDownload(url: url)
            self.downloadSetting = false
            
        }))
        
        alert.addAction(UIAlertAction(title: "MP3 Video İndir", style: .default, handler: { (_) in
            self.videoURL = self.videoURLMP3
            guard let url = URL(string: self.videoURL) else {return}
            self.startCancelDownload(url: url)
            self.downloadSetting = false
            
            
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    func downloadOptionsActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: "İndirmeyi ne yapalım?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sonlandır", style: .default, handler: { (_) in
            
            guard let url = URL(string: self.videoURL) else {return}
            self.startCancelDownload(url: url)
            self.download = true
            self.downloadSetting = true
            self.pauseSetting = true
            self.progressLabel.isHidden = true
            
            DispatchQueue.main.async {
                self.progressLabel.text = ""
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Duraklat", style: .default, handler: { (_) in
            
            if self.pause == true {
                self.downloadTask?.cancel { resumeDataOrNil in
                    guard let resumeData = resumeDataOrNil else {return}
                    self.resumeData = resumeData
                    self.download = false
                    self.pauseSetting = false
                    self.downloadSetting = true
                }
                
            } else {
                
                guard let resumeData = self.resumeData else {return}
                let downloadTask = self.urlSession.downloadTask(withResumeData: resumeData)
                downloadTask.resume()
                self.downloadTask = downloadTask
                self.pauseSetting = false
                self.downloadSetting = true
                self.download = false
                
            }
            
            self.pause = !self.pause
            
        }))
        
        alert.addAction(UIAlertAction(title: "Geri Dön", style: .default, handler: { (_) in
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func pauseActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: "İndirmeyi ne yapalım?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Devam et", style: .default, handler: { (_) in
            if self.pause == true {
                self.downloadTask?.cancel { resumeDataOrNil in
                    guard let resumeData = resumeDataOrNil else {return}
                    self.resumeData = resumeData
                }
                
            } else {
                
                guard let resumeData = self.resumeData else {return}
                let downloadTask = self.urlSession.downloadTask(withResumeData: resumeData)
                downloadTask.resume()
                self.downloadTask = downloadTask
                
            }
            
            self.pause = !self.pause
            self.pauseSetting = true
            self.downloadSetting = false
            
        }))
        
        alert.addAction(UIAlertAction(title: "Sonlandır", style: .default, handler: { (_) in
            guard let url = URL(string: self.videoURL) else {return}
            self.startCancelDownload(url: url)
            self.download = true
            self.pauseSetting = true
            self.progressLabel.isHidden = true
            
            DispatchQueue.main.async {
                self.progressLabel.text = ""
            }
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
    }
}


extension VideoPlayer: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let url = URL(string: videoURL) else {return}
        guard let folderURL = URL.createFolder(folderName: "StoredVideos") else {
            print("Can't create url")
            return
        }
        
        let permanentFileURL = folderURL.appendingPathComponent(url.lastPathComponent).appendingPathExtension("MOV")
        let videoData = try! Data(contentsOf: url)
        try! videoData.write(to: permanentFileURL, options: .atomic)
        
        DispatchQueue.main.async {
            self.progressLabel.isHidden = true
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)) * 100
        let progressToDisplay = String(format: "%.0f%", progress)
        
        DispatchQueue.main.async {
            self.progressLabel.text = "%\(progressToDisplay)"
            
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {return}
        
        let userInfo = (error as NSError).userInfo
        if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
            self.resumeData = resumeData
        }
    }
}



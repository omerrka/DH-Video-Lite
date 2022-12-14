//
//  VideoPlayerVC.swift
//  DH_Video_Lite
//
//  Created by Aybike Zeynep Tiryaki on 18.11.2022.
//

import UIKit
import AVFoundation
import AVKit


class VideoPlayerVC: UIViewController {
    
    var videoPlayer = VideoPlayer()
    
    var videoURL: String = ""
    var videoURLFHD: String = ""
    var videoURLHD: String = ""
    var videoURLSD: String = ""
    var videoURLMP3: String = ""
    var titleVideo: String = ""
    var shortContentVideo: String = ""
    var titleLabel = UILabel()
    var shortContentLabel = UILabel()
    var categoryLabel = UILabel()
    var createDateLabel = UILabel()
    var createDate: String = ""
    var category: String = ""
    var backgroundView = UIView()
    var colorAverage: String = ""
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = "DH Video Lite"
        videoPlayer.videoURL = videoURL
        videoPlayer.videoURLFHD = videoURLFHD
        videoPlayer.videoURLHD = videoURLHD
        videoPlayer.videoURLSD = videoURLSD
        videoPlayer.videoURLMP3 = videoURLMP3
        
        videoPlayer.subviews(view: view)
        addSubviews()
        videoPlayer.setVideoViewConstraints(view: view)

        addChild(videoPlayer)
        self.view.addSubview(videoPlayer.view)
        videoPlayer.didMove(toParent: self)
        videoPlayer.view.frame = videoPlayer.videoView.bounds
        
        titleLabelConstraints()
        shortContentLabelConstraints()
        categoryLabelConstraints()
        createDateLabelConstraints()
        backgroundViewConstraints()
        videoPlayer.setDownloadButtonConstraints(backgroundView: backgroundView)

        
        let url = URL(string: videoURLSD)!
        
        titleLabel.text = titleVideo
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        createDateLabel.text = createDate.capitalized
        categoryLabel.text = category.capitalized
        shortContentLabel.text = shortContentVideo
        
        videoPlayer.customPlayer(url: url)
        videoPlayer.addTimeObserver()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPlayer.playerLayer.frame = videoPlayer.videoView.bounds
    }
    
    func titleLabelConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: videoPlayer.videoView.bottomAnchor, constant: 12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12 ).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        
    }
    
    func shortContentLabelConstraints() {
        
        shortContentLabel.translatesAutoresizingMaskIntoConstraints = false
        shortContentLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 24).isActive = true
        shortContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12 ).isActive = true
        shortContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        shortContentLabel.textColor = .white
        shortContentLabel.numberOfLines = 0
        shortContentLabel.adjustsFontSizeToFitWidth = true
    }
    
    func categoryLabelConstraints() {
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32).isActive = true
        categoryLabel.textColor = .white
        categoryLabel.numberOfLines = 0
        categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        categoryLabel.backgroundColor = .orange
        categoryLabel.layer.masksToBounds = true
        categoryLabel.layer.cornerRadius = 5
        categoryLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    func createDateLabelConstraints() {
        
        createDateLabel.translatesAutoresizingMaskIntoConstraints = false
        createDateLabel.adjustsFontSizeToFitWidth = true
        createDateLabel.textColor = .white
        createDateLabel.numberOfLines = 0
        createDateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32).isActive = true
        createDateLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 12).isActive = true
        
    }
    
    func backgroundViewConstraints() {
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.topAnchor.constraint(equalTo: videoPlayer.videoView.bottomAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: videoPlayer.videoView.bottomAnchor, constant: 0).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12).isActive = true
        backgroundView.backgroundColor = hexStringToUIColor(hex: colorAverage)

    }
    
    func addSubviews () {
        
        view.addSubview(backgroundView)
        view.addSubview(categoryLabel)
        view.addSubview(createDateLabel)
        view.addSubview(titleLabel)
        view.addSubview(shortContentLabel)
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if (UIDevice.current.orientation.isLandscape) {
            
            navigationController?.isNavigationBarHidden = true
            
            videoPlayer.videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        } else {
            
            navigationController?.isNavigationBarHidden = false
            
            videoPlayer.videoView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -300).isActive = true
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if touch?.view == videoPlayer.videoView {
            
            videoPlayer.toggleButtons()
            videoPlayer.hideButtons()
            
        }
    }
}

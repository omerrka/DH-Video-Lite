//
//  VideoListCell.swift
//  DH_Video_Lite
//
//  Created by Aybike Zeynep Tiryaki on 16.11.2022.
//

import UIKit
import Kingfisher

class VideoListCell: UITableViewCell {
    
    var videoImageView = UIImageView()
    var videoTitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(videoImageView)
        addSubview(videoTitleLabel)
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVideo(video: Datum) {

        videoTitleLabel.text = video.title
        videoImageView.kf.setImage(with: URL(string: video.smallImage.value), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    }

    func configureTitleLabel() {
        videoTitleLabel.numberOfLines = 0
        videoTitleLabel.adjustsFontSizeToFitWidth = true
        videoTitleLabel.textColor = .white
        
    }
    
    func setImageConstraints() {
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        videoImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        videoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        videoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true

    }
    
    func setTitleLabelConstraints() {
        videoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        videoTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        videoTitleLabel.leadingAnchor.constraint(equalTo: videoImageView.trailingAnchor, constant: 20).isActive = true
        videoTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        videoTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}


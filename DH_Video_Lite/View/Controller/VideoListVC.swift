//
//  VideoListVC.swift
//  DH_Video_Lite
//
//  Created by Aybike Zeynep Tiryaki on 16.11.2022.
//

import UIKit

class VideoListVC: UIViewController {

    private let videoListViewModel = VideoListViewModel()
    private let videoListCell = VideoListCell()
    var tableView = UITableView()

    struct Cells {
        static let videoCell = "VideoListCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        configureTableView()
        videoListViewModel.delegate = self
        videoListViewModel.loadVideoData()

    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(VideoListCell.self, forCellReuseIdentifier: Cells.videoCell)
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
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
}

extension VideoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (videoListViewModel.videoDetail?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundColor = hexStringToUIColor(hex: videoListViewModel.videoDetail![indexPath.row].smallImage.colorAvarage)
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.videoCell) as! VideoListCell
        cell.setupVideo(video: videoListViewModel.videoDetail![indexPath.row])
        cell.backgroundColor = backgroundColor
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VideoPlayerVC()
        navigationController?.pushViewController(vc, animated: false)
        vc.videoURL = videoListViewModel.videoDetail![indexPath.row].videos[5].value
        vc.videoURLFHD = videoListViewModel.videoDetail![indexPath.row].videos[5].value
        vc.videoURLHD = videoListViewModel.videoDetail![indexPath.row].videos[4].value
        vc.videoURLSD = videoListViewModel.videoDetail![indexPath.row].videos[3].value
        vc.videoURLMP3 = videoListViewModel.videoDetail![indexPath.row].videos[2].value
        vc.titleVideo = videoListViewModel.videoDetail![indexPath.row].title
        vc.createDate = videoListViewModel.videoDetail![indexPath.row].createDateWellFormed
        vc.category = videoListViewModel.videoDetail![indexPath.row].categoriUrl
        vc.shortContentVideo = videoListViewModel.videoDetail![indexPath.row].shortContent
        vc.colorAverage = videoListViewModel.videoDetail![indexPath.row].smallImage.colorAvarage

    }
}

extension VideoListVC: VideoListViewModelProtocol {
    func didUpdateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
    



//
//  VideoListViewModel.swift
//  DH_Video_Lite
//
//  Created by Aybike Zeynep Tiryaki on 17.11.2022.
//

protocol VideoListViewModelProtocol: class {
    func didUpdateTableView()
}

import UIKit

class VideoListViewModel {
    
    weak var delegate: VideoListViewModelProtocol?
    
    fileprivate(set) var videoDetail: [Datum]? = []

    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    func loadVideoData() {
        networkManager.fetchVideoData(completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let dhVideoModel):
                strongSelf.videoDetail = dhVideoModel.data.newest.dataa
                strongSelf.delegate?.didUpdateTableView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}



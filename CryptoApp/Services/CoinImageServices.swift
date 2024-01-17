//
//  CoinImageServices.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 9/1/24.
//

import Combine
import Foundation
import UIKit

class CoinImageServices {
    @Published var image: UIImage?
    var imageSubscription: AnyCancellable?
    var coin: CoinModel

    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String

    init(coin: CoinModel) {
        self.coin = coin
        imageName = coin.id
        getCoinImage()
    }

    private func getCoinImage() {
        if let image = fileManager.getImage(folderName: folderName, imageName: coin.id) {
            self.image = image
            //print("D>> Retrive From File Manager")
        } else {
            //print("D>> Download From url")
            downloadImage(urlString: coin.image)
        }
    }

    private func downloadImage(urlString: String) {
      
        guard let url = URL(string: urlString) else {
            return
        }

        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage? in
                UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletation, receiveValue: { [weak self] image in

                guard let self = self, let downloadedimage = image else { return }

                self.image = image
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedimage, folderName: self.folderName, imageName: self.imageName)
            })
    }
}

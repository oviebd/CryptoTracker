//
//  CoinImageServices.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 9/1/24.
//

import Foundation
import UIKit
import Combine

class CoinImageServices {
    
    @Published var image : UIImage?
    var imageSubscription: AnyCancellable?

    
    init(urlString : String) {
       getCoinImage(urlString: urlString)
    }
    
    private func getCoinImage(urlString : String){
        guard let url = URL(string: urlString) else {
            return
        }

        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletation, receiveValue: { [weak self] image in
                self?.image = image
                self?.imageSubscription?.cancel()
            })
    }
    
}

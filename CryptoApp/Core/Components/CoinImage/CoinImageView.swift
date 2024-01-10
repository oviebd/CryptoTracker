//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 9/1/24.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var islOading: Bool = false
    
    private let coin : CoinModel
    private let dataService: CoinImageServices
    private var cancellables = Set<AnyCancellable>()
    
    init(coin : CoinModel) {
        self.coin = coin
        dataService = CoinImageServices(coin: coin)
        islOading = true
        addSubscriber()
    }
    
    private func addSubscriber(){
        
        dataService.$image.sink { [weak self] (_) in
            self?.islOading = false
        } receiveValue: { [weak self] image in
            self?.image = image
        }.store(in: &cancellables)

        
//        dataService.$image.sink { image in
//            self.image = image
//        }
    }
}


struct CoinImageView: View {
    
    @StateObject var vm : CoinImageViewModel
    
    init(coin : CoinModel) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack{
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else if vm.islOading {
                ProgressView()
            }else{
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
    }
}

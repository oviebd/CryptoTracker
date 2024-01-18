//
//  HomeView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 6/1/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioSheetView: Bool = false
  

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioSheetView , content: {
                    PortfolioView()
                        .environmentObject(vm)
                })

            VStack {
                headerView
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarVIew(searchText: $vm.searchText)
                
                HStack{
                    
                    HStack(spacing: 4) {
                        Text("Coin")
                        Image(systemName: "chevron.down")
                            .opacity(getRankSortImageOpacity())
                            .rotationEffect( Angle(degrees: getRotationOfRankSortImage()))
                    }.onTapGesture {
                        withAnimation(.default){
                            vm.sortOption = (vm.sortOption == .rank) ? .rankReversed : .rank
                        }
                    }
                    
                  
                    Spacer()
                    if showPortfolio {
                        
                        HStack(spacing: 4) {
                            Text("Holdings")
                            Image(systemName: "chevron.down")
                                .opacity(getHoldingsSortImageOpacity())
                                .rotationEffect( Angle(degrees: getRotationOfHoldingsSortImage()))
                                
                        }.onTapGesture {
                            withAnimation(.default){
                                vm.sortOption = (vm.sortOption == .holdings) ? .holdingsReversed : .holdings
                            }
                        }
                                            
                        Spacer()
                    }
                
                    
                    Button(action: {
                        withAnimation(.linear(duration: 2.0)) {
                            vm.reloadData()
                        }
                    }, label: {
                        Image(systemName: "goforward")
                    })
                    .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
                    
                    HStack(spacing: 4) {
                        Text("Price")
                        Image(systemName: "chevron.down")
                            .opacity(getPriceSortImageOpacity())
                            .rotationEffect( Angle(degrees: getRotationOfPriceSortImage()))
                    }.onTapGesture {
                        withAnimation(.default){
                            vm.sortOption = (vm.sortOption == .price) ? .priceReversed : .price
                        }
                    }
                  
                     
                }.font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.horizontal)
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
              
                
                Spacer(minLength: 0)
            }
        }
    }
    
    
    func getRankSortImageOpacity() -> Double {
        return (vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0
    }
    
    func getHoldingsSortImageOpacity() -> Double {
        return (vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0
    }
    
    func getPriceSortImageOpacity() -> Double {
        return (vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0
    }
    
    func getRotationOfRankSortImage() -> Double {
        return vm.sortOption == .rank ? 0 : 180
    }
    
    func getRotationOfHoldingsSortImage() -> Double {
        return vm.sortOption == .holdings ? 0 : 180
    }
    
    func getRotationOfPriceSortImage() -> Double {
        return vm.sortOption == .price ? 0 : 180
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }.environmentObject(dev.homeVm)
    }
}

extension HomeView {
    private var headerView: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                ).onTapGesture {
                    showPortfolioSheetView.toggle()
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline).fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    
    private var allCoinsList : some View {
        
        List{
            ForEach(vm.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 15))
            }
           
        }.listStyle(PlainListStyle())
        
    }
    
    private var portfolioCoinsList : some View {
        
        List{
            ForEach(vm.portfolioCoins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 15))
            }
           
        }.listStyle(PlainListStyle())
        
    }
    
}

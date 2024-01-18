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
                    
                    Text("Coin")
                    Spacer()
                    if showPortfolio {
                        Text("Holdings")
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
                    Text("Price")
                     
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

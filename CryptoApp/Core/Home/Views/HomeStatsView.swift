//
//  HomeStatsView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 13/1/24.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm : HomeViewModel
    @Binding var showPortfolio : Bool
    
    
    
    var body: some View {
        HStack{
            ForEach(vm.statistics) {
                statData in
                StatisticView(statData: statData)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }.frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(DeveloperPreview.instance.homeVm )
        
    }
}

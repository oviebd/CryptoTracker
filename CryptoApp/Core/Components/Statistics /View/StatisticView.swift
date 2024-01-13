//
//  StatisticView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 13/1/24.
//

import SwiftUI

struct StatisticView: View {
   
    let statData : Statistic
    
    var body: some View {
        VStack{
            Text(statData.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            
            Text(statData.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            HStack(spacing: 5){
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: statData.changesInPercentage > 0 ? 0 : 180)
                    )
                
                Text(statData.changesInPercentage.asPercentString())
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(statData.changesInPercentage >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(statData.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

#Preview {
    StatisticView(statData: DeveloperPreview.instance.stat3)
}

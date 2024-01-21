//
//  ChartView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 21/1/24.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double

    private let lineColor: Color

    private let startingDate: Date
    private let endingDate: Date
    
    @State private var lineAnimationPercentage : CGFloat = 0

    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0

        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange <= 0 ? Color.theme.red : Color.theme.green

        endingDate = (coin.lastUpdated ?? "").toDate(fromFormat: DateFormat.coinGeco.rawValue)
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }

    var body: some View {
        VStack {
            chart
                .frame(height: 200)
                .background(chartBg)
                .overlay(alignment: .leading, content: {
                    chartYAxisOverlay.padding(.horizontal,4)
                })

            chatDateLabel
                .padding(.horizontal,4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                withAnimation (.linear(duration: 1.5)){
                    lineAnimationPercentage = 1.0
                }
            }
        }
    }
}

extension ChartView {
    private var chart: some View {
        GeometryReader { geometry in
            Path {
                path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)

                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }

                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0.0, to: lineAnimationPercentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor,radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5),radius: 20, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.2),radius: 30, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.1),radius: 40, x: 0.0, y: 10)
        }
    }

    private var chartBg: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }

    private var chartYAxisOverlay: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let middle = (maxY + minY) / 2
            Text(middle.formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }

    private var chatDateLabel: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

//
//  HomeStatsView.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 27/08/25.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack{
            ForEach(vm.statistics) { stat in
                StatisticsView(stat: stat)
                    .frame(width: UIScreen.current.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.current.bounds.width,
               alignment: showPortfolio ? .trailing : .leading
        )
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
        .environmentObject(dev.homeVM)
}

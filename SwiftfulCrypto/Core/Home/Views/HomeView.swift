//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 10/08/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPorfolio: Bool = false // animate right
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var showSettingsView: Bool = false // new sheet
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            // content layer
            VStack {
                homeHeader
                
                HomeStatsView(showPortfolio: $showPorfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPorfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                if showPorfolio {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        
        .background(
            NavigationLink(
                destination: DetailLoadingView(
                    coin: $selectedCoin
                ),
                isActive: $showDetailView,
                label: {
                    EmptyView()
                }
            )
        )
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(dev.homeVM)
}

extension HomeView {
    private var homeHeader: some View {
        HStack{
            CircleButtonView(iconName: showPorfolio ? "plus" : "info")
                .animation(.none, value: showPorfolio)
                .onTapGesture {
                    if showPorfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPorfolio)
                )
            Spacer()
            Text(showPorfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none, value: showPorfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPorfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPorfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 0,
                            bottom: 10,
                            trailing: 10
                        )
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .refreshable {
            withAnimation(.linear) {
                vm.reloadData()
            }
        }
        .listStyle(.plain)
    }
    private var portfolioCoinList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 0,
                            bottom: 10,
                            trailing: 10
                        )
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .refreshable {
            withAnimation(.linear) {
                vm.reloadData()
            }
        }
        .listStyle(.plain)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitles: some View {
        HStack{
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
                
            }
            
            Spacer()
            if showPorfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            (
                                vm.sortOption == .holdings || vm.sortOption == .holdingsReversed
                            ) ? 1.0 : 0.0
                        )
                        .rotationEffect(
                            Angle(degrees: vm.sortOption == .holdings ? 0 : 180)
                        )
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
                
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(
                        (
                            vm.sortOption == .price || vm.sortOption == .priceReversed
                        ) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
                .frame(
                    width: UIScreen.current.bounds.width / 3.5,
                    alignment: .trailing
                )
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                    }
                }
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

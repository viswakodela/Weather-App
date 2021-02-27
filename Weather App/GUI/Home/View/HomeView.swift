//
//  HomeView.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @ObservedObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                
            }
            .navigationTitle("My Cities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.addButtonAction, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
        .sheet(isPresented: $viewModel.isPresented, content: { () -> AddCityView in
            let cityView = AddCityView()
            viewModel.chosenCity(from: cityView)
            return cityView
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  ContentView.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import SwiftUI

struct ContentView: View {
    let viewModel = AddLocationViewModel()
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

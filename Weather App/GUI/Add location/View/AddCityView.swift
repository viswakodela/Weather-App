//
//  AddCityView.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import SwiftUI
import UIKit
import Combine

struct AddCityView: UIViewControllerRepresentable {
    
    let cityViewController = AddCityViewController()
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navController = UINavigationController(rootViewController: cityViewController)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

struct AddCityView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityView()
    }
}

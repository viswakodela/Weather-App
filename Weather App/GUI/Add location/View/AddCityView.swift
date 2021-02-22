//
//  AddCityView.swift
//  Weather App
//
//  Created by Viswa Kodela on 2/21/21.
//

import SwiftUI
import UIKit

struct AddCityView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navController = UINavigationController(rootViewController: AddCityViewController())
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

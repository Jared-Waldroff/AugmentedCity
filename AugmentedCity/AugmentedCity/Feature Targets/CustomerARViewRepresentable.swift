//
//  CustomerARViewRepresentable.swift
//  AugmentedCity
//
//  Created by Jared Waldroff on 2023-12-22.
//

import SwiftUI

struct CustomerARViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView()
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
}

//
//  ActivityIndicatorView.swift
//  MLworkshop
//
//  Created by wahaj on 09/06/2022.
//

import Foundation
import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable{
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView(style: .large)
        v.color = .green
        v.startAnimating()
        return v
    }
    typealias UIViewType = UIActivityIndicatorView

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
    
    
}

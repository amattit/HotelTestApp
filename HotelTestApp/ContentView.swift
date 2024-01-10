//
//  ContentView.swift
//  HotelTestApp
//
//  Created by Михаил Серегин on 09.01.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HotelView(viewModel: .init())
    }
}

#Preview {
    ContentView()
}

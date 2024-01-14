//
//  XmarkButton.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 14/1/24.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.presentationMode) var presendationMode

    var body: some View {
        Button(action: {
            presendationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XmarkButton()
}

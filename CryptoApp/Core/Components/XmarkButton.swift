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


struct XmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        
        XmarkButton()
        
    }
}

//
//  SearchBarVIew.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 10/1/24.
//

import SwiftUI

struct SearchBarVIew: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor( searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            TextField("Search...", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x:10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                    
                    ,alignment: .trailing
                        
                )

        }.font(.headline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.theme.background)
                    .shadow(
                        color: Color.theme.accent.opacity(0.25),
                        radius: 10, x: 0, y: 0)
            )
            .padding()
    }
}

struct SearchBarVIew_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarVIew(searchText: .constant(""))
    }
}

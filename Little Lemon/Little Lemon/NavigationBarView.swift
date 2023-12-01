//
//  NavigationBarView.swift
//  Little Lemon
//
//  Created by Ezer Isai Angeles on 11/30/23.
//

import SwiftUI

struct NavigationBarView: View {
    var body: some View {
        HStack{
            Spacer()
            Image("logo")
                .resizable()
                .frame(width: 180, height: 40)
                .padding(.leading, 40)
                .padding(.bottom, 10)
            Spacer()
            Image("profile-image-placeholder")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.trailing, 20)
                .padding(.bottom, 10)
        }.background(Color(hex: "FFFFFF"))
    }
}

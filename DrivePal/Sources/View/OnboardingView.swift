//
//  Onboarding.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(I18N.precautionTitle)
                    .font(.largeTitle)
            Text(I18N.precautionContent[0])
                    .font(.system(size: 15))
            VStack(alignment: .leading, spacing: 10) {
                Text(I18N.precautionContent[1])
                Text(I18N.precautionContent[2])
            }
            Image(.setPhoneOnHolder)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding()
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

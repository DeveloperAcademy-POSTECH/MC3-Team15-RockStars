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
                    Text("사용시 유의사항")
                        .font(.largeTitle)
                    Text("Drive Pal은 휴대폰의 움직임을 매우 예민하게 감지해요.")
                        .font(.system(size: 15))
            VStack(alignment: .leading, spacing: 10) {
                Text("1. 따라서 데이터는 휴대폰 조작만으로 바뀔 수 있으니 **참고용**으로 보세요.")
                Text("2. **반드시 거치대에 설치한 후 시작**해 주세요.")
            }
            Image("setPhoneOnHolder")
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

//
//  AuthorizationRequestView.swift
//  DrivePal
//
//  Created by Gucci on 2023/08/15.
//

import SwiftUI

struct AuthorizationRequestView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("원활한 DrivePal 사용을 위한\n접근 권한 안내")
                .font(.title2)
            
            Section {
                AuthorizationView(.location)
                    .padding(.top, 1)
            } header: {
                Text("필수 접근 권한")
                    .sectionHeaderStyle()
            }
                 
            Section {
                AuthorizationView(.notification)
                    .padding(.top, 1)
            } header: {
                Text("선택적 접근 권한")
                    .sectionHeaderStyle()
            }
            
            Spacer()
            
            Button(role: .destructive) {
                requestAuthorizations()
            } label: {
                Text("설정하기")
                    .font(.title3.bold())
                    .frame(width: UIScreen.main.bounds.width-64)
            }
            .tint(.blue)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
        }
        .padding(.vertical, 16)
    }
    
    private func requestAuthorizations() {
        
    }
}

struct AuthorizationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationRequestView()
    }
}

private struct AuthorizationView: View {
    private let authorization: Authorization
    
    fileprivate init(_ authorization: Authorization) {
        self.authorization = authorization
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: authorization.systemImage)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text(authorization.text)
                    .font(.headline.bold())
                Text(authorization.description)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
        }
    }
}

private enum Authorization {
    case location, notification
    
    var systemImage: String {
        switch self {
        case .location:
            return "location.fill"
        case .notification:
            return "bell.fill"
        }
    }
    
    var text: String {
        switch self {
        case .location:
            return "위치"
        case .notification:
            return "알림"
        }
    }
    
    var description: String {
        switch self {
        case .location:
            return "실시간 속도 분석, 현재 위치 정보 접근"
        case .notification:
            return "다이나믹 아일랜드에 정보 표시"
        }
    }
}

// Section { } header: { } 방식으로 선언될 때 사용
private struct SectionHeader: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(.primary)
            .padding(.top, 30)
    }
}

private extension View {
    func sectionHeaderStyle() -> some View {
        modifier(SectionHeader())
    }
}

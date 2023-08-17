//
//  AuthorizationRequestView.swift
//  DrivePal
//
//  Created by Gucci on 2023/08/15.
//

import SwiftUI

struct AuthorizationRequestView: View {
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var locationHandler: LocationsHandler
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(I18N.authTitle)
                .font(.title2)
            
            Section {
                AuthorizationView(.location)
                    .padding(.top, 1)
            } header: {
                Text(I18N.essestialAuth)
                    .sectionHeaderStyle()
            }
                 
            Section {
                AuthorizationView(.notification)
                    .padding(.top, 1)
            } header: {
                Text(I18N.optionalAuth)
                    .sectionHeaderStyle()
            }
            
            Spacer()
            
            Button(role: .destructive) {
                requestAuthorizations()
            } label: {
                Text(I18N.btnSetAuth)
                    .font(.title3.bold())
                    .frame(width: UIScreen.width-64)
            }
            .tint(.blue)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
        }
        .padding(.vertical, 16)
    }
    
    private func requestAuthorizations() {
        locationHandler.requestAuthorization()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
            dismiss()
        }
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
            return .locationFill
        case .notification:
            return .bellFill
        }
    }
    
    var text: String {
        switch self {
        case .location:
            return I18N.wordLocation
        case .notification:
            return I18N.wordNotification
        }
    }
    
    var description: String {
        switch self {
        case .location:
            return I18N.locationDescription
        case .notification:
            return I18N.notificationDescription
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

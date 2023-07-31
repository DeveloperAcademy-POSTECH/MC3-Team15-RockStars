//
//  ResultAnalysisView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/19.
//

import SwiftUI

struct ResultAnalysisView: View {
    @Binding var showResultAnalysisView: Bool
    @EnvironmentObject var model: LiveActivityModel
    
    private var isGoodResult: Bool {
        return model.currentState.count < 4
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(isGoodResult ? .palImageInGoodResult : .palImageInBadResult)
                .resizable()
                .scaledToFit()
                .frame(width: 330)
            
            Text(isGoodResult ? I18N.wordsFromGoodResult : I18N.wordsFromBadResult)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(.wordsFromResultColor)
                .opacity(0.85)
                .padding(.top, 30)
            
            HStack {
                ResultDataBoxView(dataBackgroundColor: isGoodResult ? .dataGoodValueBackgroundColor : .dataBadValueBackgroundColor,
                                  dataValue: model.currentState.count,
                                  dataInText: I18N.warningTextLA,
                                  isDrivingTimeData: false)
                ResultDataBoxView(dataBackgroundColor: .black,
                                  dataValue: model.currentState.timestamp / 60,
                                  dataInText: I18N.drivingTimeTextLA,
                                  isDrivingTimeData: true)
            }
            .padding(.top, 46)
            Spacer()
            HStack {
                Spacer()
                Button {
                    share()
                } label: {
                    Image(systemName: .sfShare)
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .semibold))
                        .padding([.bottom, .trailing], 30)
                }
            }
        }
        .background {
            Image(isGoodResult ? .backgroundInGoodResult : .backgroundInBadResult)
                .resizable()
                .scaledToFill()
        }
    }
}

// MARK: - 현재 화면을 캡쳐해 공유하기 위한 익스텐션들
extension UIView {
    var screenshot: UIImage {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return capturedImage
    }
}

extension View {
    func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.screenshot
    }
}
extension ResultAnalysisView {
    func share() {
        let screenshot = body.takeScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(activityViewController, animated: true)
    }
}

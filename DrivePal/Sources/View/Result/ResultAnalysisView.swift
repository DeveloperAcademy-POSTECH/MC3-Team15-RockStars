//
//  ResultAnalysisView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/19.
//

import SwiftUI

struct ResultAnalysisView: View {
    
    private enum ResultType {
        case perfect    // 부주의 횟수 0회
        case good       // 부주의 횟수 1회 이상 3회 이하
        case bad        // 부주의 횟수 4회 이상
    }
    @Binding var showResultAnalysisView: Bool
    @EnvironmentObject var model: LiveActivityModel
    
    private var resultText: String {
        if model.currentState.count > 0 {
            if model.currentState.suddenStopCount > 0,
               model.currentState.suddenAccelerationCount > 0 {
                return I18N.wordsFromBothWarnings.randomElement() ?? I18N.wordsFromBadResult
            } else if model.currentState.suddenStopCount == 0 {
                return I18N.wordsFromOnlySuddenDeceleration.randomElement() ?? I18N.wordsFromBadResult
            } else if model.currentState.suddenAccelerationCount == 0 {
                return I18N.wordsFromOnlySuddenAcceleration.randomElement() ?? I18N.wordsFromBadResult
            }
        }
        return I18N.wordsFromNoWarning.randomElement() ?? I18N.wordsFromGoodResult
    }
    
    private var resultType: ResultType {
        if model.currentState.count == 0 { return .perfect }
        return model.currentState.count < 4 ? .good : .bad
    }
    
    private var isResultPerfect: Bool {
        resultType == .perfect
    }
    
    private var palImageName: String {
        if isResultPerfect { return .palImageInPerfectResult }
        return resultType == .good ? .palImageInGoodResult : .palImageInBadResult
    }
    
    private var dataBackgroundColor: Color {
        return resultType == .bad ? .dataBadValueBackgroundColor : .dataGoodValueBackgroundColor
    }
    
    private var backgroundImageName: String {
        if isResultPerfect { return .backgroundInPerfectResult }
        return resultType == .good ? .backgroundInGoodResult : .backgroundInBadResult
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 150)
            Image(palImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 330)
            
            Text(resultText)
                .font(.system(size: isResultPerfect ? 36 : 26,
                              weight: isResultPerfect ? .bold : .semibold))
                .foregroundColor(.wordsFromResultColor)
                .opacity(isResultPerfect ? 1.0 : 0.85)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .shadow(radius: isResultPerfect ? 3.0 : 0.0)
            
            HStack(alignment: .top, spacing: 10) {
                VStack(spacing: 10) {
                    if isResultPerfect {
                        ResultDataBoxView(dataBackgroundColor: dataBackgroundColor,
                                          dataValue: "👍",
                                          dataInText: "Perfect",
                                          isDrivingTimeData: false)
                    } else {
                        ResultDataBoxView(dataBackgroundColor: dataBackgroundColor,
                                          dataValue: model.currentState.suddenAccelerationCount.description,
                                          dataInText: I18N.wordSuddenAcceleration,
                                          isDrivingTimeData: false)
                        ResultDataBoxView(dataBackgroundColor: dataBackgroundColor,
                                          dataValue: model.currentState.suddenStopCount.description,
                                          dataInText: I18N.wordSuddenDeceleration,
                                          isDrivingTimeData: false)
                    }
                }
                ResultDataBoxView(dataBackgroundColor: .black,
                                  dataValue: (model.currentState.timestamp / 60).description,
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
                Image(backgroundImageName)
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

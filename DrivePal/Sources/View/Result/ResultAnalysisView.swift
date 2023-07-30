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
        //        return model.currentState.count < 4
        return true
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
                                  //                                      dataValue: model.currentState.count,
                                  dataValue: 2,
                                  dataInText: I18N.warningTextLA,
                                  isDrivingTimeData: false)
                ResultDataBoxView(dataBackgroundColor: .black,
                                  //                                  dataValue: model.currentState.timestamp / 60,
                                  dataValue: 79,
                                  dataInText: I18N.drivingTimeTextLA,
                                  isDrivingTimeData: true)
            }
            .padding(.top, 46)
            
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    // TODO: - 공유기능 구현
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

extension ResultAnalysisView {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

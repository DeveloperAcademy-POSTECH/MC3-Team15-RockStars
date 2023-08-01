//
//  DynamicInformView.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/31.
//

import SwiftUI

struct DynamicInformView: View {
    
    @Binding var motionStatus: MotionStatus
    @State private var isShrunk = false
    
    var body: some View {
        VStack {
                RoundedRectangle(cornerRadius: 40)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .frame(height: UIScreen.height / 6)
                    .overlay {
                        Text(I18N.informDynamicIsland)
                            .multilineTextAlignment(.center)
                            .frame(alignment: .center)
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .scaleEffect(x: isShrunk ? 0.3 : 1.0,
                                 y: isShrunk ? 0.2 : 1.0,
                                 anchor: .top)
                    .offset(y: isShrunk ? 20 : 60)
                    .animation(.easeOut(duration: 0.5), value: isShrunk)
                    .onAppear(perform: shrink)
            Spacer()
        }
    }
    
    func shrink() {
        guard !isShrunk else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                isShrunk.toggle()
            }
        }
    }
}

struct DynamicInfromView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicInformView(motionStatus: .constant(.normal))
    }
}

//
//  ProgressRingView.swift
//  FocusFlowApp
//
//  Created by Natchanon Posayaanuwat on 31/5/2569 BE.
//

import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray.opacity(0.2), lineWidth: 14)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    .blue,
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.title2.bold())
        }
        .frame(width: 120, height: 120)
    }
}

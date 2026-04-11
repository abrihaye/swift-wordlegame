//
//  ElapsedTimeView.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-04-11.
//

import SwiftUI

struct ElapsedTimeView: View {
    let startTime: Date?
    let endTime: Date?
    let elapsedTime: TimeInterval
    
    var format: SystemFormatStyle.DateOffset {
        .offset(to: startTime! - elapsedTime, allowedFields: [.minute, .second])
    }
    var body: some View {
        if startTime != nil {
            if let endTime {
                Text(endTime, format: format)
            } else {
                Text(TimeDataSource<Date>.currentDate, format: format)
            }
        } else {
            Image(systemName: "pause")
        }
    }
}

//#Preview {
//    ElapsedTimeView()
//}

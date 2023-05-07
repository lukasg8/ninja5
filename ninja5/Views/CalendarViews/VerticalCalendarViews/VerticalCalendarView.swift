//
//  VerticalCalendarView.swift
//  ninja5
//
//  Created by Lukas on 5/6/23.
//

import SwiftUI

struct VerticalCalendarView: View {
    
    @EnvironmentObject var manager: DataManager
    @EnvironmentObject var dateHolder: DateHolder
    
    let daysToLoad = 500
    
    var body: some View {
        ScrollViewReader { scrollView in
            VStack(alignment: .leading) {
                Text("Calendar")
                    .bold()
                calendarStack()
                    .onAppear {
                        let currentDateIndex = daysToLoad
                        DispatchQueue.main.async {
                            scrollView.scrollTo(currentDateIndex, anchor: .top)
                        }
                    }
            }
        }
    }
    
    func calendarStack() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(0..<2 * daysToLoad) { index in
                    let dayOffset = index - daysToLoad
                    VStack {
                        if let dayDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) {
                            Text(dateString(from: dayDate))
                                .font(.system(size:30))
                                .bold()
                            let tasksForDay = manager.tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: dayDate) }
                            ForEach(tasksForDay) { task in
                                Text(task.title)
                            }
                        } else {
                            Text("Can't load tasks")
                        }
                    }
                    .id(index)
                }
            }
        }
    }
    
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE MMM d yy"
        return formatter.string(from: date)
    }
}

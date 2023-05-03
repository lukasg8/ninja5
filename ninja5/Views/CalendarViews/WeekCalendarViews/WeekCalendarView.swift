//
//  WeekCalendarView.swift
//  ninja5
//
//  Created by Lukas on 5/1/23.
//

import SwiftUI

struct WeekCalendarView: View {

    @EnvironmentObject var dateHolder: DateHolder
    @EnvironmentObject var manager: DataManager
    
    @State private var displayedMonth: String = ""
//    @State var tasks: [Task] = []
    @State private var showingTaskCreationView: Bool = false
    
    let daysInWeek: Int = 7
    let weeksToLoad = 100
    let folders: [Folder]

    var body: some View {
        ScrollViewReader { scrollView in
            VStack (spacing:0) {
                HStack {
                    Text(displayedMonth)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    Button(action: {
                        showingTaskCreationView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.accentColor)
                    }
                    .padding(.trailing)
                    
                    Button(action: {
                        scrollView.scrollTo(0, anchor:.leading)
                    }) {
                        Text("Today")
                            .foregroundColor(.accentColor)
                    }
                    .padding(.trailing)
                }
                .padding(.bottom,0)
                
                calendarGrid()
                    .frame(height:170)
                    .onAppear {
                        scrollView.scrollTo(0, anchor:.leading)
                    }

            }
            .sheet(isPresented: $showingTaskCreationView) {
                TaskCreationView(folders: folders) { newTask in
//                    tasks.append(newTask)
                    manager.addTask(task: newTask)
                }
        }
        }
    }
    
    func calendarGrid() -> some View {
        GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 1) {
                        ForEach(-weeksToLoad..<weeksToLoad) { weekOffset in
                            
                            let weekDate = Calendar.current.date(byAdding: .weekOfYear, value: weekOffset, to: CalendarHelper().mondayOfCurrentWeek(dateHolder.date))!
                            
                            Week(geo: geo, weekDate: weekDate)
                                .frame(width: geo.size.width, height: geo.size.height)
                                .environmentObject(dateHolder)
                                .id(weekOffset)
                                .onAppear {
                                    if weekOffset >= dateHolder.currentWeekIndex {
                                        dateHolder.currentWeekIndex += weeksToLoad
                                    } else if weekOffset <= -dateHolder.currentWeekIndex {
                                        dateHolder.currentWeekIndex -= weeksToLoad
                                    }

                                    let weekOnScreen = Int((geo.frame(in: .global).minX) / geo.size.width)
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMMM YYYY"
                                    let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: weekDate)!
                                    displayedMonth = dateFormatter.string(from: nextWeekDate)
                                }
                        }
                    }
                }
        }
    }


    private func Week(geo: GeometryProxy, weekDate: Date) -> some View {
        HStack(spacing: 1) {
            ForEach(0..<daysInWeek) { dayOffset in
                let dayDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: weekDate)!
//                let tasksForDay = tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: dayDate) }
                let tasksForDay = manager.tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: dayDate) }
                WeekCalendarCellView(date: dayDate, tasks: tasksForDay)
                    .environmentObject(dateHolder)
                    .frame(width: geo.size.width / 7)
            }
        }
    }
    
    private func scrollToToday() {
        dateHolder.currentWeekIndex = 0
    }
}


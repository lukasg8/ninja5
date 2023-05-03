//
//  MonthCalendarView.swift
//  ninja5
//
//  Created by Lukas on 5/1/23.
//

import SwiftUI

struct MonthCalendarView: View
{
    @EnvironmentObject var dateHolder: DateHolder
    @EnvironmentObject var manager: DataManager
    
    var body: some View
    {
        VStack(spacing: 1)
        {
            MonthDateScrollerView()
                .environmentObject(dateHolder)
                .padding()
            dayOfWeekStack
                .padding(.bottom,3)
            Divider()
            calendarGrid
        }
    }
    
    var dayOfWeekStack: some View
    {
        HStack(spacing: 1)
        {
            Text("Sun").dayOfWeek()
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
        }
    }
    
    var calendarGrid: some View
    {
        
        VStack(spacing: 1)
        {
            let daysInMonth = CalendarHelper().daysInMonth(dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(dateHolder.date)
            let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
            let prevMonth = CalendarHelper().minusMonth(dateHolder.date)
            let daysInPrevMonth = CalendarHelper().daysInMonth(prevMonth)
            
            ForEach(0..<6)
            {
                row in
                HStack(alignment:.top, spacing: 1)
                {
                    ForEach(1..<8) { column in
                        let count = column + (row * 7)
                        let dayDate = dateForDay(count, startingSpaces: startingSpaces, currentMonth: dateHolder.date)
                        let tasksForDay = manager.tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: dayDate) }
                        MonthCalendarCellView(tasks: tasksForDay, count: count, startingSpaces:startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                            .environmentObject(dateHolder)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

func dateForDay(_ day: Int, startingSpaces: Int, currentMonth: Date) -> Date {
    var components = Calendar.current.dateComponents([.year, .month, .day], from: CalendarHelper().firstOfMonth(currentMonth))
    components.day = day - startingSpaces
    return Calendar.current.date(from: components)!
}

extension Text
{
    func dayOfWeek() -> some View
    {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}


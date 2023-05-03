//
//  MonthCalendarCellView.swift
//  ninja5
//
//  Created by Lukas on 5/1/23.
//

import SwiftUI

struct MonthCalendarCellView: View {
    @EnvironmentObject var dateHolder: DateHolder
    let tasks: [Task]
    let count : Int
    let startingSpaces : Int
    let daysInMonth : Int
    let daysInPrevMonth : Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(monthStruct().day())
                    .foregroundColor(textColor(type: monthStruct().monthType))
                    .padding(.trailing)
                    .padding(.top,4)
                Spacer().frame(width: 4)
            }
            taskList()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func taskList() -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                ForEach(tasks) { task in
                    Text(task.title)
                        .padding(.leading)
                        .font(.footnote)
                        .foregroundColor(Color(.label))
                        .lineLimit(1)
                }
            }
        }
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black : Color.gray
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        if(count <= start) {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        }
        else if (count - start > daysInMonth) {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
}

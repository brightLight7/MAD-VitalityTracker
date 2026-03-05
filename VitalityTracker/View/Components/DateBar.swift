//
//  HabitDateBarView.swift
//  VitalityTracker
//
//  Created by Abdullah Sajid on 05/03/2026.
//
import SwiftUI
import SwiftData

struct DateBar: View
{
    @Binding var viewingDate: Date
    let isToday: Bool
    let dateTitle: String
    var body: some View
    {
        HStack(spacing: 12)
        {
            Button
            {
                viewingDate = Calendar.current.date(byAdding: .day, value: -1, to: viewingDate) ?? viewingDate
            } label:
            {
                Image(systemName: "chevron.left")
                Text("Prev")
            }
            
            Spacer()
            
            VStack(spacing: 2)
            {
                Text(dateTitle).font(.headline)
                if !isToday
                {
                    Text("Read-only").font(.caption).foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Button
            {
                viewingDate = Calendar.current.date(byAdding: .day, value: 1, to: viewingDate) ?? viewingDate
            } label:
            {
                Text("Next")
                Image(systemName: "chevron.right")
            }
            .disabled(isToday)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
}

//
//  DailyLog.swift
//  VitalityTracker
//
//  Created by Abdullah Sajid on 17/02/2026.
//

import Foundation

struct DailyLog: Identifiable, Codable
{
    var id: UUID = UUID()
    let date: Date
    var IDs_completedHabit: Set<UUID>
    
    
}



//
//  RecurrenceOutputBuilder.swift
//  CareCal
//
//  Created by Dustin Spengler on 8/20/16.
//  Copyright © 2016 Dustin Spengler. All rights reserved.
//

import Foundation
import EventKit

struct EventOutputBuilder {
    
    let formatter = DateFormatter()
    
    func constructRecurrenceOutputLabel(_ recurrenceRules : [EKRecurrenceRule], completeSentence: Bool) -> String? {
        
        let firstRecurrenceRule = recurrenceRules[0]
        var recurrenceOutputText : String
        if completeSentence {
            recurrenceOutputText = "Event will occur every "
        } else {
            recurrenceOutputText = ""
        }
        recurrenceOutputText.append(self.recurrenceRuleSelectedIntervalDescription(firstRecurrenceRule))
        
        switch firstRecurrenceRule.frequency {
        case .daily:
            return recurrenceOutputText
        case .weekly:
            recurrenceOutputText.append("on ")
            recurrenceOutputText.append(self.recurrenceRuleDaysOfWeekDescription(firstRecurrenceRule))
            
            return recurrenceOutputText
        case .monthly:
            recurrenceOutputText.append(recurrenceRuleDaysOfMonthDescription(firstRecurrenceRule))
            recurrenceOutputText.append(self.recurrenceRuleDaysOfWeekDescription(firstRecurrenceRule))
            recurrenceOutputText.append(self.recurrenceRuleMonthsOfYearDescription(firstRecurrenceRule))
            
            return recurrenceOutputText
        default:
            recurrenceOutputText.append(self.recurrenceRuleDaysOfWeekDescription(firstRecurrenceRule))
            recurrenceOutputText.append(self.recurrenceRuleMonthsOfYearDescription(firstRecurrenceRule))
        }
        return recurrenceOutputText
        
    }
    
    
    func recurrenceRuleDaysOfWeekDescription(_ recurrenceRule : EKRecurrenceRule) -> String {
        var daysOfWeekOutputText = ""
        
        if let daysOfWeek = recurrenceRule.daysOfTheWeek {
            
            if recurrenceRule.frequency == .monthly || recurrenceRule.frequency == .yearly {
                print("event set position count: \(String(describing: recurrenceRule.setPositions?.count))")
                print("event set position number is: \(String(describing: recurrenceRule.setPositions?[0]))")
                
                daysOfWeekOutputText.append(self.recurrenceRuleSetPositionDescription(recurrenceRule))
            }
            
            let monday = EKRecurrenceDayOfWeek(.monday)
            let tuesday = EKRecurrenceDayOfWeek(.tuesday)
            let wednesday = EKRecurrenceDayOfWeek(.wednesday)
            let thursday = EKRecurrenceDayOfWeek(.thursday)
            let friday = EKRecurrenceDayOfWeek(.friday)
            let saturday = EKRecurrenceDayOfWeek(.saturday)
            let sunday = EKRecurrenceDayOfWeek(.sunday)
            
            if daysOfWeek.count == 7 {
                
                daysOfWeekOutputText.append("day ")
                
            } else if daysOfWeek.contains(monday) &&
                daysOfWeek.contains(tuesday) &&
                daysOfWeek.contains(wednesday) &&
                daysOfWeek.contains(thursday) &&
                daysOfWeek.contains(friday) &&
                !daysOfWeek.contains(saturday) &&
                !daysOfWeek.contains(sunday) {
                
                if recurrenceRule.frequency == .weekly {
                    daysOfWeekOutputText.append("every ")
                }
                
                daysOfWeekOutputText.append("weekday ")
                
            } else if daysOfWeek.contains(saturday) &&
                daysOfWeek.contains(sunday) &&
                !daysOfWeek.contains(monday) &&
                !daysOfWeek.contains(tuesday) &&
                !daysOfWeek.contains(wednesday) &&
                !daysOfWeek.contains(thursday) &&
                !daysOfWeek.contains(friday)    {
                
                if recurrenceRule.frequency == .weekly {
                    daysOfWeekOutputText.append("every ")
                }
                
                daysOfWeekOutputText.append("weekend day ")
                
            } else {
                var index = 0
                
                while index < daysOfWeek.count {
                    daysOfWeekOutputText.append(daysOfWeek[index].dayOfTheWeek.stringValue())
                    
                    if daysOfWeek.count == index + 2 {
                        daysOfWeekOutputText.append(" and ")
                    } else if daysOfWeek.count == index + 1 {
                        daysOfWeekOutputText.append(" ")
                    } else {
                        daysOfWeekOutputText.append(", ")
                    }
                    
                    index+=1
                }
            }
        }
        return daysOfWeekOutputText
    }
    
    func recurrenceRuleDaysOfMonthDescription(_ recurrenceRule : EKRecurrenceRule) -> String {
        var daysOfMonthOutput : String = ""
        if let daysOfMonth = recurrenceRule.daysOfTheMonth {
            if daysOfMonth.count > 0 {
                if daysOfMonth.count == 31 {
                    daysOfMonthOutput.append("for the entire month.")
                } else {
                    var index = 0
                    daysOfMonthOutput.append("on the ")
                    while index < daysOfMonth.count {
                        let dayOfMonthString = self.appendEndingToNumber(NSNumber(value: daysOfMonth[index].intValue))
                        daysOfMonthOutput.append(dayOfMonthString)
                        if daysOfMonth.count >= 2 {
                            if daysOfMonth.count == index + 2 {
                                daysOfMonthOutput.append(" and ")
                            } else if daysOfMonth.count == index + 1 {
                                daysOfMonthOutput.append(".")
                            } else {
                                daysOfMonthOutput.append(", ")
                            }
                        } else {
                            daysOfMonthOutput.append(".")
                        }
                        index+=1
                    }
                }
            }
        }
        return daysOfMonthOutput
    }
    
    func recurrenceRuleMonthsOfYearDescription(_ recurrenceRule : EKRecurrenceRule) -> String {
        var monthsOfYearOutputText = ""
        
        if let monthsofYear = recurrenceRule.monthsOfTheYear {
            if monthsofYear.count == 12 {
                if recurrenceRule.daysOfTheWeek != nil {
                    monthsOfYearOutputText.append("of every month")
                }
            } else {
                if recurrenceRule.frequency == .monthly || recurrenceRule.frequency == .yearly {
                    monthsOfYearOutputText.append("in ")
                    
                    var monthsIndex = 0
                    while monthsIndex < monthsofYear.count {
                        let months = formatter.standaloneMonthSymbols
                        monthsOfYearOutputText.append(months![monthsofYear[monthsIndex].intValue - 1 ])
                        
                        if monthsofYear.count >= 2 {
                            if monthsofYear.count == monthsIndex + 2 {
                                monthsOfYearOutputText.append(" and ")
                            }else if monthsofYear.count == monthsIndex + 1 {
                                monthsOfYearOutputText.append(".")
                            } else {
                                monthsOfYearOutputText.append(", ")
                            }
                        } else {
                            monthsOfYearOutputText.append(".")
                        }
                        monthsIndex+=1
                    }
                }
            }
        }
        return monthsOfYearOutputText
    }
    
    
    func recurrenceRuleSetPositionDescription(_ recurrenceRule : EKRecurrenceRule) -> String {
        var setPositionOutputtext = ""
        if let setPosition = recurrenceRule.setPositions?[0] {
            setPositionOutputtext.append("on the ")
            if setPosition == -1 {
                setPositionOutputtext.append("last ")
            } else {
                setPositionOutputtext.append("\(self.appendEndingToNumber(setPosition)) ")
            }
        } else if let daysOfWeek = recurrenceRule.daysOfTheWeek {
            setPositionOutputtext.append("on the ")
            if daysOfWeek[0].weekNumber == -1 {
                setPositionOutputtext.append("last ")
            } else {
                setPositionOutputtext.append("\(self.appendEndingToNumber(NSNumber(value: daysOfWeek[0].weekNumber))) ")
            }
        } else {
            setPositionOutputtext.append("")
        }
        
        return setPositionOutputtext
    }
    
    
    func constructAttendeesOutput(_ attendees : [String]) -> String {
        let attendeeCellLabel = self.constructArrayOutput(attendees)
        return attendeeCellLabel
    }
    
    
    func appendEndingToNumber(_ number: NSNumber) -> String {
        var dayNumberString = "\(number)"
        
        if dayNumberString == "11" || dayNumberString == "12" || dayNumberString == "13"  {
            dayNumberString.append("th")
            
        } else {
            let dayChar = dayNumberString.characters.last!
            
            switch dayChar {
            case "1":
                dayNumberString.append("st")
            case "2":
                dayNumberString.append("nd")
            case "3":
                dayNumberString.append("rd")
            default:
                dayNumberString.append("th")
            }
        }
        return dayNumberString
    }
    
    func constructAlarmLabels(_ alarm : EKAlarm) -> String {
        
        var alarmLabel : String = ""
        
        switch alarm.relativeOffset {
        case 0:
            alarmLabel.append("At time of event")
        case -300:
            alarmLabel.append("5 minutes before")
        case -600:
            alarmLabel.append("10 minutes before")
        case -900:
            alarmLabel.append("15 minutes before")
        case -1800:
            alarmLabel.append("30 minutes before")
        case -3600:
            alarmLabel.append("1 hour before")
        case -7200:
            alarmLabel.append("2 hours before")
        case -86400:
            alarmLabel.append("1 day before")
        case -172800:
            alarmLabel.append("2 days before")
        case -604800:
            alarmLabel.append("1 week before")
        default:
            let outputLabel = String(format: "%.0f", (alarm.relativeOffset / 60) * -1)
            alarmLabel.append("\(outputLabel) minutes before")
        }
        
        return alarmLabel
    }
    
    func recurrenceRuleSelectedIntervalDescription(_ recurrenceRule : EKRecurrenceRule) -> String {
        var selectedIntervalOutput : String = ""
        
        switch recurrenceRule.frequency {
        case .daily:
            if recurrenceRule.interval > 1 {
                selectedIntervalOutput.append("\(recurrenceRule.interval) days ")
            } else {
                selectedIntervalOutput.append("day ")
            }
        case .weekly:
            if recurrenceRule.interval > 1 {
                selectedIntervalOutput.append("\(recurrenceRule.interval) weeks ")
            } else {
                selectedIntervalOutput.append("week ")
            }
        case .monthly:
            let setPositionText = self.recurrenceRuleSetPositionDescription(recurrenceRule)
            
            if setPositionText == "" {
                if recurrenceRule.interval > 1 {
                    selectedIntervalOutput.append("\(recurrenceRule.interval) months ")
                } else {
                    selectedIntervalOutput.append("month ")
                }
            } else {
                if recurrenceRule.interval > 1 {
                    selectedIntervalOutput.append("\(recurrenceRule.interval) years ")
                } else {
                    selectedIntervalOutput.append("year ")
                }
            }
        default:
            if recurrenceRule.interval > 1 {
                selectedIntervalOutput.append("\(recurrenceRule.interval) years ")
            } else {
                selectedIntervalOutput.append("year ")
            }
        }
        return selectedIntervalOutput
    }
    
    func travelTimeToString(_ travelTime : Int) -> String {
        var travelTimeString : String
        switch travelTime {
        case 300 :
            travelTimeString = "5 minutes"
        case 900 :
            travelTimeString = "15 minutes"
        case 1800 :
            travelTimeString = "30 minutes"
        case 3600 :
            travelTimeString = "1 hour"
        case 5400 :
            travelTimeString = "1 hour and 30 minutes"
        case 7200 :
            travelTimeString = "2 hours"
        default:
            travelTimeString = "\(travelTime/3600) hours"
        }
        return travelTimeString
    }
    
    func constructArrayOutput(_ array : [String]) -> String {
        
        var index = 0
        var output : String = ""
        while index < array.count {
            let item = array[index]
            output.append("\(item)")
            
            if index == array.count - 2 {
                output.append(" and ")
            } else if index != array.count - 1 {
                output.append(", ")
            }
            index += 1
        }
        return output
    }
    
    
}

extension EKWeekday {
    func stringValue() -> String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        default:
            return "Sunday"
        }
    }
    
    func IntValue() -> Int {
        switch self {
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        default:
            return 1
        }
    }
}

extension EKRecurrenceFrequency {
    func stringVersion() -> String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        default:
            return "Yearly"
        }
    }
}

let eventOutputBuilder = EventOutputBuilder()
let recurrenceRule = EKRecurrenceRule(recurrenceWith: .monthly,
                                      interval: 2,
                                      daysOfTheWeek: nil,
                                      daysOfTheMonth: [4, 5, 19, 21],
                                      monthsOfTheYear: nil,
                                      weeksOfTheYear: nil,
                                      daysOfTheYear: nil,
                                      setPositions: nil,
                                      end: nil)
let recurrenceRuleOutput = eventOutputBuilder.constructRecurrenceOutputLabel([recurrenceRule], completeSentence: true)
print("\(recurrenceRuleOutput!)")


//let eventOuput = eventOutputBuilder.
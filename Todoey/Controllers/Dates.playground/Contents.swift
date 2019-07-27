import UIKit

var str = "Hello, playground"


let currentDateTime = Date()
print(currentDateTime)
let date = NSDate()
print(date)

type(of: date)


let formatter = DateFormatter()
formatter.dateFormat = "yyyy/MM/dd HH:mm"
let someDateTime = formatter.string(for: date)
print(someDateTime as Any)

let createdDateTime = formatter.string(for: NSDate())
print(createdDateTime!)


//let calendar = NSCalendar.current()
//let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
//let hour = components.hour
//let minutes = components.minute

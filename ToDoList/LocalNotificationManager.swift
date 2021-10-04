//
//  LocalNotificationManager.swift
//  ToDoList
//
//  Created by Connor Goodman on 10/3/21.
//

import UserNotifications
import UIKit

struct LocalNotificationsManager{
     static func authorizeLocalNotifications(viewController: UIViewController){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
            guard error == nil else{
                print("Error: \(error!.localizedDescription)")
                return
            }
            if granted {
                print("✅ Notifications Authorization Granted")
            }
            else{
                 print("❌ The user has denied notification authorization")
                DispatchQueue.main.async {
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open Settings, select To Do List > Notifications > Allow Notifications.")
                }
            }
        }
    }
    
    static func isAuthorized(completed: @escaping (Bool) -> () ){
       UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
           guard error == nil else{
               print("Error: \(error!.localizedDescription)")
               completed(false)
               return
           }
           if granted {
               print("✅ Notifications Authorization Granted")
               completed(true)
           }
           else{
               print("❌ The user has denied notification authorization")
               completed(false)
           }
       }
   }
     
     static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound, date: Date) -> String {
         // create content:
         let content = UNMutableNotificationContent()
         content.title = title
         content.subtitle = subtitle
         content.body = body
         content.sound = sound
         content.badge = badgeNumber
         
         // create trigger:
         var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
         dateComponents.second = 00
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
         
         // create request:
         let notificationID = UUID().uuidString
         let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
         
         // register request with notification center
         UNUserNotificationCenter.current().add(request) { error in
             if let error = error{
                 print("Error \(error.localizedDescription)")
             }
             else{
                 print("notification scheduled \(notificationID), title: \(content.title)")
             }
         }
         
         return notificationID
     }
     
     
}

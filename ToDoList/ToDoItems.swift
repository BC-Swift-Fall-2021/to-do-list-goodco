//
//  ToDoItems.swift
//  ToDoList
//
//  Created by Connor Goodman on 10/3/21.
//

import Foundation
import UserNotifications

class ToDoItems {
    var itemsArray: [ToDoItem] = []
    
    func loadData(completed: @escaping ()->() ) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension(".json") // change todos to file name if reused

        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do{
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
        }
        catch{
            print("ERROR: Could not load data \(error.localizedDescription)")
        }
        completed()
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension(".json") // change todos to file name if reused
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray) // change itemsArray to array name if reused
        do{
            try data?.write(to: documentURL, options: .noFileProtection)
        }
        catch{
            print("ERROR: Could not save data \(error.localizedDescription)")
        }
        setNotifications()
    }

    
     func setNotifications(){
        guard itemsArray.count > 0 else{
            return
        }
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            // and let's recreate them with the updated date that we just saved
        for i in 0..<itemsArray.count {
            if itemsArray[i].reminderSet{
                let toDoItem = itemsArray[i]
                itemsArray[i].notificationID = LocalNotificationsManager.setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
    }
    
}

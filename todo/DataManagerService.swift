//
//  DataService.swift
//  todo
//
//  Created by Adam Wlodarczyk on 28/03/2019.
//  Copyright © 2019 Adam Wlodarczyk. All rights reserved.
//

import Foundation
protocol DataManagerService {
    static var shared: DataManagerService! {get}
    var toDoItems: [TodoItem]! {get}
    func getNextId() -> Int
    func addItem(item: TodoItem) -> Void
    func changePriority(priority: Priority, at index: Int) -> Void
    func changeDoneStatus(at index: Int) -> Void
    func removeItem(at index: Int) -> Void
}
class DataManagerServiceImpl: DataManagerService {
    func getNextId() -> Int {
        let tmp = items.sorted{
            $0.id > $1.id
        }
        let current = tmp.first?.id ?? 0
        
        return (current + 1)
    }
    
    private let TODO_KEY = "pl.hindbrain.todo.user-todos"
    static var shared: DataManagerService! = DataManagerServiceImpl()
    var items: [TodoItem] = []
    var toDoItems: [TodoItem]! {
        get{
           return items
        }
    }
    private func storeIntoUserDefault(){
        do{
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(self.items)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: TODO_KEY)
            userDefaults.synchronize()
        
        } catch {
            print("err")
        }
    }
    private init(){
        
        if let data = UserDefaults.standard.data(forKey: TODO_KEY){
            do{
                let container = JSONDecoder()
                let array: [TodoItem] = try container.decode([TodoItem].self, from: data)
                self.items = array
            }catch{
                print("err")
            }
        }
    }
}
extension DataManagerServiceImpl{
    func changeDoneStatus(at index: Int) {
        if let row = self.items.firstIndex(where: {$0.id == index}) {
            self.items[row].done = !self.items[row].done
        }
        storeIntoUserDefault()
    }
    
    func changePriority(priority: Priority, at index: Int) {
        if let row = self.items.firstIndex(where: {$0.id == index}) {
            self.items[row].priority = priority
        }
        storeIntoUserDefault()
    }
    
    func addItem(item: TodoItem) {
        self.items.append(item)
        storeIntoUserDefault()
    }
    func removeItem(at index: Int){
        if let row = self.items.firstIndex(where: {$0.id == index}) {
             self.items.remove(at: row)
        }
        storeIntoUserDefault()
    }
}

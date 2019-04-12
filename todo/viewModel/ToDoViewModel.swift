//
//  ToDoViewModel.swift
//  todo
//
//  Created by Adam Wlodarczyk on 28/03/2019.
//  Copyright © 2019 Adam Wlodarczyk. All rights reserved.
//
import UIKit
import Material
protocol TodoViewModelDelegate{
    func itemsChanged()
}
class TodoViewModel {
    var delegate: TodoViewModelDelegate?
    private let manager: DataManagerService?
    private var items:[ToDoItemViewModel] = []
    var toDoItems:[ToDoItemViewModel]{
        get{
            items.sort {
                if !$0.item.done && $1.item.done {
                    return true
                }
                if $0.item.priority.rawValue > $1.item.priority.rawValue && ($0.item.done == $1.item.done){
                    return true
                }
                if $0.item.priority == $1.item.priority && $0.item.done == $1.item.done {
                    return $0.item.createdAt.compare($1.item.createdAt) == .orderedDescending
                }
                return false
            }
            return items
        }
    }
    init(manager: DataManagerService){
        self.manager = manager
        self.loadData()
    }
    private func loadData(){
        if let _items: [TodoItem] = self.manager?.toDoItems{
            self.items = _items.map{ ToDoItemViewModel(item: $0) }
            
        }else{
            self.items = []
        }
        delegate?.itemsChanged()
    }
}

extension TodoViewModel{
    
    func insert(name:String){
        let item = TodoItem(id: self.manager?.getNextId() ?? 0, name: name, done: false, priority: .normal, createdAt: Date())
        self.manager?.addItem(item: item)
        self.loadData()
    }
    func remove(at index:Int) {
        
        self.manager?.removeItem(at: self.toDoItems[index].item.id)
        self.loadData()
    }
    func changePriority(priority: Priority,at index:Int){
        self.manager?.changePriority(priority: priority,at: self.toDoItems[index].item.id)
        self.loadData()
    }
    func changeDoneStatus(at index:Int) {
        self.manager?.changeDoneStatus(at: self.toDoItems[index].item.id)
        self.loadData()
    }
}

struct ToDoItemViewModel{
    let nameText:NSAttributedString
    let createdAtText: NSAttributedString
    let priorityColor: UIColor
    let removeText: String
    let priorityText: String
    let item:TodoItem
    init(item:TodoItem){
        self.item = item
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        let date = formatter.string(from: item.createdAt as Date)
        var priorityColor:UIColor
        switch item.priority {
        case .urgent:
            priorityColor = Color.red.base
            break
        case .important:
            priorityColor = Color.orange.base
            break
        default:
            priorityColor = Color.lightGreen.base
        }
        self.priorityColor = priorityColor
        
        var attrNameString: NSAttributedString?
        var attrDateString: NSAttributedString?
        if item.done{
            attrNameString = NSAttributedString(string: item.name, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.foregroundColor : UIColor.gray])
            attrDateString = NSAttributedString(string: date, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.foregroundColor : UIColor.gray])
        }else{
            attrNameString = NSAttributedString(string:  item.name, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            
            attrDateString = NSAttributedString(string: date, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        }
        self.nameText = attrNameString!
        self.createdAtText = attrDateString!
        self.removeText = "You want to remove item:\n\n\(item.name)\n\nAre You sure, You want to do this?"
        self.priorityText = "You want to change priority for:\n\n\(item.name)\n"
    }
}

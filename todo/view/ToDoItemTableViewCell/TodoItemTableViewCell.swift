//
//  TodoItemTableViewCell.swift
//  todo
//
//  Created by Adam Wlodarczyk on 27/03/2019.
//  Copyright © 2019 Adam Wlodarczyk. All rights reserved.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {
 
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: ToDoItemViewModel, atIndex:Int){
        indexLabel.text = "\(atIndex+1)"
        nameLabel.attributedText = item.nameText
        dateLabel.attributedText = item.createdAtText
        priorityView.backgroundColor = item.priorityColor
    }
    static func cellFromXib() -> TodoItemTableViewCell{
        let nib = Bundle.main.loadNibNamed(defaultReuseIdentifier(), owner: self, options: nil)! as NSArray
        let cell = nib.object(at: 0) as! TodoItemTableViewCell
        return cell
    }
    static func defaultReuseIdentifier() -> String{
        return "TodoItemTableViewCell"
    }
    static func defaultCellHeight() -> CGFloat{
        return 88.0
    }
}

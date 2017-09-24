//
//  BubbleCollectionViewCell.swift
//  Chat
//
//  Created by Dmitry on 23.09.17.
//  Copyright © 2017 Dmitry. All rights reserved.
//

import UIKit

class BubbleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!    
    @IBOutlet weak var textView: UITextView! 
    @IBOutlet weak var bubbleView: UIView! {
        didSet {
            bubbleView.layer.masksToBounds = true
            bubbleView.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    // Заполняем ячейку
    func fillCell(_ message: Message) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: message.date ?? "")
        dateFormatter.dateFormat = "HH:mm"
        if let date = date {
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        nameLabel.text = message.user
        textView.text = message.text
        
        if let isMine = message.isMine {
            leadingConstraint?.isActive = !isMine
            trailingConstraint?.isActive = isMine
            
            let bubbleColor = isMine ? #colorLiteral(red: 0.2784313725, green: 0.7411764706, blue: 0.3411764706, alpha: 1) : #colorLiteral(red: 0.8978190422, green: 0.8985271454, blue: 0.9185681939, alpha: 1)
            let textColor = isMine ? UIColor.white : UIColor.darkText
            let headerTextColor = isMine ? #colorLiteral(red: 0.6841868162, green: 0.8855811954, blue: 0.7207990289, alpha: 1) : #colorLiteral(red: 0.6117165089, green: 0.6117919087, blue: 0.6116907597, alpha: 1)
            
            dateLabel.textColor = headerTextColor
            nameLabel.textColor = headerTextColor
            textView.textColor = textColor
            bubbleView.backgroundColor = bubbleColor
        }
        
        if let frame = getEstimatedFrame(text: message.text) {
            let nameWidth = getEstimatedFrame(text: nameLabel.text)?.width ?? 50
            let dateWidth = getEstimatedFrame(text: dateLabel.text)?.width ?? 50
            let minWidth = nameWidth + dateWidth + 40
            
            let width = frame.width + 40
            
            widthConstraint.constant = width < minWidth ? minWidth : width
        }        
    }
}

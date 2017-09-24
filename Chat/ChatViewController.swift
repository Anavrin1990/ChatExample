//
//  ChatViewController.swift
//  Chat
//
//  Created by Dmitry on 23.09.17.
//  Copyright © 2017 Dmitry. All rights reserved.
//

import UIKit

struct jsDecoder: Decodable {
    let messages: [Message]
}

struct Message: Decodable {
    var text: String?
    var date: String?
    var isMine: Bool?
    var user: String?
}

class ChatViewController: UIViewController {
    
    var messages = [Message]()    

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Парсим джейсон свифтом 4
        let path = Bundle.main.path(forResource: "messages", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        
        do {
            let decodedData = try JSONDecoder().decode(jsDecoder.self, from: data)
            messages = decodedData.messages
        } catch let error {
            print(error)
        }
        
        let bubbleCell = UINib(nibName: "BubbleCollectionViewCell", bundle: nil)
        collectionView.register(bubbleCell, forCellWithReuseIdentifier: "Cell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Сроллим вниз
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    }
    
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BubbleCollectionViewCell
        let message = messages[indexPath.row]
        cell.fillCell(message)        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 0
        if let frame = getEstimatedFrame(text: messages[indexPath.row].text) {
            height = frame.height + 45
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }    
}

// Получаем размер текста
func getEstimatedFrame(text: String?) -> CGRect? {
    guard let text = text else {return nil}
    let size = CGSize(width: 220, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    
    return estimatedFrame
}

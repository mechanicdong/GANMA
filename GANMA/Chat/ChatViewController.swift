//
//  ChatViewController.swift
//  GANMA
//
//  Created by 이동희 on 2022/05/13.
//

import Foundation
import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType    
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String //added, 여기선 URL말고 String 사용, Profile URL
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    private var selfSender = Sender(photoURL: "",
                                    senderId: "1",
                                    displayName: "이동희")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello World message")))
        
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello World message! OverWatch2 is comming!")))
        
        view.backgroundColor = .green
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}

package com.koreaIT.demo.vo;

import java.awt.TrayIcon.MessageType;
import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessage {
	private int id;
	private String regDate;  
	//    private MessageType type; // 메시지 타입 (채팅, 입장, 퇴장 등)
    private String content; // 메시지 내용
    private String senderName; // 메시지를 보낸 사람의 이름 
    private String senderId; // 메시지를 보낸 사람의 ID
    private String recipientId; // 메시지를 받은 사람의 ID
    private String chatRoomId; 
    
    
    // 다른 필드들...
}
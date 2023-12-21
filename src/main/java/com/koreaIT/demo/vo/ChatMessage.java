package com.koreaIT.demo.vo;

import java.awt.TrayIcon.MessageType;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessage {
//    private MessageType type; // 메시지 타입 (채팅, 입장, 퇴장 등)
    private String content; // 메시지 내용
//    private String sender; // 메시지 보낸 사람
    // 다른 필드들...
}
package com.koreaIT.demo.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;

import com.koreaIT.demo.vo.ChatMessage;

public class UstChatController {
	@MessageMapping("/chat.sendMessage") // 클라이언트로부터 메시지를 받는 주소
    @SendTo("/topic/public") // 메시지를 구독하고 있는 클라이언트에게 메시지를 보내는 주소
    public ChatMessage sendMessage(@Payload ChatMessage chatMessage) {
        return chatMessage;
    }
    
    // 여기에 채팅방 입장, 퇴장 등의 메소드를 추가할 수 있습니다.
}

package com.koreaIT.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.ArticleDao;
import com.koreaIT.demo.dao.ChatDao;
import com.koreaIT.demo.dao.MemberDao;
import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.ChatMessage;
import com.koreaIT.demo.vo.ChatRoom;

@Service
public class ChatService {
	
	private ChatDao chatDao;
	
	public ChatService(ChatDao chatDao) {
		this.chatDao = chatDao;
	}
	
	 // 채팅방 ID 생성 로직
    public String getOrCreateChatRoomId(int senderId, int recipientId) {
        // 두 사용자 ID를 기준으로 채팅방 ID를 생성합니다.
        String chatRoomId = createChatRoomId(senderId, recipientId);

        // 데이터베이스에서 채팅방 조회
        ChatRoom chatRoom = chatDao.selectChatRoomById(chatRoomId);
        if (chatRoom == null) {
            // 채팅방이 존재하지 않으면 새로운 채팅방을 생성합니다.
            chatDao.insertChatRoom(chatRoomId, senderId, recipientId);
        }
        return chatRoomId;
    }


	private String createChatRoomId(int senderId, int recipientId) {
        // 두 사용자 ID를 정렬하여 작은 숫자가 앞에 오도록 합니다.
        int minId = Math.min(senderId, recipientId);
        int maxId = Math.max(senderId, recipientId);

        // 정렬된 ID를 하이픈으로 연결하여 문자열로 만듭니다.
        return minId + "-" + maxId;
    }

	public void saveMessage(ChatMessage message) {
		chatDao.saveMessage(message);
	}

	public List<ChatMessage> getMessageHistory(String chatRoomId) {
		
		return chatDao.getMessageHistory(chatRoomId);
	}
	
	
	
	
	
}

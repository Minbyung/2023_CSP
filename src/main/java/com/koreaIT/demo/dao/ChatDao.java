package com.koreaIT.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.ArticleAndTagInfo;
import com.koreaIT.demo.vo.ChatMessage;
import com.koreaIT.demo.vo.ChatRoom;

@Mapper
public interface ChatDao {

	@Select("""
			SELECT *
				FROM chatRoom
				WHERE chatRoomId = #{chatRoomId}
			""")
	ChatRoom selectChatRoomById(String chatRoomId);

	
	@Insert("""
			INSERT INTO chatRoom
				SET chatRoomId = #{chatRoomId},
				senderId = #{senderId},
				recipientId = #{recipientId}
			""")
	void insertChatRoom(String chatRoomId, int senderId, int recipientId);


	
	@Insert("""
			INSERT INTO chatMessage
				SET content = #{content},
				senderName = #{senderName},
				senderId = #{senderId},
				recipientId = #{recipientId},
				chatRoomId = #{chatRoomId}
			""")
	void saveMessage(ChatMessage message);

	
	
	
	
	@Select("""
			SELECT *
				FROM chatMessage
				WHERE chatRoomId = #{chatRoomId}
			""")
	List<ChatMessage> getMessageHistory(String chatRoomId);
	
	
	
	
	
}

package com.koreaIT.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.ArticleAndTagInfo;
import com.koreaIT.demo.vo.ChatMessage;
import com.koreaIT.demo.vo.ChatRoom;
import com.koreaIT.demo.vo.GroupChatMessage;
import com.koreaIT.demo.vo.GroupChatRoom;
import com.koreaIT.demo.vo.Member;

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
				recipientId = #{recipientId},
				`name` = #{recipientName}
			""")
	void insertChatRoom(String chatRoomId, int senderId, int recipientId, String recipientName);


	
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


	
	
	@Insert("""
			INSERT INTO groupChatRoom
				SET groupChatRoomProjectId = #{groupChatRoomProjectId},
				`name` = #{projectName},
				senderId = #{myId}
			""")
	void insertGroupChatRoom(int groupChatRoomProjectId, String projectName, int myId);


	
	@Select("""
			SELECT * 
				FROM groupChatRoom
				WHERE groupChatRoomProjectId = #{groupChatRoomProjectId}
			""")
	GroupChatRoom getGroupChatRoomById(int groupChatRoomProjectId);
	
	
	
	@Select("SELECT LAST_INSERT_ID()")
	public int getLastInsertId();


	
	@Insert({
        "<script>",
        "INSERT INTO groupChatRoomMembers (groupChatRoomProjectId, memberId) VALUES",
        "<foreach collection='projectMemberIds' item='projectMemberId' separator=','>",
        "(#{groupChatRoomProjectId, jdbcType=INTEGER}, #{projectMemberId, jdbcType=INTEGER})",
        "</foreach>",
        "</script>"
    })
	void insertChatRoomMembers(@Param("groupChatRoomProjectId") int groupChatRoomProjectId, @Param("projectMemberIds") List<Integer> projectMemberIds);

	@Select("""
			SELECT M.*
			    FROM `member` AS M
			    INNER JOIN groupChatRoomMembers AS GM 
			    ON M.id = GM.memberId
			    WHERE GM.groupChatRoomProjectId = #{groupChatRoomProjectId}
			""")
	List<Member> findMembersByGroupChatRoomProjectId(int groupChatRoomProjectId);


	
	
	@Insert("""
			INSERT INTO groupChatMessage
				SET content = #{content},
				senderName = #{senderName},
				senderId = #{senderId},
				groupChatRoomProjectId = #{groupChatRoomProjectId}
			""")
	void saveGroupMessage(GroupChatMessage message);


	
	@Select("""
			SELECT *
				FROM groupChatMessage
				WHERE groupChatRoomProjectId = #{groupChatRoomProjectId}
			""")
	List<GroupChatMessage> getGroupMessageHistory(int groupChatRoomProjectId);


	
	
	@Select("""
			SELECT COUNT(*)
				FROM groupChatRoomMembers
				WHERE groupChatRoomProjectId = #{groupChatRoomProjectId}
			""")
	int getgroupChatRoomMembersCount(int groupChatRoomProjectId);


	@Select("""
			SELECT * FROM chatRoom
			WHERE senderId = #{memberId}
			""")
	List<ChatRoom> getChatRoomsByMemberId(int memberId);
	
}

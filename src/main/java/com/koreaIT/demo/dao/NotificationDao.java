package com.koreaIT.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.ArticleAndTagInfo;
import com.koreaIT.demo.vo.Group;
import com.koreaIT.demo.vo.Notification;

@Mapper
public interface NotificationDao {

	
	@Insert("INSERT INTO notification (writerId, writerName, title, content, regDate, projectName, articleId, taggedMemberId) VALUES (#{writerId}, #{writerName}, #{title}, #{content}, #{regDate}, #{projectName}, #{articleId}, #{taggedMemberId})")
	public void insertNotification(Notification managerNotification);
	
	@Delete("""
			DELETE FROM notification 
				WHERE id = #{id}
			""")
	public int deleteNotificationById(int id);
	
	@Select("""
			SELECT * FROM notification
				WHERE taggedMemberId = #{loginedMemberId};
			""")
	public List<Notification> getTaggedNotifications(int loginedMemberId);
	
	@Delete("""
			DELETE FROM notification 
				WHERE taggedMemberId = #{id}
			""")
	public int deleteAllNotification(int id);
	
	
	
	
}

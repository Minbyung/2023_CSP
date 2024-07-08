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

	
	@Insert("INSERT INTO notification (writerId, writerName, title, content, regDate, projectName, articleId) VALUES (#{writerId}, #{writerName}, #{title}, #{content}, #{regDate}, #{projectName}, #{articleId})")
	public void insertNotification(Notification writeNotification);
	
	@Delete("""
			DELETE FROM notification 
				WHERE id = #{id}
			""")
	public int deleteNotificationById(int id);
	
	@Select("""
			SELECT * FROM notification
				WHERE writerId != #{loginedMemberId};
			""")
	public List<Notification> getWriteNotifications(int loginedMemberId);
	
	
	
	
}

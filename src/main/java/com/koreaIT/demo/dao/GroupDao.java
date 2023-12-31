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

@Mapper
public interface GroupDao {
	@Select("""
			SELECT * FROM `group`
				WHERE projectId = #{projectId}
				ORDER BY id DESC
			""")
	public List<Group> getGroups(int projectId);

	
	
	@Insert("""
			INSERT INTO `group`
				SET projectId = #{projectId},
				group_name = #{group_name}
			""")
	public void doMakeGroup(int projectId, String group_name);
	
}

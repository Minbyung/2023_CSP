package com.koreaIT.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.Project;

@Mapper
public interface ProjectDao {
	
	@Insert("""
			INSERT INTO project
				SET project_name = #{name}
					, project_description = #{description}
			""")
	public void makeProject(String name, String description);

	
	
	
	
	
	@Select("""
			SELECT *
				FROM project
				WHERE id = #{projectId}
			""")
	public Project getProjectByProjectId(int projectId);
	
}

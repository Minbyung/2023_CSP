package com.koreaIT.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Project;

@Mapper
public interface ProjectDao {
	
	@Insert("""
			INSERT INTO project
				SET project_name = #{name}
					, project_description = #{description}
					, teamId = #{teamId}
			""")
	public void makeProject(String name, String description, int teamId);
	
	@Select("""
			SELECT *
				FROM project
				WHERE id = #{projectId}
			""")
	public Project getProjectByProjectId(int projectId);

	
	@Select("""
			SELECT M.name 
			FROM `member` AS M
			INNER JOIN projectMember AS PM
			ON PM.memberId = M.id
			WHERE `name` LIKE CONCAT('%', #{name}, '%')
			""")
	public List<String> getMembersByName(@Param("name") String name);
	
	@Select("SELECT LAST_INSERT_ID()")
	public int getLastInsertId();
	
	@Select("""
			SELECT *
				FROM project
				WHERE teamId = #{teamId}
			""")
	public List<Project> getProjectsByTeamId(int teamId);
}

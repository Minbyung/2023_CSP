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
	
	
	@Select("""
			SELECT *
				FROM project AS P
				INNER JOIN projectMember PM ON P.id = PM.projectId
				WHERE PM.memberId = #{memberId} AND P.teamId = #{teamId}
			""")
	public List<Project> getProjectsByTeamIdAndMemberId(int teamId, int memberId);

	
	@Insert("""
			INSERT INTO projectMember
				SET memberId = #{memberId},
				projectId = #{projectId}
			""")
	public void addMemberToProject(int memberId, int projectId);
	
	
	
	@Select("""
			SELECT COUNT(*) > 0
	        FROM projectMember
	        WHERE memberId = #{memberId}
	          AND projectId = #{projectId}
			""")
	public boolean isMemberAlreadyInProject(int memberId, int projectId);
	
	
	@Select("SELECT LAST_INSERT_ID()")
	public int getLastInsertId();

	
	
	
	
}

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
			SELECT P.*, COUNT(subPM.memberId) AS participantsCount
				FROM project AS P
				JOIN (
				    SELECT projectId
				    FROM projectMember
				    WHERE memberId = #{memberId}
				) AS subP ON P.id = subP.projectId
				LEFT JOIN projectMember AS subPM ON P.id = subPM.projectId
				WHERE P.teamId = #{teamId}
				GROUP BY P.id
				ORDER BY p.id DESC
			""")
	public List<Project> getProjectsByTeamIdAndMemberId(int teamId, int memberId);

	
	
	@Select("""
			SELECT p.*, COUNT(pm.memberId) AS participantsCount
				FROM project AS p
				INNER JOIN favorite AS f ON p.id = f.projectId
				LEFT JOIN projectMember AS pm ON p.id = pm.projectId
				WHERE f.memberId = #{memberId} AND p.teamId = #{teamId}
				GROUP BY p.id
				ORDER BY f.id DESC
			""")
	public List<Project> getFavoriteProjects(int teamId, int memberId);
	
	
	
	@Select("""
			SELECT p.*, COUNT(pm.memberId) AS participantsCount
				FROM project p
				LEFT JOIN favorite f ON p.id = f.projectId AND f.memberId = #{memberId}
				LEFT JOIN projectMember pm ON p.id = pm.projectId
				WHERE f.memberId IS NULL AND p.teamId = #{teamId}
				GROUP BY p.id
				ORDER BY p.id DESC;
			""")
	public List<Project> getNonFavoriteProjects(int teamId, int memberId);
	
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

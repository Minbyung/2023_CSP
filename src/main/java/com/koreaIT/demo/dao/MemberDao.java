package com.koreaIT.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.koreaIT.demo.vo.Member;

@Mapper
public interface MemberDao {
	
	@Insert("""
			INSERT INTO `member`
				SET regDate = NOW()
					, updateDate = NOW()
					, loginId = #{loginId}
					, loginPw = #{loginPw}
					, name = #{name}
					, cellphoneNum = #{cellphoneNum}
					, profilePhotoPath = #{profilePhotoPath}
			""")
	public void joinMember(String name, String cellphoneNum, String loginId, String loginPw, String profilePhotoPath);
	

	@Select("SELECT LAST_INSERT_ID()")
	public int getLastInsertId();

	@Select("""
			SELECT M.*, TM.teamId AS teamId
				FROM `member` AS M
				INNER JOIN teamMember AS TM
				ON M.id = TM.memberId
				WHERE M.loginId = #{loginId}
			""")
	public Member getMemberByLoginId(String loginId);

	@Select("""
			SELECT M.*, TM.teamId AS teamId
				FROM `member` AS M
				INNER JOIN teamMember AS TM
				ON M.id = TM.memberId
				WHERE M.id = #{id}
			""")
	public Member getMemberById(int id);
	
	
	@Update("""
			UPDATE `member`
				SET updateDate = NOW()
					, `name` = #{name}
					, nickname = #{nickname}
					, cellphoneNum = #{cellphoneNum}
					, email = #{email}
				WHERE id = #{id}
			""")
	public void doModify(int id, String name, String nickname, String cellphoneNum, String email);

	@Update("""
			UPDATE `member`
				SET updateDate = NOW()
					, loginPw = #{loginPw}
				WHERE id = #{id}
			""")
	public void doPasswordModify(int id, String loginPw);
	
	
	
	@Select("""
			SELECT id FROM `member` WHERE `name` = #{managerName}
			""")
	public Integer findIdByName(String managerName);

	@Select("""
			SELECT M.name 
				FROM `member` AS M
				INNER JOIN projectMember AS PM
				ON PM.memberId = M.id
				WHERE PM.projectId = #{projectId}
			""")
	public List<String> getMembers(int projectId);
	
	
	@Insert("""
			INSERT INTO teamMember
				SET memberId = #{memberId},
				teamId = #{teamId}
			""")
	public void insert(int memberId, int teamId);

	
	@Select("""
			SELECT M.*, TM.teamId AS teamId, T.teamName AS teamName
				FROM `member` AS M
				INNER JOIN teamMember AS TM 
				ON M.id = TM.memberId
				INNER JOIN team AS T
				ON TM.teamId = t.id
				WHERE teamId = #{teamId}
				ORDER BY
		            CASE WHEN M.id = #{loginedMemberId} THEN 0 ELSE 1 END, -- 현재 사용자 우선 정렬
		            M.id ASC -- 그 외 멤버는 ID 순으로 정렬
			""")
	public List<Member> getMembersByTeamId(int teamId, int loginedMemberId);

	
	
	@Select("""
			SELECT COUNT(*) 
				FROM teamMember
				WHERE teamId = #{teamId}
			""")
	public int getTeamMembersCnt(int teamId);

	
	@Select("""
	        SELECT M.*, PM.projectId AS projectId
	        FROM `member` AS M
	        INNER JOIN projectMember AS PM ON M.id = PM.memberId
	        WHERE PM.projectId = #{projectId}
	        ORDER BY
	            CASE WHEN M.id = #{loginedMemberId} THEN 0 ELSE 1 END, -- 현재 사용자 우선 정렬
	            M.id ASC -- 그 외 멤버는 ID 순으로 정렬
	        """)
	public List<Member> getprojectMembersByprojectId(int projectId, int loginedMemberId);

	
	
	
	
	@Select("""
			SELECT M.id
				FROM `member` AS M
				INNER JOIN  projectMember AS PM
				ON M.id = PM.memberId
				WHERE projectId = #{groupChatRoomId}
			""")
	public List<Integer> getprojectMembersIdByprojectId(int groupChatRoomId);

	@Select("""
			SELECT COUNT(*)
				FROM projectMember
				WHERE projectId = #{projectId}
			""")
	public int getProjectMembersCnt(int projectId);
}

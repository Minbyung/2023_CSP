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
			""")
	public void joinMember(String name, String cellphoneNum, String loginId, String loginPw);
	
	@Select("""
			SELECT * 
				FROM `member`
				WHERE id = #{id}
			""")
	public Member getMemberById(int id);

	@Select("SELECT LAST_INSERT_ID()")
	public int getLastInsertId();

	@Select("""
			SELECT M.*, TM.teamId AS teamId
				FROM `member` AS M
				INNER JOIN teamMember AS TM
				ON M.id = TM.memberId
				WHERE loginId = #{loginId};
			""")
	public Member getMemberByLoginId(String loginId);

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
			""")
	public List<String> getMembers();
	
	
	@Insert("""
			INSERT INTO teamMember
				SET memberId = #{memberId},
				teamId = #{teamId}
			""")
	public void insert(int memberId, int teamId);

	
	@Select("""
			SELECT M.*, TM.teamId AS teamId
				FROM `member` AS M
				INNER JOIN teamMember AS TM
				ON M.id = TM.memberId
				WHERE teamId = #{teamId};
			""")
	public List<Member> getMembersByTeamId(int teamId);
}

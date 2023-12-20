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
import com.koreaIT.demo.vo.Team;
import com.koreaIT.demo.vo.TeamInvite;

@Mapper
public interface TeamDao {
	
	@Insert("""
			INSERT INTO team
				SET teamName = #{teamName}
			""")
	public void insert(String teamName);
	
	@Select("""
			SELECT t.*, TI.teamId AS teamId, TI.inviteCode AS inviteCode
				FROM team AS T
				INNER JOIN teamInvite AS TI
				ON T.id = TI.teamId
				WHERE inviteCode = #{inviteCode};
			""")
	public Team getTeamByInviteCode(String inviteCode);
	
	@Select("SELECT LAST_INSERT_ID()")
	public int getLastInsertId();

	
	
	@Select("""
			SELECT *
				FROM team
				WHERE id = #{teamId}
			""")
	public Team getTeamNameByTeamId(int teamId);	
}

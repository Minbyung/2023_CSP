package com.koreaIT.demo.dao;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.koreaIT.demo.vo.RecommendPoint;

@Mapper
public interface FavoriteDao {


	@Insert("""
			INSERT INTO favorite
				SET memberId = #{memberId}
					, projectId = #{projectId}
			""")
	void addFavorite(int memberId, int projectId);

	@Delete("""
			DELETE FROM favorite
				WHERE memberId = #{memberId}
				AND projectId = #{projectId}
			""")
	void removeFavorite(int memberId, int projectId);

	
	
	
	@Select("""
			SELECT COUNT(*) 
				FROM favorite
				WHERE memberId = #{memberId}
				AND projectId = #{projectId}
			""")
	int getFavorite(int memberId, int projectId);

}

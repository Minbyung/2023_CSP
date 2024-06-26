package com.koreaIT.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.ArticleAndTagInfo;

@Mapper
public interface ArticleDao {
	
	@Insert("""
			INSERT INTO article
				SET regDate = NOW()
					, updateDate = NOW()
					, memberId = #{memberId}
					, title = #{title}
					, content = #{content}
					, `status` = #{status}
					, projectId = #{projectId}
					, groupId = #{selectedGroupId}
					, startDate = #{startDate}
					, endDate = #{endDate}
			""")
	public void writeArticle(int memberId, String title, String content, String status, int projectId, int selectedGroupId, String startDate, String endDate);
	
	@Select("""
			<script>
			SELECT COUNT(*)
				FROM article
				WHERE boardId = #{boardId}
				<if test="searchKeyword != ''">
					<choose>
						<when test="searchKeywordType == 'title'">
							AND title LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<when test="searchKeywordType == 'body'">
							AND `body` LIKE CONCAT('%', #{searchKeyword}, '%')
						</when>
						<otherwise>
							AND (
								title LIKE CONCAT('%', #{searchKeyword}, '%')
								OR `body` LIKE CONCAT('%', #{searchKeyword}, '%')
							)
						</otherwise>
					</choose>
				</if>
			</script>
			""")
	public int getArticlesCnt(int boardId, String searchKeywordType, String searchKeyword);
	
	@Select("""
			SELECT A.*, M.name AS writerName, GROUP_CONCAT(TA.name) AS taggedNames, G.group_name AS groupName
				FROM article AS A
				INNER JOIN `member` AS M ON A.memberId = M.id
				LEFT JOIN tag AS T ON A.id = T.articleId
				LEFT JOIN `member` AS TA ON T.memberId = TA.id
				LEFT JOIN `group` AS G ON A.groupId = G.id
				WHERE A.projectId = #{projectId}
				GROUP BY A.id
				ORDER BY ${column} ${order}
			""")
	public List<Article> getArticles(int projectId, String column, String order);
	
	
	@Select("""
			SELECT A.*, M.name AS writerName, GROUP_CONCAT(TA.name) AS taggedNames, G.group_name AS groupName
				FROM article AS A
				INNER JOIN `member` AS M ON A.memberId = M.id
				LEFT JOIN tag AS T ON A.id = T.articleId
				LEFT JOIN `member` AS TA ON T.memberId = TA.id
				LEFT JOIN `group` AS G ON A.groupId = G.id
				WHERE A.projectId = #{projectId} AND A.id = #{articleId}
				GROUP BY A.id
			""")
	public Article getArticle(int projectId, int articleId);
	
	
	
	
	@Update("""
			UPDATE article
				SET hitCount = hitCount + 1
				WHERE id = #{id}
			""")
	public void increaseHitCount(int id);
	
	@Select("""
			SELECT A.*
				   , M.name AS writerName
				   , IFNULL(SUM(R.point), 0) AS `point`
				FROM article AS A
				INNER JOIN `member` AS M
				ON A.memberId = M.id
				LEFT JOIN recommendPoint AS R
				ON relTypeCode = 'article'
				AND A.id = R.relId
				WHERE A.id = #{id}
				GROUP BY A.id
			""")
	public Article forPrintArticle(int id);
	
	@Select("""
			SELECT * 
				FROM article
				WHERE id = #{id}
			""")
	public Article getArticleById(int id);
	
	@Update("""
			<script>
			UPDATE article
				SET updateDate = NOW()
					<if test="title != null and title != ''">
						, title = #{title}
					</if>
					<if test="body != null and body != ''">
						, `body` = #{body}
					</if>
				WHERE id = #{id}
			</script>
			""")
	public void modifyArticle(int id, String title, String body);
	
	@Delete("""
			DELETE FROM article
				WHERE id = #{id}
			""")
	public void deleteArticle(int id);

	@Select("SELECT LAST_INSERT_ID()")
	public int getLastInsertId();

	
	@Insert("""
			INSERT INTO tag
				SET projectId = #{projectId},
				articleId = #{articleId},
				memberId = #{managerId}
			""")
	public void insertTag(int articleId, Integer managerId, int projectId);

	@Update("""
			UPDATE tag
				SET memberId = #{managerId}
				WHERE articleId = #{articleId} AND projectId = #{projectId}
			""")
	public void updateTag(int articleId, Integer managerId, int projectId);

	@Select("""
		    SELECT COUNT(*)
			    FROM tag
			    WHERE articleId = #{articleId} AND projectId = #{projectId} AND memberId = #{managerId}
		    """)
	public int isTagExists(int articleId, Integer managerId, int projectId);
	
	
	@Select("""
	    SELECT memberId
		    FROM tag
		    WHERE articleId = #{articleId} AND projectId = #{projectId}
	    """)
	public List<Integer> getTagMemberIds(int articleId, int projectId);

	@Delete("""
	    DELETE FROM tag
			WHERE articleId = #{articleId} AND projectId = #{projectId} AND memberId = #{managerId}
	    """)
	public void deleteTag(int articleId, Integer managerId, int projectId);
	
	@Update("""
			UPDATE article
				SET `status` = #{newStatus}
				WHERE id = #{articleId};
			""")
	public void updateStatus(int articleId, String newStatus);

	
	
	@Select("""
			SELECT `status`, COUNT(*) AS `count`
			FROM article
			WHERE projectId = #{projectId}
			GROUP BY `status`
			""")
	public List<Map<String, Object>> getArticleCountsByStatus(int projectId);

	@Update("""
			UPDATE article
				SET startDate = #{startDate},
				endDate = #{endDate}
				WHERE id = #{articleId};
			""")
	public void doUpdateDate(int articleId, String startDate, String endDate);

	
	@Select("""
			SELECT A.*
				FROM tag AS T
				INNER JOIN article AS A
				ON T.articleId = A.id
				WHERE T.memberId = #{memberId}
				ORDER BY regDate DESC
			""")
	public List<Article> getTaggedArticleByMemberId(int memberId);

	
	@Select("""
			SELECT A.*, M.name AS writerName, GROUP_CONCAT(TA.name) AS taggedNames, G.group_name AS groupName, P.project_name AS projectName
				FROM article AS A
				INNER JOIN `member` AS M ON A.memberId = M.id
				LEFT JOIN tag AS T ON A.id = T.articleId
				LEFT JOIN `member` AS TA ON T.memberId = TA.id
				LEFT JOIN `group` AS G ON A.groupId = G.id
				LEFT JOIN project AS P ON A.projectId = P.id
				WHERE A.projectId = 1
				GROUP BY A.id
				ORDER BY A.id DESC
				LIMIT 1;
			""")
	public Article getRecentlyAddArticle(int projectId);
	
	@Update("""
			UPDATE article
				SET updateDate = NOW()
					, title = #{title}
					, content = #{content}
					, `status` = #{status}
					, startDate = #{startDate}
					, endDate = #{endDate}
					WHERE id = #{articleId} AND projectId = #{projectId}
			""")
	public void updateArticle(int articleId, int memberId, String title, String content, String status, int projectId,
			int selectedGroupId, String startDate, String endDate);

	
	@Select("""
        SELECT A.*, M.name AS writerName, GROUP_CONCAT(TA.name) AS taggedNames, G.group_name AS groupName
	        FROM article AS A
	        INNER JOIN `member` AS M ON A.memberId = M.id
	        LEFT JOIN tag AS T ON A.id = T.articleId
	        LEFT JOIN `member` AS TA ON T.memberId = TA.id
	        LEFT JOIN `group` AS G ON A.groupId = G.id
	        WHERE (A.title LIKE CONCAT('%', #{searchTerm}, '%') OR A.content LIKE CONCAT('%', #{searchTerm}, '%'))
	        AND A.projectId = #{projectId}
	        GROUP BY A.id
		    """)
	public List<Article> getArticlesByTerm(String searchTerm, int projectId);
	
}

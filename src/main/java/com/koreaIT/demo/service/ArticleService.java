package com.koreaIT.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.ArticleDao;
import com.koreaIT.demo.dao.MemberDao;
import com.koreaIT.demo.vo.Article;

@Service
public class ArticleService {
	
	private ArticleDao articleDao;
	private MemberDao memberDao;
	
	public ArticleService(ArticleDao articleDao, MemberDao memberDao) {
		this.articleDao = articleDao;
		this.memberDao = memberDao;		
	}
	
//	public void writeArticle(int memberId, String title, String content, String status, int projectId, List<String> managers) {
//		articleDao.writeArticle(memberId, title, content, status, projectId, managers);
//	}
	
	public int getArticlesCnt(int boardId, String searchKeywordType, String searchKeyword) {
		return articleDao.getArticlesCnt(boardId, searchKeywordType, searchKeyword);
	}
	
//	public List<Article> getArticles(int boardId, String searchKeywordType, String searchKeyword, int limitStart, int itemsInAPage) {
//		return articleDao.getArticles(boardId, searchKeywordType, searchKeyword, limitStart, itemsInAPage);
//	}
	
	public List<Article> getArticles(int projectId) {
		return articleDao.getArticles(projectId);
	}
	
	public Article forPrintArticle(int id) {
		return articleDao.forPrintArticle(id);
	}
	
	public Article getArticleById(int id) {
		return articleDao.getArticleById(id);
	}
	
	public void modifyArticle(int id, String title, String body) {
		articleDao.modifyArticle(id, title, body);
	}
	
	public void deleteArticle(int id) {
		articleDao.deleteArticle(id);
	}

	public int getLastInsertId() {
		return articleDao.getLastInsertId();
	}

	public void increaseHitCount(int id) {
		articleDao.increaseHitCount(id);
	}

	public void writeArticle(int memberId, String title, String content, String status, int projectId, int selectedGroupId, List<String> managers, String startDate, String endDate) {
		articleDao.writeArticle(memberId, title, content, status, projectId, selectedGroupId, startDate, endDate);
		
		int articleId = getLastInsertId();
		
		for (String managerName : managers) {
            Integer managerId = memberDao.findIdByName(managerName);
            if (managerId != null) {
                articleDao.insertTag(articleId, managerId, projectId);
            }
        }
	}

	public void updateStatus(int articleId, String newStatus) {
		articleDao.updateStatus(articleId, newStatus);
		
	}

	public List<Map<String, Object>> getArticleCountsByStatus(int projectId) {
		
		return articleDao.getArticleCountsByStatus(projectId);
	}
}

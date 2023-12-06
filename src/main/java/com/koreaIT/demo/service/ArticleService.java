package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.ArticleDao;
import com.koreaIT.demo.vo.Article;

@Service
public class ArticleService {
	
	private ArticleDao articleDao;
	
	public ArticleService(ArticleDao articleDao) {
		this.articleDao = articleDao;
	}
	
	public void writeArticle(int memberId, String title, String content, String status, int projectId) {
		articleDao.writeArticle(memberId, title, content, status, projectId);
	}
	
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
}

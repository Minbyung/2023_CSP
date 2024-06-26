package com.koreaIT.demo.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.koreaIT.demo.service.ArticleService;
import com.koreaIT.demo.service.BoardService;
import com.koreaIT.demo.service.FileService;
import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.util.FileUtils;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.FileRequest;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Reply;
import com.koreaIT.demo.vo.Rq;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UsrArticleController {
	
	private ArticleService articleService;
	private FileService fileService;
	private FileUtils fileUtils;
	private BoardService boardService;
	private ReplyService replyService;
	private MemberService memberService;
	private Rq rq;
	
	
	UsrArticleController(ArticleService articleService, FileService fileService, FileUtils fileUtils, BoardService boardService, ReplyService replyService, MemberService memberService, Rq rq) {
		this.articleService = articleService;
		this.fileService = fileService;
		this.fileUtils = fileUtils;
		this.boardService = boardService;
		this.replyService = replyService;
		this.memberService = memberService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	@Transactional //writeArticle 메서드와 관련된 모든 데이터베이스 쓰기 작업(게시물 및 태그 삽입 등)을 하나의 트랜잭션 안에서 수행합니다. 이렇게 하면 getLastInsertId()는 여전히 게시물 삽입에 대한 마지막 ID를 반환할 것입니다.
	public String doWrite(String title, String content, String status, int projectId, int selectedGroupId, @RequestParam(value="managers[]") List<String> managers, String startDate, String endDate, @RequestParam(value = "fileRequests[]", required = false) List<MultipartFile> fileRequests) {
		
		if (Util.empty(title)) {
			return Util.jsHistoryBack("제목을 입력해주세요");
		}
		
		if (Util.empty(content)) {
			return Util.jsHistoryBack("내용을 입력해주세요");
		}
		
		int id = articleService.writeArticle(rq.getLoginedMemberId(), title, content, status, projectId, selectedGroupId, managers, startDate, endDate);
			
		if (fileRequests != null && !fileRequests.isEmpty()) {
			List<FileRequest> files = fileUtils.uploadFiles(fileRequests);
	        fileService.saveFiles(id, projectId, files);
		}

		return Util.jsReplace(Util.f("%d번 게시물을 생성했습니다", id), Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/article/doUpdate")
	@ResponseBody
	@Transactional //writeArticle 메서드와 관련된 모든 데이터베이스 쓰기 작업(게시물 및 태그 삽입 등)을 하나의 트랜잭션 안에서 수행합니다. 이렇게 하면 getLastInsertId()는 여전히 게시물 삽입에 대한 마지막 ID를 반환할 것입니다.
	public String doUpdate(int articleId, String title, String content, String status, int projectId, int selectedGroupId, @RequestParam(value="managers[]") List<String> managers, String startDate, String endDate, @RequestParam(value = "fileRequests[]", required = false) List<MultipartFile> fileRequests) {
		
		if (Util.empty(title)) {
			return Util.jsHistoryBack("제목을 입력해주세요");
		}
		
		if (Util.empty(content)) {
			return Util.jsHistoryBack("내용을 입력해주세요");
		}
		
		int id = articleService.updateArticle(articleId, rq.getLoginedMemberId(), title, content, status, projectId, selectedGroupId, managers, startDate, endDate);
			
		if (fileRequests != null && !fileRequests.isEmpty()) {
			List<FileRequest> files = fileUtils.uploadFiles(fileRequests);
	        fileService.saveFiles(id, projectId, files);
		}
    
		
		return Util.jsReplace(Util.f("%d번 게시물을 생성했습니다", id), Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/article/doUpdateStatus")
	@ResponseBody
	public String doUpdateStatus(int articleId, String newStatus) {
		articleService.updateStatus(articleId, newStatus);
		int id = articleId;
		return Util.jsReplace(Util.f("%d번 게시물을 수정했습니다", id), Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/article/doUpdateDate")
	@ResponseBody
	public String doUpdateDate(int articleId, String startDate, String endDate) {
		articleService.doUpdateDate(articleId, startDate, endDate);
		int id = articleId;
		return Util.jsReplace(Util.f("%d번 게시물을 수정했습니다", id), Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/article/getArticleCountsByStatus")
	@ResponseBody
	public List<Map<String, Object>> getArticleCountsByStatus(int projectId) {
		return articleService.getArticleCountsByStatus(projectId);
	}	
	
	
	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(int id) {
		
		Article article = articleService.getArticleById(id);
		
		if (article == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다", id));
		}
		
		if (rq.getLoginedMemberId() != article.getMemberId()) {
			return Util.jsHistoryBack("해당 게시물에 대한 권한이 없습니다");
		}
		
		int projectId = article.getProjectId();
		
		articleService.deleteArticle(id);
		fileService.deleteAllFile(projectId, id);
		
		return Util.jsReplace(Util.f("%d번 게시물을 삭제했습니다", id), Util.f("../project/detail?projectId=%d", projectId));
	}
	
	@RequestMapping("/usr/article/modify")
	@ResponseBody
	public Article modify(Model model, int projectId, int articleId) {
		
		Article article = articleService.getArticle(projectId, articleId);
		
//		if (article == null) {
//			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다", articleId));
//		}
//		
//		if (rq.getLoginedMemberId() != article.getMemberId()) {
//			return rq.jsReturnOnView("해당 게시물에 대한 권한이 없습니다");
//		}
		
		System.out.println(article);
		
		model.addAttribute("article", article);
		
		return article;
	}
	
//	http://localhost:8082/usr/article/list
	
//	@RequestMapping("/usr/article/list")
//	public String list(Model model, @RequestParam(defaultValue = "1") int boardId, @RequestParam(defaultValue = "1") int page,
//			@RequestParam(defaultValue = "title") String searchKeywordType, @RequestParam(defaultValue = "") String searchKeyword) {
//		
//		if (page <= 0) {
//			return rq.jsReturnOnView("페이지번호가 올바르지 않습니다");
//		}
//		
//		Board board = boardService.getBoardById(boardId);
//
//		if (board == null) {
//			return rq.jsReturnOnView("존재하지 않는 게시판입니다");
//		}
//		
//		int articlesCnt = articleService.getArticlesCnt(boardId, searchKeywordType, searchKeyword);
//		
//		int itemsInAPage = 10;
//		
//		int limitStart = (page - 1) * itemsInAPage;
//		
//		int pagesCnt = (int) Math.ceil((double) articlesCnt / itemsInAPage);
//		
//		List<Article> articles = articleService.getArticles(boardId, searchKeywordType, searchKeyword, limitStart, itemsInAPage);
//		
//		model.addAttribute("searchKeywordType", searchKeywordType);
//		model.addAttribute("searchKeyword", searchKeyword);
//		model.addAttribute("articles", articles);
//		model.addAttribute("articlesCnt", articlesCnt);
//		model.addAttribute("board", board);
//		model.addAttribute("pagesCnt", pagesCnt);
//		model.addAttribute("page", page);
//		
//		return "usr/article/list";
//	}
	
	@RequestMapping("/usr/article/detail")
	public String detail(HttpServletRequest req, HttpServletResponse resp, Model model, int id) {
		
		Cookie oldCookie = null;
		Cookie[] cookies = req.getCookies();
		
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("hitCount")) {
					oldCookie = cookie;
				}
			}
		}
		if (oldCookie != null) {
			if (oldCookie.getValue().contains("[" + id + "]") == false) {
				articleService.increaseHitCount(id);
				oldCookie.setValue(oldCookie.getValue() + "_[" + id + "]");
				oldCookie.setPath("/");
				oldCookie.setMaxAge(5);
				resp.addCookie(oldCookie);
			}
		} else {
			articleService.increaseHitCount(id);
			Cookie newCookie = new Cookie("hitCount", "[" + id + "]"); 
			newCookie.setPath("/");
			newCookie.setMaxAge(5);
			resp.addCookie(newCookie);
		}
		
		Article article = articleService.getArticleById(id);
		
		List<Reply> replies = replyService.getReplies("article", id);
		
		Member member = memberService.getMemberById(rq.getLoginedMemberId());
		
		model.addAttribute("member", member);
		model.addAttribute("article", article);
		model.addAttribute("replies", replies);
		
		return "usr/article/detail";
	}
	

//	
//	@RequestMapping("/usr/article/doModify")
//	@ResponseBody
//	public String doModify(int id, String title, String body) {
//		
//		Article article = articleService.getArticleById(id);
//		
//		if (article == null) {
//			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다", id));
//		}
//		
//		if (rq.getLoginedMemberId() != article.getMemberId()) {
//			return Util.jsHistoryBack("해당 게시물에 대한 권한이 없습니다");
//		}
//		
//		articleService.modifyArticle(id, title, body);
//		
//		return Util.jsReplace(Util.f("%d번 게시물을 수정했습니다", id), Util.f("detail?id=%d", id));
//	}
//	
	
}
package com.koreaIT.demo.controller;

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
import com.koreaIT.demo.service.FileService;
import com.koreaIT.demo.service.GroupService;
import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.util.FileUtils;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.FileRequest;
import com.koreaIT.demo.vo.FileResponse;
import com.koreaIT.demo.vo.Group;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Reply;
import com.koreaIT.demo.vo.ResultData;
import com.koreaIT.demo.vo.Rq;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UsrArticleController {
	
	private ArticleService articleService;
	private FileService fileService;
	private FileUtils fileUtils;
	private ReplyService replyService;
	private MemberService memberService;
	private GroupService groupService;
	private Rq rq;
	
	
	UsrArticleController(ArticleService articleService, FileService fileService, FileUtils fileUtils, ReplyService replyService, MemberService memberService, GroupService groupService, Rq rq) {
		this.articleService = articleService;
		this.fileService = fileService;
		this.fileUtils = fileUtils;
		this.replyService = replyService;
		this.memberService = memberService;
		this.groupService = groupService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	@Transactional //writeArticle 메서드와 관련된 모든 데이터베이스 쓰기 작업(게시물 및 태그 삽입 등)을 하나의 트랜잭션 안에서 수행합니다. 이렇게 하면 getLastInsertId()는 여전히 게시물 삽입에 대한 마지막 ID를 반환할 것입니다.
	public String doWrite(String title, String content, String status, @RequestParam(value="projectId") int projectId, int selectedGroupId, @RequestParam(value="managers[]") List<String> managers, String startDate, String endDate, @RequestParam(value = "fileRequests[]", required = false) List<MultipartFile> fileRequests) {
		
		System.out.println("startDate:" +  startDate);
		
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
	public ResultData<Article> modify(Model model, int projectId, int articleId) {
		
		Article article = articleService.getArticle(projectId, articleId);
		model.addAttribute("article", article);
		
		if (article == null) {
	        return ResultData.from("F-1", Util.f("%d번 게시물은 존재하지 않습니다", articleId));
	    }

	    if (rq.getLoginedMemberId() != article.getMemberId()) {
	        return ResultData.from("F-2", "해당 게시물에 대한 권한이 없습니다");
	    }

		return ResultData.from("S-1", "게시글 조회 성공", article);
	}
	
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
		
		List<FileResponse> infoFiles = fileService.findAllFileByArticleId(article.getId());
        article.setInfoFiles(infoFiles);
		
		List<Reply> replies = replyService.getReplies("article", id);
		
		Member member = memberService.getMemberById(rq.getLoginedMemberId());
		int projectId = article.getProjectId();
		List<Group> groups = groupService.getGroups(projectId);
		
		model.addAttribute("member", member);
		model.addAttribute("article", article);
		model.addAttribute("replies", replies);
		model.addAttribute("groups", groups);
		
		return "usr/article/detail";
	}
	
}
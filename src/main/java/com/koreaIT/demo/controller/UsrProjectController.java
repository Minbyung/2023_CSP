package com.koreaIT.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.ArticleService;
import com.koreaIT.demo.service.BoardService;
import com.koreaIT.demo.service.GroupService;
import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.ProjectService;
import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.Group;
import com.koreaIT.demo.vo.Project;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrProjectController {
	
	private ProjectService projectService;
	private ArticleService articleService;
	private GroupService groupService;
	private BoardService boardService;
	private ReplyService replyService;
	private MemberService memberService;
	private Rq rq;
	
	UsrProjectController(ProjectService projectService, BoardService boardService, ReplyService replyService, MemberService memberService, ArticleService articleService, GroupService groupService, Rq rq) {
		this.projectService = projectService;
		this.articleService = articleService;
		this.groupService = groupService;
		this.boardService = boardService;
		this.replyService = replyService;
		this.memberService = memberService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/project/make")
	public String make() {
		return "usr/project/make";
	}
	
	@RequestMapping("/usr/project/doMake")
	@ResponseBody
	public String doMake(String project_name, @RequestParam(defaultValue = "") String project_description) {
		
		if (Util.empty(project_name)) {
			return Util.jsHistoryBack("제목을 입력해주세요");
		}

		projectService.makeProject(project_name, project_description);
		
		int id = projectService.getLastInsertId();
		
		return Util.jsReplace("프로젝트를 생성했습니다", Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/project/detail")
	public String detail(Model model, int projectId, @RequestParam(required = false, defaultValue = "id") String column, @RequestParam(required = false, defaultValue = "DESC") String order) {
		
		Project project = projectService.getProjectByProjectId(projectId);
		List<Article> articles = articleService.getArticles(projectId, column, order);
		List<Group> groups = groupService.getGroups(projectId);
		
		model.addAttribute("project", project);
		model.addAttribute("articles", articles);
		model.addAttribute("groups", groups);
		
		return "usr/project/detail";
	}
	
	@RequestMapping("/usr/project/task")
	public String task(Model model, @RequestParam(defaultValue = "1") int projectId, @RequestParam(required = false, defaultValue = "id") String column, @RequestParam(required = false, defaultValue = "DESC") String order) {
		
		Project project = projectService.getProjectByProjectId(projectId);
		List<Article> articles = articleService.getArticles(projectId, column, order);
		List<Group> groups = groupService.getGroups(projectId);
		
		
		// groupId 별로 article을 그룹화
		Map<String, List<Article>> groupedArticles = new LinkedHashMap<>();
		// 먼저 모든 그룹을 맵에 추가
		for (Group group : groups) {
		    groupedArticles.put(group.getGroup_name(), new ArrayList<>());
		}
		// 그런 다음 각 게시글을 해당 그룹에 추가
		for (Article article : articles) {
		    String groupName = article.getGroupName();
		    if (groupedArticles.containsKey(groupName)) { 
		        groupedArticles.get(groupName).add(article);
		    }
		}

		model.addAttribute("project", project);
		model.addAttribute("articles", articles);
		model.addAttribute("groups", groups);
		model.addAttribute("groupedArticles", groupedArticles);

		return "usr/project/task";
	}
//	../project/task?projectId=1"
	
	
	
	@RequestMapping("/usr/project/getGroupedArticles")
	@ResponseBody
	public Map<String, List<Article>> getGroupedArticles(Model model, int projectId, @RequestParam(required = false, defaultValue = "id") String column, @RequestParam(required = false, defaultValue = "DESC") String order) {
		
		List<Article> articles = articleService.getArticles(projectId, column, order);
		List<Group> groups = groupService.getGroups(projectId);
		
		// groupId 별로 article을 그룹화
		
		Map<String, List<Article>> groupedArticles = new LinkedHashMap<>();
		// 먼저 모든 그룹을 맵에 추가
		for (Group group : groups) {
		    groupedArticles.put(group.getGroup_name(), new ArrayList<>());
		}
		
		// 그런 다음 각 게시글을 해당 그룹에 추가
		for (Article article : articles) {
		    String groupName = article.getGroupName();
		    if (groupedArticles.containsKey(groupName)) { 
		        groupedArticles.get(groupName).add(article);
		    }
		}
		
		return groupedArticles;
	}
	
	
	
	
	@RequestMapping("/usr/project/getMembers")
	@ResponseBody
	public List<String> getMembersByName(@RequestParam String term) {
		
		if (term.equals(" ")) {
	        return memberService.getMembers();
	    }
		
		return projectService.getMembersByName(term);
	}
	
	@RequestMapping("/usr/project/gantt")
	public String gantt(Model model, @RequestParam(defaultValue = "1") int projectId, @RequestParam(required = false, defaultValue = "id") String column, @RequestParam(required = false, defaultValue = "DESC") String order) {
		
		Project project = projectService.getProjectByProjectId(projectId);
		List<Article> articles = articleService.getArticles(projectId, column, order);
		List<Group> groups = groupService.getGroups(projectId);
		
		
		// groupId 별로 article을 그룹화
		Map<String, List<Article>> groupedArticles = new LinkedHashMap<>();
		// 먼저 모든 그룹을 맵에 추가
		for (Group group : groups) {
		    groupedArticles.put(group.getGroup_name(), new ArrayList<>());
		}
		// 그런 다음 각 게시글을 해당 그룹에 추가
		for (Article article : articles) {
		    String groupName = article.getGroupName();
		    if (groupedArticles.containsKey(groupName)) { 
		        groupedArticles.get(groupName).add(article);
		    }
		}

		model.addAttribute("project", project);
		model.addAttribute("articles", articles);
		model.addAttribute("groups", groups);
		model.addAttribute("groupedArticles", groupedArticles);
		
		
		
		
		return "usr/project/gantt"; 
	}
	
	
	
	

}

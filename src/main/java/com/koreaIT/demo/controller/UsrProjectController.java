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
import com.koreaIT.demo.service.ChatService;
import com.koreaIT.demo.service.FileService;
import com.koreaIT.demo.service.GroupService;
import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.ProjectService;
import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.ChatRoom;
import com.koreaIT.demo.vo.FileResponse;
import com.koreaIT.demo.vo.Group;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Project;
import com.koreaIT.demo.vo.RecommendPoint;
import com.koreaIT.demo.vo.ResultData;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrProjectController {
	
	private ProjectService projectService;
	private ArticleService articleService;
	private GroupService groupService;
	private FileService fileService;
	private MemberService memberService;
	private ChatService chatService;
	private Rq rq;
	
	UsrProjectController(ProjectService projectService, ChatService chatService, MemberService memberService, ArticleService articleService, GroupService groupService, FileService fileService, Rq rq) {
		this.projectService = projectService;
		this.articleService = articleService;
		this.groupService = groupService;
		this.fileService = fileService;
		this.memberService = memberService;
		this.chatService = chatService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/project/make")
	public String make(Model model, int teamId) {
		
		model.addAttribute("teamId", teamId);
		
		return "usr/project/make";
	}
	
	@RequestMapping("/usr/project/doMake")
	@ResponseBody
	public String doMake(String project_name, @RequestParam(defaultValue = "") String project_description, int teamId) {
		
		if (Util.empty(project_name)) {
			return Util.jsHistoryBack("제목을 입력해주세요");
		}
		int memberId = rq.getLoginedMemberId();
		
		projectService.makeProject(project_name, project_description, teamId, memberId);
		
		
		return Util.jsReplace(Util.f("%s 을 생성했습니다", project_name), "/usr/dashboard/dashboard?teamId=" + teamId);
	}
	
	@RequestMapping("/usr/project/detail")
	public String detail(Model model, int projectId, @RequestParam(required = false, defaultValue = "id") String column, @RequestParam(required = false, defaultValue = "DESC") String order) {
		
		int memberId = rq.getLoginedMemberId();
		
		
		
		Project project = projectService.getProjectByProjectId(projectId);
		List<Article> articles = articleService.getArticles(projectId, column, order);
		Article lastPostedArticle = articleService.getRecentlyAddArticle(projectId);
		
		
		
		
		for (Article article : articles) {
	        List<FileResponse> infoFiles = fileService.findAllFileByArticleId(article.getId());
	        article.setInfoFiles(infoFiles); 
	    }
		
		
		
		
		
		List<Group> groups = groupService.getGroups(projectId);
		int teamId = project.getTeamId();
		List<Member> teamMembers = memberService.getMembersByTeamId(teamId, rq.getLoginedMemberId());
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		
		List<Member> projectMembers = memberService.getprojectMembersByprojectId(projectId, rq.getLoginedMemberId());
		Member loginedMember = memberService.getMemberById(rq.getLoginedMemberId());
		int teamMembersCnt = memberService.getTeamMembersCnt(teamId);
		int projectMembersCnt = memberService.getProjectMembersCnt(projectId);
		List<ChatRoom> chatRooms = chatService.getChatRoomsByMemberId(memberId);
		
		Member member = memberService.getMemberById(memberId);

		model.addAttribute("project", project);
		model.addAttribute("projects", projects);
		model.addAttribute("projectId", projectId);
		model.addAttribute("articles", articles);
		model.addAttribute("lastPostedArticle", lastPostedArticle);
		model.addAttribute("groups", groups);
		model.addAttribute("teamMembers", teamMembers);
		model.addAttribute("projectMembers", projectMembers);
		model.addAttribute("teamId", teamId);
		model.addAttribute("loginedMember", loginedMember);
		model.addAttribute("teamMembersCnt", teamMembersCnt);
		model.addAttribute("projectMembersCnt", projectMembersCnt);
		model.addAttribute("chatRooms", chatRooms);
		model.addAttribute("member", member);
		
		
		return "usr/project/detail";
	}
	
	@RequestMapping("/usr/article/search")
	public String search(Model model, int projectId, String searchTerm, @RequestParam(required = false, defaultValue = "id") String column, @RequestParam(required = false, defaultValue = "DESC") String order) {
		
		int memberId = rq.getLoginedMemberId();
		
		
		
		
		Project project = projectService.getProjectByProjectId(projectId);
		List<Article> articles = articleService.getArticlesByTerm(searchTerm, projectId);
		Article lastPostedArticle = articleService.getRecentlyAddArticle(projectId);
		
		
		for (Article article : articles) {
		       System.out.println(article);
		    }
		
		for (Article article : articles) {
	        List<FileResponse> infoFiles = fileService.findAllFileByArticleId(article.getId());
	        System.out.println(infoFiles);
	        
	        article.setInfoFiles(infoFiles); 
	    }
		
		
		
		
		
		List<Group> groups = groupService.getGroups(projectId);
		int teamId = project.getTeamId();
		List<Member> teamMembers = memberService.getMembersByTeamId(teamId, rq.getLoginedMemberId());
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		
		List<Member> projectMembers = memberService.getprojectMembersByprojectId(projectId, rq.getLoginedMemberId());
		Member loginedMember = memberService.getMemberById(rq.getLoginedMemberId());
		int teamMembersCnt = memberService.getTeamMembersCnt(teamId);
		int projectMembersCnt = memberService.getProjectMembersCnt(projectId);
		List<ChatRoom> chatRooms = chatService.getChatRoomsByMemberId(memberId);
		
		Member member = memberService.getMemberById(memberId);
		
		
		model.addAttribute("project", project);
		model.addAttribute("projects", projects);
		model.addAttribute("projectId", projectId);
		model.addAttribute("articles", articles);
		model.addAttribute("lastPostedArticle", lastPostedArticle);
		model.addAttribute("groups", groups);
		model.addAttribute("teamMembers", teamMembers);
		model.addAttribute("projectMembers", projectMembers);
		model.addAttribute("teamId", teamId);
		model.addAttribute("loginedMember", loginedMember);
		model.addAttribute("teamMembersCnt", teamMembersCnt);
		model.addAttribute("projectMembersCnt", projectMembersCnt);
		model.addAttribute("chatRooms", chatRooms);
		model.addAttribute("member", member);
		
		
		return "usr/project/detail";
	}
	
	
	
	
	@RequestMapping("/usr/project/task")
	public String task(Model model, int projectId, @RequestParam(required = false, defaultValue = "id") String column, @RequestParam(required = false, defaultValue = "DESC") String order) {
		
		int memberId = rq.getLoginedMemberId();
		Project project = projectService.getProjectByProjectId(projectId);
		
		List<Article> articles = articleService.getArticles(projectId, column, order);
		List<Group> groups = groupService.getGroups(projectId);
		
		int teamId = project.getTeamId();
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		List<ChatRoom> chatRooms = chatService.getChatRoomsByMemberId(memberId);
		Member member = memberService.getMemberById(memberId);
		Member loginedMember = memberService.getMemberById(rq.getLoginedMemberId());
		
		
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
		model.addAttribute("projects", projects);
		model.addAttribute("chatRooms", chatRooms);
		model.addAttribute("articles", articles);
		model.addAttribute("groups", groups);
		model.addAttribute("groupedArticles", groupedArticles);
		model.addAttribute("member", member);
		model.addAttribute("teamId", teamId);
		model.addAttribute("loginedMember", loginedMember);

		return "usr/project/task";
	}
	
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
		    	// groupedArticles.get(groupName) -> groupName(key)에 해당하는 List<Article> 객체(value)를 반환
		    	// List<Article> 객체(value)에 article을 add(리스트에 요소 추가)
		        groupedArticles.get(groupName).add(article);
		    }
		}
		
		return groupedArticles;
	}
	
	
	
	
	@RequestMapping("/usr/project/getMembers")
	@ResponseBody
	public List<String> getMembersByName(@RequestParam String term, int projectId) {
		
		if (term.equals(" ")) {
	        return memberService.getMembers(projectId);
	    }
		
		return projectService.getMembersByName(term, projectId);
	}
	
	@RequestMapping("/usr/project/gantt")
	public String gantt(Model model, int projectId, @RequestParam(required = false, defaultValue = "id") String column, @RequestParam(required = false, defaultValue = "DESC") String order) {
		
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
		model.addAttribute("projectId", projectId);
		model.addAttribute("articles", articles);
		model.addAttribute("groups", groups);
		model.addAttribute("groupedArticles", groupedArticles);
		
		
		
		
		return "usr/project/gantt"; 
	}
	
	@RequestMapping("/usr/project/inviteProjectMember")
	@ResponseBody
	public ResultData inviteProjectMember(int memberId, int projectId) {

		if (projectService.isMemberAlreadyInProject(memberId, projectId)) {
	        return ResultData.from("F-1", "이미 프로젝트에 참여중인 멤버입니다");
	    }
		
		projectService.addMemberToProject(memberId, projectId);
		
		return ResultData.from("S-1", "멤버 초대 성공");
	}
	
	
	@RequestMapping("/usr/project/schd")
	public String gantt(Model model, int projectId) {
		int memberId = rq.getLoginedMemberId();
		
		List<Group> groups = groupService.getGroups(projectId);
		Project project = projectService.getProjectByProjectId(projectId);
		
		int teamId = project.getTeamId();
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		List<ChatRoom> chatRooms = chatService.getChatRoomsByMemberId(memberId);
		
		Member member = memberService.getMemberById(memberId);
		Member loginedMember = memberService.getMemberById(rq.getLoginedMemberId());
		
		model.addAttribute("projectId", projectId);
		model.addAttribute("projects", projects);
		model.addAttribute("teamId", teamId);
		model.addAttribute("chatRooms", chatRooms);
		model.addAttribute("project", project);
		model.addAttribute("groups", groups);
		
		model.addAttribute("member", member);
		model.addAttribute("teamId", teamId);
		model.addAttribute("loginedMember", loginedMember);
		
		return "usr/project/schd"; 
	}
	
	@RequestMapping("/usr/project/file")
	public String file(Model model, int projectId) {
		int memberId = rq.getLoginedMemberId();
		
		Project project = projectService.getProjectByProjectId(projectId);
		int teamId = project.getTeamId();
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		List<ChatRoom> chatRooms = chatService.getChatRoomsByMemberId(memberId);
		List<FileResponse> projectFiles = fileService.findAllFileByProjectId(projectId);
		
		
		model.addAttribute("project", project);
		model.addAttribute("projects", projects);
		model.addAttribute("teamId", teamId);
		model.addAttribute("chatRooms", chatRooms);
		model.addAttribute("projectFiles", projectFiles);
		
		return "usr/project/file"; 
	}
	

}

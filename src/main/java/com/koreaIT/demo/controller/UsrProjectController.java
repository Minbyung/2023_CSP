package com.koreaIT.demo.controller;

import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.Collections;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.beans.factory.annotation.Value;

import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.CalendarScopes;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventDateTime;


import com.koreaIT.demo.service.ArticleService;
import com.koreaIT.demo.service.BoardService;
import com.koreaIT.demo.service.ChatService;
import com.koreaIT.demo.service.FileService;
import com.koreaIT.demo.service.GroupService;
import com.koreaIT.demo.service.MeetingService;
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
import com.koreaIT.demo.vo.ZoomMeetingResponse;

@Controller
public class UsrProjectController {
	
	private ProjectService projectService;
	private ArticleService articleService;
	private GroupService groupService;
	private FileService fileService;
	private MemberService memberService;
	private ChatService chatService;
	private MeetingService meetingService;
	private Rq rq;
	
	private static final String APPLICATION_NAME = "teamup";
    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static final String TOKENS_DIRECTORY_PATH = "tokens";
	
    @Value("${google.client.id}")
    private String clientId;

    @Value("${google.client.secret}")
    private String clientSecret;

    @Value("${google.client.redirect-uri}")
    private String redirectUri;

    private AuthorizationCodeFlow flow;
	
	UsrProjectController(ProjectService projectService, ChatService chatService, MemberService memberService, ArticleService articleService, GroupService groupService, FileService fileService, MeetingService meetingService, Rq rq) throws Exception {
		this.projectService = projectService;
		this.articleService = articleService;
		this.groupService = groupService;
		this.fileService = fileService;
		this.memberService = memberService;
		this.chatService = chatService;
		this.meetingService = meetingService;
		this.rq = rq;
		
		NetHttpTransport httpTransport = GoogleNetHttpTransport.newTrustedTransport();
        FileDataStoreFactory dataStoreFactory = new FileDataStoreFactory(new java.io.File(TOKENS_DIRECTORY_PATH));

        GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, 
            new InputStreamReader(UsrProjectController.class.getResourceAsStream("/client_secrets.json")));

        flow = new GoogleAuthorizationCodeFlow.Builder(
            httpTransport, JSON_FACTORY, clientSecrets, Collections.singleton(CalendarScopes.CALENDAR_READONLY))
            .setDataStoreFactory(dataStoreFactory)
            .setAccessType("offline")
            .build();
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
		model.addAttribute("projectId", projectId);
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
	public ResultData inviteProjectMember(Integer memberId, Integer projectId) {

		if (projectService.isMemberAlreadyInProject(memberId, projectId)) {
	        return ResultData.from("F-1", "이미 프로젝트에 참여중인 멤버입니다");
	    }
		
		projectService.addMemberToProject(memberId, projectId);
		
		return ResultData.from("S-1", "멤버 초대 성공");
	}
	
	
	@RequestMapping("/usr/project/schd")
	public String gantt(Model model, int projectId, HttpSession session) throws Exception {
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
		
		String id = "id";
		String DESC = "DESC";
		
		List<Article> articles = articleService.getArticles(projectId, id, DESC);
		model.addAttribute("articles", articles);
		
		// Google Calendar 데이터 추가 (기본적으로 비어 있는 상태로 시작)
        List<com.google.api.services.calendar.model.Event> googleEvents = new ArrayList<>();
        model.addAttribute("googleEvents", googleEvents);
		
		return "usr/project/schd"; 
	}
	
	@RequestMapping("/usr/project/schd/google")
    public String addGoogleEvents(@RequestParam("projectId") int projectId, HttpSession session, Model model) throws Exception {
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

        String id = "id";
		String DESC = "DESC";
		
		List<Article> articles = articleService.getArticles(projectId, id, DESC);
		model.addAttribute("articles", articles);
		
        // Google Calendar 데이터 추가
        List<com.google.api.services.calendar.model.Event> googleEvents = new ArrayList<>();
        Credential credential = (Credential) session.getAttribute("credential");
        if (credential != null) {
            Calendar service = new Calendar.Builder(GoogleNetHttpTransport.newTrustedTransport(), JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();

            Calendar.Events.List request = service.events().list("primary");
            com.google.api.services.calendar.model.Events events = request.execute();
            googleEvents = events.getItems();
        }
        model.addAttribute("googleEvents", googleEvents);

        return "usr/project/schd";
    }

    @GetMapping("/authorize")
    public String authorize(HttpServletRequest request, @RequestParam("projectId") String projectId) {
        AuthorizationCodeRequestUrl authorizationUrl = flow.newAuthorizationUrl();
        authorizationUrl.setRedirectUri(redirectUri);
        authorizationUrl.setState(projectId);
        return "redirect:" + authorizationUrl.build();
    }

    @GetMapping("/oauth2callback")
    public String oauth2Callback(@RequestParam("code") String code, @RequestParam("state") String projectId, HttpSession session) throws Exception {
        TokenResponse tokenResponse = flow.newTokenRequest(code).setRedirectUri(redirectUri).execute();
        Credential credential = flow.createAndStoreCredential(tokenResponse, "user");
        session.setAttribute("credential", credential);
        return "redirect:/usr/project/schd/google?projectId=" + projectId;
    }
	
    @PostMapping("/usr/project/updateGoogleEvent")
    public String updateGoogleEvent(@RequestParam("eventId") String eventId,
                                    @RequestParam("start") String start,
                                    @RequestParam("end") String end,
                                    HttpSession session) throws Exception {
        Credential credential = (Credential) session.getAttribute("credential");
        if (credential != null) {
            Calendar service = new Calendar.Builder(GoogleNetHttpTransport.newTrustedTransport(), JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();

            Event event = service.events().get("primary", eventId).execute();
            event.setStart(new EventDateTime().setDateTime(new com.google.api.client.util.DateTime(start)));
            event.setEnd(new EventDateTime().setDateTime(new com.google.api.client.util.DateTime(end)));

            service.events().update("primary", eventId, event).execute();
        }
        
        System.out.println("eventId : " + eventId);
        return "redirect:/usr/project/schd";
    }
    
    @GetMapping("/checkCredential")
    @ResponseBody
    public Map<String, Object> checkCredential(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Credential credential = (Credential) session.getAttribute("credential");
        response.put("hasCredential", credential != null);
        return response;
    }
	
	@RequestMapping("/usr/project/file")
	public String file(Model model, int projectId) {
		int memberId = rq.getLoginedMemberId();
		
		Project project = projectService.getProjectByProjectId(projectId);
		int teamId = project.getTeamId();
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		List<ChatRoom> chatRooms = chatService.getChatRoomsByMemberId(memberId);
		List<FileResponse> projectFiles = fileService.findAllFileByProjectId(projectId);
		Member member = memberService.getMemberById(memberId);
		Member loginedMember = memberService.getMemberById(rq.getLoginedMemberId());
		
		model.addAttribute("project", project);
		model.addAttribute("projectId", projectId);
		model.addAttribute("projects", projects);
		model.addAttribute("teamId", teamId);
		model.addAttribute("chatRooms", chatRooms);
		model.addAttribute("projectFiles", projectFiles);
		model.addAttribute("member", member);
		model.addAttribute("loginedMember", loginedMember);
		
		return "usr/project/file"; 
	}
	
	@RequestMapping("/usr/project/meeting")
	public String meeting(Model model, int projectId) {
		
		int memberId = rq.getLoginedMemberId();
		Project project = projectService.getProjectByProjectId(projectId);
		int teamId = project.getTeamId();
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		List<ChatRoom> chatRooms = chatService.getChatRoomsByMemberId(memberId);
		Member member = memberService.getMemberById(memberId);
		Member loginedMember = memberService.getMemberById(rq.getLoginedMemberId());
		
		List<ZoomMeetingResponse> meetingInfos = meetingService.getMeetingInfo(projectId);
        model.addAttribute("meetingInfos", meetingInfos);

		model.addAttribute("project", project);
		model.addAttribute("projectId", projectId);
		model.addAttribute("projects", projects);
		model.addAttribute("chatRooms", chatRooms);
		model.addAttribute("member", member);
		model.addAttribute("teamId", teamId);
		model.addAttribute("loginedMember", loginedMember);

		return "usr/project/meeting";
	}
	
	

}

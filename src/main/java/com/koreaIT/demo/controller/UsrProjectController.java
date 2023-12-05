package com.koreaIT.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.BoardService;
import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.ProjectService;
import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.Board;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Project;
import com.koreaIT.demo.vo.Reply;
import com.koreaIT.demo.vo.Rq;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UsrProjectController {
	
	private ProjectService projectService;
	private BoardService boardService;
	private ReplyService replyService;
	private MemberService memberService;
	private Rq rq;
	
	UsrProjectController(ProjectService projectService, BoardService boardService, ReplyService replyService, MemberService memberService, Rq rq) {
		this.projectService = projectService;
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
	public String detail(Model model, int id) {
		
		Project project = projectService.getProjectByProjectId(id);
		
		model.addAttribute("project", project);
		
		return "usr/project/detail";
	}
	
	
	

}

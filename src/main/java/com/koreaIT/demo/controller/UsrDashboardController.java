package com.koreaIT.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.koreaIT.demo.service.ArticleService;
import com.koreaIT.demo.service.BoardService;
import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.ProjectService;
import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Project;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrDashboardController {
	
	private ProjectService projectService;
	private MemberService memberService;
	private Rq rq;
	
	UsrDashboardController(ProjectService projectService, MemberService memberService, Rq rq) {
		this.projectService = projectService;
		this.memberService = memberService;
		this.rq = rq;
	}
	
	
	
	@RequestMapping("/usr/dashboard/dashboard")
	public String Dashboard(Model model, int teamId) {
		List<Project> projects = projectService.getProjectsByTeamId(teamId);
		List<Member> teamMembers = memberService.getMembersByTeamId(teamId);
		
		model.addAttribute("projects", projects);
		model.addAttribute("teamMembers", teamMembers);
		model.addAttribute("teamId", teamId);
		
		return "usr/dashboard/dashboard";
	}
	
	
}

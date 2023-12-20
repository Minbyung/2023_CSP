package com.koreaIT.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.ProjectService;
import com.koreaIT.demo.service.TeamService;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Project;
import com.koreaIT.demo.vo.Rq;
import com.koreaIT.demo.vo.Team;

@Controller
public class UsrDashboardController {
	
	private ProjectService projectService;
	private MemberService memberService;
	private TeamService teamService;
	private Rq rq;
	
	UsrDashboardController(ProjectService projectService, MemberService memberService, TeamService teamService, Rq rq) {
		this.projectService = projectService;
		this.memberService = memberService;
		this.teamService = teamService;
		this.rq = rq;
	}
	
	
	
	@RequestMapping("/usr/dashboard/dashboard")
	public String Dashboard(Model model, int teamId) {
		
		int memberId = rq.getLoginedMemberId();
		
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		List<Member> teamMembers = memberService.getMembersByTeamId(teamId);
		int teamMembersCnt = memberService.getTeamMembersCnt(teamId);
		String teamName = teamService.getTeamNameByTeamId(teamId);
		
		
		model.addAttribute("projects", projects);
		model.addAttribute("teamMembers", teamMembers);
		model.addAttribute("teamId", teamId);
		model.addAttribute("teamMembersCnt", teamMembersCnt);
		model.addAttribute("teamName", teamName);
		
		return "usr/dashboard/dashboard";
	}
	
	
}

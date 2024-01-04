package com.koreaIT.demo.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

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
	
	@RequestMapping("/usr/dashboard/dashboardTest")
	public String DashboardTest(Model model, int teamId) {
		
		int memberId = rq.getLoginedMemberId();
		
		List<Project> projects = projectService.getProjectsByTeamIdAndMemberId(teamId, memberId);
		List<Member> teamMembers = memberService.getMembersByTeamId(teamId);
		int teamMembersCnt = memberService.getTeamMembersCnt(teamId);
		String teamName = teamService.getTeamNameByTeamId(teamId);
		Member member = memberService.getMemberById(memberId);
		
		
		// 날짜와 오전인지 오후인지
		SimpleDateFormat amPmFormat = new SimpleDateFormat("a", Locale.KOREAN);
		SimpleDateFormat dateFormatWithDay = new SimpleDateFormat("yyyy-MM-dd E", Locale.KOREA);
		
	    String amOrPm = amPmFormat.format(new Date());
	    String currentDate = dateFormatWithDay.format(new Date());
		
	    
	    
		model.addAttribute("projects", projects);
		model.addAttribute("teamMembers", teamMembers);
		model.addAttribute("teamId", teamId);
		model.addAttribute("teamMembersCnt", teamMembersCnt);
		model.addAttribute("teamName", teamName);
		model.addAttribute("member", member);
		model.addAttribute("amOrPm", amOrPm);
		model.addAttribute("currentDate", currentDate);
		
		
		
		
		return "usr/dashboard/dashboardTest";
	}
	
}

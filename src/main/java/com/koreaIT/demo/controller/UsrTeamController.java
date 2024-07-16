package com.koreaIT.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.TeamInviteService;
import com.koreaIT.demo.service.TeamService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrTeamController {
	
	private TeamInviteService teamInviteService;
	private TeamService teamService;
	private Rq rq;
	
	UsrTeamController(TeamInviteService teamInviteService, TeamService teamService, Rq rq) {
		this.teamInviteService = teamInviteService;
		this.teamService = teamService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/member/doInvite")
	@ResponseBody
    public String inviteMember(int teamId , String email) {
        teamInviteService.inviteMember(teamId, email);
        
        
        return Util.jsReplace("초대했습니다", Util.f("detail?id=%d", teamId));
    }
	
	@RequestMapping("/usr/team/getTeamByInviteCode")
	@ResponseBody
	public String getTeamByInviteCode(String inviteCode) {
		
		return teamService.getTeamByInviteCode(inviteCode);
	}
}

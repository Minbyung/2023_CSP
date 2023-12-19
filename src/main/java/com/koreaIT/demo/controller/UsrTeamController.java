package com.koreaIT.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.TeamInviteService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.ResultData;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrTeamController {
	
	private TeamInviteService teamInviteService;
	private Rq rq;
	
	UsrTeamController(TeamInviteService teamInviteService, Rq rq) {
		this.teamInviteService = teamInviteService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/member/doInvite")
	@ResponseBody
    public String inviteMember(int teamId , String email) {
        teamInviteService.inviteMember(teamId, email);
        
        
        return Util.jsReplace("프로젝트를 생성했습니다", Util.f("detail?id=%d", teamId));
    }
	
	
}

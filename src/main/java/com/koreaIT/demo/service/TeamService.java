package com.koreaIT.demo.service;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.TeamDao;
import com.koreaIT.demo.vo.Team;

@Service
public class TeamService {
	private TeamDao teamDao;
	
	public TeamService(TeamDao teamDao) {
		this.teamDao = teamDao;	
	}

	public String getTeamByInviteCode(String inviteCode) {
		Team team = teamDao.getTeamByInviteCode(inviteCode);
		String teamName = team.getTeamName();
		return teamName;
	}
}
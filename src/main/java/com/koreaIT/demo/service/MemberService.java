package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.MemberDao;
import com.koreaIT.demo.dao.TeamDao;
import com.koreaIT.demo.dao.TeamInviteDao;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.TeamInvite;

@Service
public class MemberService {

	private MemberDao memberDao;
	private TeamInviteDao teamInviteDao;
	private TeamDao teamDao;

	public MemberService(MemberDao memberDao, TeamInviteDao teamInviteDao, TeamDao teamDao) {
		this.memberDao = memberDao;
		this.teamInviteDao = teamInviteDao;
		this.teamDao = teamDao;
	}

	public void joinMember(String name, String teamName, String cellphoneNum, String loginId, String loginPw) {
		
		memberDao.joinMember(name, cellphoneNum, loginId, loginPw);
		
		 if (teamName != null && !teamName.isEmpty()) {
	            teamDao.insert(teamName);
		 }
		     
        int memberId = getLastInsertId();
		int teamId = teamDao.getLastInsertId();
		memberDao.insert(memberId, teamId);	
	}
	
	public void joinMemberWithInvite(String name, String cellphoneNum, String loginId, String loginPw, String inviteCode) {
	
		memberDao.joinMember(name, cellphoneNum, loginId, loginPw);
		
		 
		// 초대 코드가 있는 경우에만 해당 팀에 추가합니다.
	    if (inviteCode != null && !inviteCode.isEmpty()) {
	        // 초대 코드를 사용하여 데이터베이스에서 해당 팀의 정보를 찾아옵니다.
	        TeamInvite invite = teamInviteDao.findByCode(inviteCode);
	        if (invite == null) {
	            throw new IllegalArgumentException("Invalid invite code.");
	        }
	        
	        int memberId = getLastInsertId();
			int teamId = invite.getTeamId();
			memberDao.insert(memberId, teamId);
	        
	    }
		
	}
	public Member getMemberById(int id) {
		return memberDao.getMemberById(id);
	}

	public int getLastInsertId() {
		return memberDao.getLastInsertId();
	}

	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}

	public void doModify(int id, String name, String nickname, String cellphoneNum, String email) {
		memberDao.doModify(id, name, nickname, cellphoneNum, email);
	}

	public void doPasswordModify(int id, String loginPw) {
		memberDao.doPasswordModify(id, loginPw);
	}

	public List<String> getMembers() {
		
		return memberDao.getMembers();
	}
}

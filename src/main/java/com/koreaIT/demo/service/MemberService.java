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

	public void joinMember(String name, String nickname, String teamName, String cellphoneNum, String loginId, String loginPw, String profilePhotoPath) {
		
		memberDao.joinMember(name, nickname, cellphoneNum, loginId, loginPw, profilePhotoPath);
		
		int memberId = memberDao.getLastInsertId();
		
		 if (teamName != null && !teamName.isEmpty()) {
	            teamDao.insert(teamName);
		 }
		int teamId = teamDao.getLastInsertId();
		memberDao.insert(memberId, teamId);	
	}
	
	public void joinMemberWithInvite(String name, String nickName, String cellphoneNum, String loginId, String loginPw, String inviteCode, String profilePhotoPath) {
	
		memberDao.joinMember(name, nickName, cellphoneNum, loginId, loginPw, profilePhotoPath);
		
		 
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

	public int getLastInsertId() {
		return memberDao.getLastInsertId();
	}

	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}
	
	public Member getMemberByNickname(String nickname) {
		return memberDao.getMemberByNickname(nickname);
	}
	
	public Member getMemberById(int id) {
		return memberDao.getMemberById(id);
	}
	
	public void doModify(int id, String name, String nickname, String cellphoneNum, String profilePhotoPath) {
		memberDao.doModify(id, name, nickname, cellphoneNum, profilePhotoPath);
	}

	public void doPasswordModify(int id, String loginPw) {
		memberDao.doPasswordModify(id, loginPw);
	}

	public List<String> getMembers(int projectId) {
		
		return memberDao.getMembers(projectId);
	}

	public List<Member> getMembersByTeamId(int teamId, int loginedMemberId) {
		
		return memberDao.getMembersByTeamId(teamId, loginedMemberId);
	}

	public int getTeamMembersCnt(int teamId) {
		
		return memberDao.getTeamMembersCnt(teamId);
	}

	public List<Member> getprojectMembersByprojectId(int projectId, int loginedMemberId) {
		
		return memberDao.getprojectMembersByprojectId(projectId, loginedMemberId);
	}

	public List<Integer> getprojectMembersIdByprojectId(int groupChatRoomId) {
		
		return memberDao.getprojectMembersIdByprojectId(groupChatRoomId);
	}

	public int getProjectMembersCnt(int projectId) {
		return memberDao.getProjectMembersCnt(projectId);
	}

	public String getProfilePhotoPathByMemberId(Long memberId) {
		
		return memberDao.getProfilePhotoPathByMemberId(memberId);
	}
	
	public List<Member> getAllMembers(int limitStart, int itemsInAPage) {
		return memberDao.getAllMembers(limitStart, itemsInAPage);
	}
	public List<Member> getActiveMembers(int limitStart, int itemsInAPage) {
		return memberDao.getActiveMembers(limitStart, itemsInAPage);
	}
	public List<Member> getInactiveMembers(int limitStart, int itemsInAPage) {
		return memberDao.getInactiveMembers(limitStart, itemsInAPage);
	}

	public void deleteMembers(List<Long> memberIds) {
		for (Long id : memberIds) {
            memberDao.deleteMember(id);
        }
		
	}
	
	public void deleteMember(long memberId) {
		memberDao.deleteMember(memberId);
	}
	
	public void activateMembers(List<Long> memberIds) {
		for (Long id : memberIds) {
            memberDao.activateMember(id);
        }
	}
	
	public int getMembersCnt() {
		return memberDao.getMembersCnt();
	}

	public int getActiveMembersCnt() {
		return memberDao.getActiveMembersCnt();
	}

	public int getInactiveMembersCnt() {
		return memberDao.getInactiveMembersCnt();
	}

	public List<Member> searchMembers(String keyword, int limitStart, int itemsInAPage) {
		
		return memberDao.searchMembers(keyword, limitStart, itemsInAPage);
	}

	public int getSearchMembersCnt(String keyword) {
		
		return memberDao.getSearchMembersCnt(keyword);
	}

	public int getMemberIdByMembername(String manager) {
		
		return memberDao.getMemberIdByMembername(manager);
	}
}

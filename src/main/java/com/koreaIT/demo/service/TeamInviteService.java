package com.koreaIT.demo.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.TeamInviteDao;
import com.koreaIT.demo.util.Util;

@Service
public class TeamInviteService {
	private TeamInviteDao teamInviteDao;
	private JavaMailSender mailSender;
	
	public TeamInviteService(TeamInviteDao teamInviteDao, JavaMailSender mailSender) {
		this.teamInviteDao = teamInviteDao;	
		this.mailSender = mailSender;	
	}

    public void inviteMember(int teamId, String email) {
        // 초대 코드 생성 로직
        String inviteCode = Util.generateInviteCode();

        // DB에 저장
        teamInviteDao.insertTeamInvite(teamId, inviteCode);
        
        
        sendInviteEmail(email, inviteCode);

    }

    private void sendInviteEmail(String to, String inviteCode) {
    	SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Team Invitation");

        String signupUrl = "http://localhost:8082/usr/member/join?inviteCode=" + inviteCode;
        String emailText = "Please click the following link to join our team: " + signupUrl;

        message.setText(emailText);
        mailSender.send(message);
    }
}
package com.koreaIT.demo.service;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.ReplyDao;

@Service
public class MeetingService {
	
	private ReplyDao replyDao;
	
	public MeetingService(ReplyDao replyDao) {
		this.replyDao = replyDao;
	}

	public void writeReply(int memberId, String relTypeCode, int relId, String body) {
		replyDao.writeReply(memberId, relTypeCode, relId, body);
	}
}

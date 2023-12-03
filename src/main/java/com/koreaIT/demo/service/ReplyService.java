package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.ReplyDao;
import com.koreaIT.demo.vo.Reply;

@Service
public class ReplyService {
	
	private ReplyDao replyDao;
	
	public ReplyService(ReplyDao replyDao) {
		this.replyDao = replyDao;
	}

	public void writeReply(int memberId, String relTypeCode, int relId, String body) {
		replyDao.writeReply(memberId, relTypeCode, relId, body);
	}

	public int getLastInsertId() {
		return replyDao.getLastInsertId();
	}

	public List<Reply> getReplies(String relTypeCode, int relId) {
		return replyDao.getReplies(relTypeCode, relId);
	}

	public Reply forPrintReply(int id) {
		return replyDao.forPrintReply(id);
	}
	
	public Reply getReplyById(int id) {
		return replyDao.getReplyById(id);
	}
	
	public void modifyReply(int id, String body) {
		replyDao.modifyReply(id, body);
	}

	public void deleteReply(int id) {
		replyDao.deleteReply(id);
	}
}

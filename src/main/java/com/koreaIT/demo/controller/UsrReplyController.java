package com.koreaIT.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Reply;
import com.koreaIT.demo.vo.ResultData;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrReplyController {

	private ReplyService replyService;
	private Rq rq;
	
	UsrReplyController(ReplyService replyService, Rq rq) {
		this.replyService = replyService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/reply/doWrite")
	@ResponseBody
	public String doWrite(String body, String relTypeCode, int relId) {
		
		if (Util.empty(body)) {
			return Util.jsHistoryBack("내용을 입력해주세요");
		}
		
		replyService.writeReply(rq.getLoginedMemberId(), relTypeCode, relId, body);
		
		int id = replyService.getLastInsertId();
		
		return Util.jsReplace(Util.f("%d번 댓글을 생성했습니다", id), Util.f("../article/detail?id=%d", relId));
	}
	
	@RequestMapping("/usr/reply/getReplyContent")
	@ResponseBody
	public ResultData<Reply> getReplyContent(int id) {
		
		Reply reply = replyService.forPrintReply(id);
		
		if (reply == null) {
			return ResultData.from("F-1", Util.f("%d번 댓글은 존재하지 않습니다", id));
		}
		
		return ResultData.from("S-1", "댓글 정보 조회 성공", reply);
	}
	
	@RequestMapping("/usr/reply/doModify")
	@ResponseBody
	public String doModify(int id, String body) {
		
		Reply reply = replyService.getReplyById(id);
		
		if (reply == null) {
			return Util.jsHistoryBack(Util.f("%d번 댓글은 존재하지 않습니다", id));
		}
		
		if (rq.getLoginedMemberId() != reply.getMemberId()) {
			return Util.jsHistoryBack("해당 댓글에 대한 권한이 없습니다");
		}
		
		replyService.modifyReply(id, body);
		
		return Util.jsReplace(Util.f("%d번 댓글을 수정했습니다", id), Util.f("../article/detail?id=%d", reply.getRelId()));
	}
	
	@RequestMapping("/usr/reply/doDelete")
	@ResponseBody
	public String doDelete(int id) {
		
		Reply reply = replyService.getReplyById(id);
		
		if (reply == null) {
			return Util.jsHistoryBack(Util.f("%d번 댓글은 존재하지 않습니다", id));
		}
		
		if (rq.getLoginedMemberId() != reply.getMemberId()) {
			return Util.jsHistoryBack("해당 댓글에 대한 권한이 없습니다");
		}
		
		replyService.deleteReply(id);
		
		return Util.jsReplace(Util.f("%d번 댓글을 삭제했습니다", id), Util.f("../article/detail?id=%d", reply.getRelId()));
	}
	
}

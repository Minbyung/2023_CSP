package com.koreaIT.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Rq;

@Controller
public class AdmMemberController {
	
	private MemberService memberService;
	private Rq rq;
	
	public AdmMemberController(MemberService memberService, Rq rq) {
		this.memberService = memberService;
		this.rq = rq;
	}
	
	
	@RequestMapping("/adm/member/main")
	public String main(Model model, @RequestParam(defaultValue = "1") int page, @RequestParam(required = false) String keyword) {
		
		if (page <= 0) {
			return rq.jsReturnOnView("페이지번호가 올바르지 않습니다");
		}
		
		int itemsInAPage = 10;
		int limitStart = (page - 1) * itemsInAPage;
		
		List<Member> allMembers;
		int allMembersCnt;
		
		if (keyword != null && !keyword.isEmpty()) {
	        allMembers = memberService.searchMembers(keyword, limitStart, itemsInAPage);
	        allMembersCnt = memberService.getSearchMembersCnt(keyword);
	        model.addAttribute("keyword", keyword);
	    } else {
	        allMembers = memberService.getAllMembers(limitStart, itemsInAPage);
	        allMembersCnt = memberService.getMembersCnt();
	    }

		int allMembersPagesCnt = (int) Math.ceil((double) allMembersCnt / itemsInAPage);
		
		int activeMembersCnt = memberService.getActiveMembersCnt();
		int activeMembersPagesCnt = (int) Math.ceil((double) activeMembersCnt / itemsInAPage);
		
		int inactiveMembersCnt = memberService.getInactiveMembersCnt();
		int inactiveMembersPagesCnt = (int) Math.ceil((double) inactiveMembersCnt / itemsInAPage);

		List<Member> activeMembers = memberService.getActiveMembers(limitStart, itemsInAPage);
		List<Member> inactiveMembers = memberService.getInactiveMembers(limitStart, itemsInAPage);
		
		model.addAttribute("allMembers", allMembers);
		model.addAttribute("allMembersPagesCnt", allMembersPagesCnt);
		
		model.addAttribute("activeMembers", activeMembers);
		model.addAttribute("activeMembersPagesCnt", activeMembersPagesCnt);
		
		model.addAttribute("inactiveMembers", inactiveMembers);
		model.addAttribute("inactiveMembersPagesCnt", inactiveMembersPagesCnt);
		
		model.addAttribute("page", page);

		return "adm/member/main";
	}
	
	@PostMapping("/member/delete")
    public String deleteMembers(@RequestParam("memberIds") List<Long> memberIds) {
        memberService.deleteMembers(memberIds);
        
        return "redirect:/adm/member/main";
    }
	@PostMapping("/member/activate")
    public String activateMembers(@RequestParam("memberIds") List<Long> memberIds) {
        memberService.activateMembers(memberIds);
        
        return "redirect:/adm/member/main";
    }
	
}

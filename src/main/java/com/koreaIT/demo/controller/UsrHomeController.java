package com.koreaIT.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrHomeController {
	
	private Rq rq;
	private MemberService memberService;
	
	UsrHomeController(Rq rq, MemberService memberService) {
		this.rq = rq;
		this.memberService = memberService;
	}
	
	
	@RequestMapping("/usr/home/main")
	public String showMain(Model model) {
		int id = rq.getLoginedMemberId();
		Member member = memberService.getMemberById(id);
		
		
		
		model.addAttribute("member", member);
		
		return "usr/home/main";
	}
	
	@RequestMapping("/")
	public String showRoot() {
		return "redirect:/usr/home/main";
	}
	
}

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
	public String main(Model model) {
		
		List<Member> allMembers = memberService.getAllMembers();
		List<Member> activeMembers = memberService.getActiveMembers();
		List<Member> inactiveMembers = memberService.getInactiveMembers();
		
		
		model.addAttribute("allMembers", allMembers);
		model.addAttribute("activeMembers", activeMembers);
		model.addAttribute("inactiveMembers", inactiveMembers);
		

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

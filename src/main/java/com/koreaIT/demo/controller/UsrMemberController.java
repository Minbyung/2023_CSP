package com.koreaIT.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.ResultData;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrMemberController {
	
	private MemberService memberService;
	private Rq rq;
	
	UsrMemberController(MemberService memberService, Rq rq) {
		this.memberService = memberService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/member/join")
	public String join() {
		return "usr/member/join";
	}
	
	@RequestMapping("/usr/member/loginIdDupChk")
	@ResponseBody
	public ResultData loginIdDupChk(String loginId) {
		
		if (Util.empty(loginId)) {
			return ResultData.from("F-1", "아이디를 입력해주세요");
		}
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member != null) {
			return ResultData.from("F-2", Util.f("%s은(는) 이미 사용중인 아이디입니다", loginId));
		}
		
		return ResultData.from("S-1", Util.f("%s은(는) 사용 가능한 아이디입니다", loginId));
	}
	
	@RequestMapping("/usr/member/doJoin")
	@ResponseBody
	public String doJoin(String loginId, String loginPw, String name, String teamName, String cellphoneNum) {
		
		if (rq.getLoginedMemberId() != 0) {
			return Util.jsHistoryBack("로그아웃 후 이용해주세요");
		}
		
		if (Util.empty(loginId)) {
			return Util.jsHistoryBack("이메일을 입력해주세요");
		}
		if (Util.empty(loginPw)) {
			return Util.jsHistoryBack("비밀번호를 입력해주세요");
		}
		if (Util.empty(name)) {
			return Util.jsHistoryBack("이름을 입력해주세요");
		}
		if (Util.empty(teamName)) {
			return Util.jsHistoryBack("팀 이름 (회사 또는 단체명)을 입력해주세요");
		}
		if (Util.empty(cellphoneNum)) {
			return Util.jsHistoryBack("전화번호를 입력해주세요");
		}
		
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member != null) {
			return Util.jsHistoryBack(Util.f("이미 사용중인 아이디(%s) 입니다", loginId));
		}
		
		memberService.joinMember(loginId, loginPw, name, teamName, cellphoneNum);
		
		return Util.jsReplace(Util.f("%s님의 가입이 완료되었습니다", name), "login");
	}
	
	@RequestMapping("/usr/member/login")
	public String login() {
		return "usr/member/login";
	}
	
	@RequestMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw) {
		
		if (rq.getLoginedMemberId() != 0) {
			return Util.jsHistoryBack("로그아웃 후 이용해주세요");
		}
		
		if (Util.empty(loginId)) {
			return Util.jsHistoryBack("아이디를 입력해주세요");
		}
		if (Util.empty(loginPw)) {
			return Util.jsHistoryBack("비밀번호를 입력해주세요");
		}
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member == null) {
			return Util.jsHistoryBack(Util.f("%s은(는) 존재하지 않는 아이디입니다", loginId));
		}
		
		if (member.getLoginPw().equals(loginPw) == false) {
			return Util.jsHistoryBack("비밀번호를 확인해주세요");
		}
		
		rq.login(member);
		
		return Util.jsReplace(Util.f("%s 회원님 환영합니다~", member.getName()), "/usr/dashboard/dashboard");
	}
	
	@RequestMapping("/usr/member/doLogout")
	@ResponseBody
	public String doLogout() {
		
		rq.logout();
		
		return Util.jsReplace("정상적으로 로그아웃 되었습니다", "/");
	}
	
	@RequestMapping("/usr/member/myPage")
	public String myPage(Model model) {
		
		Member member = memberService.getMemberById(rq.getLoginedMemberId());

		model.addAttribute("member", member);
		
		return "usr/member/myPage";
	}
	
	@RequestMapping("/usr/member/checkPassword")
	public String checkPassword(Model model, String loginId) {
		model.addAttribute("loginId", loginId);
		
		return "usr/member/checkPassword";
	}
	
	@RequestMapping("/usr/member/doCheckPassword")
	public String doCheckPassword(Model model, String loginPw) {
		
		if (Util.empty(loginPw)) {
			return rq.jsReturnOnView("비밀번호를 입력해주세요"); 
		}
		
		Member member = memberService.getMemberById(rq.getLoginedMemberId());
		
		if (member.getLoginPw().equals(loginPw) == false) {
			return rq.jsReturnOnView("비밀번호가 일치하지 않습니다");
		}
		
		model.addAttribute("member", member);
		
		return "usr/member/modify";
	}
	
	@RequestMapping("/usr/member/doModify")
	@ResponseBody
	public String doModify(String name, String nickname, String cellphoneNum, String email) {
		
		if (Util.empty(name)) {
			return Util.jsHistoryBack("이름을 입력해주세요"); 
		}
		
		if (Util.empty(nickname)) {
			return Util.jsHistoryBack("닉네임을 입력해주세요"); 
		}
		
		if (Util.empty(cellphoneNum)) {
			return Util.jsHistoryBack("전화번호를 입력해주세요"); 
		}
		
		if (Util.empty(email)) {
			return Util.jsHistoryBack("이메일을 입력해주세요"); 
		}
		
		memberService.doModify(rq.getLoginedMemberId(), name, nickname, cellphoneNum, email);
		
		return Util.jsReplace(Util.f("%s님의 회원정보가 수정되었습니다", name), "myPage");
	}
	
	@RequestMapping("/usr/member/passwordModify")
	public String passwordModify() {
		return "usr/member/passwordModify";
	}
	
	@RequestMapping("/usr/member/doPasswordModify")
	@ResponseBody
	public String doPasswordModify(String loginPw, String loginPwChk) {
		
		if (Util.empty(loginPw)) {
			return Util.jsHistoryBack("비밀번호를 입력해주세요"); 
		}
		
		if (Util.empty(loginPwChk)) {
			return Util.jsHistoryBack("비밀번호확인을 입력해주세요"); 
		}
		
		if (loginPw.equals(loginPwChk) == false) {
			return Util.jsHistoryBack("비밀번호가 일치하지 않습니다"); 
		}
		
		memberService.doPasswordModify(rq.getLoginedMemberId(), loginPw);
		
		return Util.jsReplace("비밀번호가 변경되었습니다", "myPage");
	}
}

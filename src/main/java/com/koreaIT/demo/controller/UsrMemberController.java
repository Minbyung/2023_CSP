package com.koreaIT.demo.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.core.io.UrlResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.ResultData;
import com.koreaIT.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrMemberController {
	
	private MemberService memberService;
	private Rq rq;
	private static final String DEFAULT_PROFILE_IMAGE_PATH = "default-profile.jpg";
	
	
	UsrMemberController(MemberService memberService, Rq rq) {
		this.memberService = memberService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/member/join")
	public String join() {
		return "usr/member/join";
	}
	
	@RequestMapping("/usr/member/joinWithInvite")
	public String joinWithInvite(@RequestParam(required = false) String inviteCode) {
		return "usr/member/joinWithInvite";
	}
	
	
	@RequestMapping("/usr/member/loginIdDupChk")
	@ResponseBody
	public ResultData loginIdDupChk(String loginId) {
		
		if (Util.empty(loginId)) {
			return ResultData.from("F-1", "아이디를 입력해주세요");
		}
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member != null) {
			return ResultData.from("F-2", Util.f("%s은(는) 이미 사용중인 아이디입니다.", loginId));
		}
		
		return ResultData.from("S-1", Util.f("%s은(는) 사용 가능한 아이디입니다.", loginId));
	}
	
	@RequestMapping("/usr/member/nicknameDupChk")
	@ResponseBody
	public ResultData nicknameDupChk(String nickname) {
		
		if (Util.empty(nickname)) {
			return ResultData.from("F-1", "닉네임 입력해주세요");
		}
		
		Member member = memberService.getMemberByNickname(nickname);
		
		if (member != null) {
			return ResultData.from("F-2", Util.f("%s은(는) 이미 사용중인 닉네임입니다.", nickname));
		}
		
		return ResultData.from("S-1", Util.f("%s은(는) 사용 가능한 닉네임입니다.", nickname));
	}
	
	@RequestMapping("/usr/member/doJoin")
	@ResponseBody
	public String doJoin(String name, String nickname, String teamName, String cellphoneNum, String loginId, String loginPw, MultipartFile profilePhoto) throws IOException {
		
		String profilePhotoPath;
		
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
		if (Util.empty(nickname)) {
			return Util.jsHistoryBack("닉네임을 입력해주세요");
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
		
		if (profilePhoto == null || profilePhoto.isEmpty()) {
            // 프로필 사진을 업로드하지 않았다면 디폴트 이미지 경로 사용
            profilePhotoPath = DEFAULT_PROFILE_IMAGE_PATH;
		} 
		else {
			// 파일명 가져오기
			String fileName = profilePhoto.getOriginalFilename();
			// 파일 저장 경로 설정
			String uploadDir = "src/main/resources/static/profile-photo/" + nickname;
		
			// 파일 저장 경로를 저장할 변수 선언 (try 블록 바깥에서 선언)
			
			// Path 객체를 사용하여 파일 저장 경로를 생성
			Path uploadPath = Paths.get(uploadDir);
			
			// 경로에 폴더가 없으면 생성
			if (!Files.exists(uploadPath)) {
			    try {
			        Files.createDirectories(uploadPath);
			    } catch (IOException e) {
			        throw new RuntimeException("Could not create upload directory", e);
			    }
			}
		
			try {
				// 파일 저장
			    Path filePath = uploadPath.resolve(fileName);
			    Files.copy(profilePhoto.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
			    
			    // 파일 저장 경로에서 기본 경로 부분을 제외한 상대 경로만 profilePhotoPath 변수에 저장
			    profilePhotoPath = nickname + "/" + fileName;
			    
			    // 윈도우 시스템에서는 경로 구분자가 '\' 이므로, 이를 '/'로 변환해주는 처리가 필요
			    profilePhotoPath = profilePhotoPath.replace('\\', '/');
			    
			    
			} catch (IOException e) {
			    throw new RuntimeException("Failed to store file", e);
			}
		}

		memberService.joinMember(name, nickname, teamName, cellphoneNum, loginId, loginPw, profilePhotoPath);
		
		return Util.jsReplace(Util.f("%s님의 가입이 완료되었습니다", name), "login");
	}
	
	
	@GetMapping("/profile-photo/{memberId}")
	public ResponseEntity<Resource> getProfilePhotoByMemberId(@PathVariable Long memberId, HttpServletRequest request) {
	    try {
	        // memberId를 이용해 프로필 사진의 경로를 데이터베이스에서 조회
	        String photoPath = memberService.getProfilePhotoPathByMemberId(memberId);

	        // 전체 파일 경로 구성
	        String filePath = "src/main/resources/static/profile-photo/" + photoPath;
	        Path path = Paths.get(filePath);
	        Resource resource = new UrlResource(path.toUri());

	        if (resource.exists() || resource.isReadable()) {
	            String contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
	            if(contentType == null) {
	                contentType = "application/octet-stream";
	            }
	            return ResponseEntity.ok()
	                    .contentType(MediaType.parseMediaType(contentType))
	                    .body(resource);
	        } else {
	            throw new RuntimeException("Could not read the file!");
	        }
	    } catch (Exception e) {
	        return ResponseEntity.badRequest().build();
	    }
	}


	@RequestMapping("/usr/member/doJoinWithInvite")
	@ResponseBody
	public String doJoinWithInvite(String name, String nickname, String cellphoneNum, String loginId, String loginPw, String inviteCode, @RequestParam("profilePhoto") MultipartFile profilePhoto) throws IOException {
		
		String profilePhotoPath;
		
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
		if (Util.empty(nickname)) {
			return Util.jsHistoryBack("닉네임을 입력해주세요");
		}
		if (Util.empty(cellphoneNum)) {
			return Util.jsHistoryBack("전화번호를 입력해주세요");
		}
		
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member != null) {
			return Util.jsHistoryBack(Util.f("이미 사용중인 아이디(%s) 입니다", loginId));
		}
		
		if (profilePhoto == null || profilePhoto.isEmpty()) {
            // 프로필 사진을 업로드하지 않았다면 디폴트 이미지 경로 사용
            profilePhotoPath = DEFAULT_PROFILE_IMAGE_PATH;
		} 
		else {
			// 파일명 가져오기
			String fileName = profilePhoto.getOriginalFilename();
			// 파일 저장 경로 설정
			String uploadDir = "src/main/resources/static/profile-photo/" + nickname;
		
			// 파일 저장 경로를 저장할 변수 선언 (try 블록 바깥에서 선언)
			
			// Path 객체를 사용하여 파일 저장 경로를 생성
			Path uploadPath = Paths.get(uploadDir);
			
			// 경로에 폴더가 없으면 생성
			if (!Files.exists(uploadPath)) {
			    try {
			        Files.createDirectories(uploadPath);
			    } catch (IOException e) {
			        throw new RuntimeException("Could not create upload directory", e);
			    }
			}
		
			try {
				// 파일 저장
			    Path filePath = uploadPath.resolve(fileName);
			    Files.copy(profilePhoto.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
			    
			    // 파일 저장 경로에서 기본 경로 부분을 제외한 상대 경로만 profilePhotoPath 변수에 저장
			    profilePhotoPath = nickname + "/" + fileName;
			    
			    // 윈도우 시스템에서는 경로 구분자가 '\' 이므로, 이를 '/'로 변환해주는 처리가 필요
			    profilePhotoPath = profilePhotoPath.replace('\\', '/');
			    
			    
			} catch (IOException e) {
			    throw new RuntimeException("Failed to store file", e);
			}
		}
		
		

		    memberService.joinMemberWithInvite(name, nickname, cellphoneNum, loginId, loginPw, inviteCode, profilePhotoPath);
		
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
		
		if (member.getDelStatus() == 1) {
			return Util.jsHistoryBack("비활성화된 계정입니다");
		}
		
		
		rq.login(member);
		
		int teamId = member.getTeamId();
		
		return Util.jsReplace(Util.f("%s 회원님 환영합니다~", member.getName()), "/usr/home/main");
	}
	
	@RequestMapping("/usr/member/doLogout")
	@ResponseBody
	public String doLogout() {
		
		rq.logout();
		
		return Util.jsReplace("정상적으로 로그아웃 되었습니다", "/");
	}
	
	@RequestMapping("/usr/member/getMemberDetails")
	@ResponseBody
	public Member getMemberDetails(int memberId) {
		
		Member member = memberService.getMemberById(memberId);
		
		return member;
	}

	@RequestMapping("/usr/member/myPage")
	public String myPage(Model model) {
		
		Member member = memberService.getMemberById(rq.getLoginedMemberId());

		model.addAttribute("member", member);
		
		return "usr/member/myPage";
	}
	
	@RequestMapping("/usr/member/checkPassword")
	public String checkPassword(Model model, String loginId, String action) {
		model.addAttribute("loginId", loginId);
		model.addAttribute("action", action);
		
		return "usr/member/checkPassword";
	}

	@RequestMapping("/usr/member/doCheckPassword")
	public String doCheckPassword(Model model, String loginPw, String action) {
	    
	    if (Util.empty(loginPw)) {
	        return rq.jsReturnOnView("비밀번호를 입력해주세요"); 
	    }
	    
	    Member member = memberService.getMemberById(rq.getLoginedMemberId());
	    
	    if (member.getLoginPw().equals(loginPw) == false) {
	        return rq.jsReturnOnView("비밀번호가 일치하지 않습니다");
	    }
	    
	    if ("modify".equals(action)) {
	        model.addAttribute("member", member);
	        return "usr/member/modify";
	        
	    } else if ("delete".equals(action)) {
	        memberService.deleteMember(member.getId()); // 회원 삭제 로직 수행
	        return rq.jsReturnOnView("회원탈퇴가 완료되었습니다"); // 탈퇴 완료 메시지와 함께 홈으로 리다이렉트
	    }
	    
	    // 기본값은 비밀번호 확인 페이지로 리다이렉트
	    return "redirect:/usr/member/checkPassword";
	}
	
	@RequestMapping("/usr/member/doModify")
	@ResponseBody
	public String doModify(String name, String nickname, String cellphoneNum, String email, MultipartFile profilePhoto,  @RequestParam("existingProfilePhoto") String existingProfilePhoto) {
		
		String profilePhotoPath = null;
		
		
		if (Util.empty(name)) {
			return Util.jsHistoryBack("이름을 입력해주세요"); 
		}
		
		if (Util.empty(nickname)) {
			return Util.jsHistoryBack("닉네임을 입력해주세요"); 
		}
		
		if (Util.empty(cellphoneNum)) {
			return Util.jsHistoryBack("전화번호를 입력해주세요"); 
		}
		
		// 프로필 사진 업데이트 로직
	    if (profilePhoto != null && !profilePhoto.isEmpty()) {
	        // 파일명 가져오기
	        String fileName = profilePhoto.getOriginalFilename();
	        // 파일 저장 경로 설정
	        String uploadDir = "src/main/resources/static/profile-photo/" + nickname;
	    
	        // Path 객체를 사용하여 파일 저장 경로를 생성
	        Path uploadPath = Paths.get(uploadDir);
	        
	        // 경로에 폴더가 없으면 생성
	        if (!Files.exists(uploadPath)) {
	            try {
	                Files.createDirectories(uploadPath);
	            } catch (IOException e) {
	                throw new RuntimeException("Could not create upload directory", e);
	            }
	        }
	    
	        try {
	            // 파일 저장
	            Path filePath = uploadPath.resolve(fileName);
	            Files.copy(profilePhoto.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
	            
	            // 파일 저장 경로에서 기본 경로 부분을 제외한 상대 경로만 profilePhotoPath 변수에 저장
			    profilePhotoPath = nickname + "/" + fileName;
			    
			    // 윈도우 시스템에서는 경로 구분자가 '\' 이므로, 이를 '/'로 변환해주는 처리가 필요
			    profilePhotoPath = profilePhotoPath.replace('\\', '/');
	            
	        } catch (IOException e) {
	            throw new RuntimeException("Failed to store file", e);
	        }
	    } else {
	        // 새 파일이 업로드되지 않은 경우 기존 프로필 사진 유지
	        profilePhotoPath = existingProfilePhoto;
	    }
		
		System.out.println(profilePhoto);
		
		memberService.doModify(rq.getLoginedMemberId(), name, nickname, cellphoneNum, profilePhotoPath);
		
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

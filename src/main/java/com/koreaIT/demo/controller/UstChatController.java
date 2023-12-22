package com.koreaIT.demo.controller;

import java.security.Principal;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.vo.ChatMessage;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UstChatController {
	
	private SimpMessagingTemplate messagingTemplate;
	private MemberService memberService;
	private Rq rq;
	
	UstChatController(Rq rq, MemberService memberService, SimpMessagingTemplate messagingTemplate) {
		this.rq = rq;
		this.memberService = memberService;
		this.messagingTemplate = messagingTemplate;
	}
	
	/*
	  우체국에 비유
	  각 편지에는 목적지가 적혀 있고, 우체국 직원은 이 편지들을 받아서 올바른 목적지로 전달하는 역할
	  웹소켓 메시지 처리 컨트롤러는 이 우체국 직원과 같은 역할 
	  클라이언트가 서버로 메시지를 보내면 컨트롤러가 그 메시지를 받아서 어떤 처리를 할지 결정
	 */
	
	/*
	  컨트롤러에서 @SendTo("/topic/messages") 어노테이션을 사용하는 것은, 메서드가 처리를 마친 후에 그 결과 메시지를
	  /topic/messages 채널로 보내서, 이 채널을 구독하고 있는 모든 클라이언트들이 해당 메시지를 받을 수 있도록 하는 것
	  결론적으로, /topic/messages는 메시지를 브로드캐스트하기 위한 '가상의' 채널이며, 이 채널은 스프링 애플리케이션의 메모리 내부에서 관리 
	  클라이언트는 이 채널을 구독함으로써 서버로부터 실시간으로 메시지를 받을 수 있음
	 */
	
	// 클라이언트로부터 메시지를 받는 메서드
	@MessageMapping("/chat.private.{memberId}")
    @SendTo("/room/{memberId}")
    public ChatMessage handlePrivateMessage(@Payload ChatMessage message,
                                            @DestinationVariable String memberId) {
 
		
		
		// 메시지 처리 로직...
        return message;
    }
    
    
	
	
	
	 // 채팅방 페이지를 보여주기 위한 메서드
    @GetMapping("/usr/home/chat")
    public String showChatPage(@RequestParam("memberId") int memberId, Model model) {
    	Member member = memberService.getMemberById(memberId);
    	
    	Member myMember = memberService.getMemberById(rq.getLoginedMemberId());
    	
//    	String myName = myMember.getName();
    	int myId = rq.getLoginedMemberId();
    	
    	model.addAttribute("member", member);
//    	model.addAttribute("myName", myName);
    	model.addAttribute("myId", myId);
    	
        return "usr/home/chat"; // "chat.jsp" 페이지로 이동
    }
	
	
	
	
	
}

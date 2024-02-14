package com.koreaIT.demo.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreaIT.demo.service.ChatService;
import com.koreaIT.demo.service.MemberService;
import com.koreaIT.demo.service.ProjectService;
import com.koreaIT.demo.vo.ChatMessage;
import com.koreaIT.demo.vo.GroupChatMessage;
import com.koreaIT.demo.vo.GroupChatRoom;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Project;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UstChatController {
	
	private MemberService memberService;
	private ChatService chatService;
	private ProjectService projectService;
	private Rq rq;
	private SimpMessagingTemplate messagingTemplate;
	
	UstChatController(Rq rq, MemberService memberService, ChatService chatService, ProjectService projectService, SimpMessagingTemplate messagingTemplate) {
		this.rq = rq;
		this.memberService = memberService;		
		this.chatService = chatService;		
		this.projectService = projectService;		
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
	
	// 클라이언트로부터 1:1메시지를 받는 메서드
	// @MessageMapping에 지정된 경로는 configureMessageBroker() 메소드에서 설정한 setApplicationDestinationPrefixes()에 의해 정의된 애플리케이션 접두사를 이미 포함하고 있다는 것입니다.
	@MessageMapping("/chat.private.{memberId}")
    public ChatMessage handlePrivateMessage(@Payload ChatMessage message,
                                            @DestinationVariable String memberId) {
		// MemberService를 통해 현재 로그인한 사용자의 이름을 가져옵니다.
	    String senderName = memberService.getMemberById(Integer.parseInt(message.getSenderId())).getName();
	    if (senderName != null) {
	        message.setSenderName(senderName);
	    } else {
	        // senderName이 null인 경우
	        message.setSenderName("Unknown");
	    }
	    
	    message.setRegDate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
	    
	    String currentUserId = message.getSenderId();
	    
	    int senderId = Integer.parseInt(currentUserId);
	    int recipientId = Integer.parseInt(memberId); 
	    
	    String chatRoomId = chatService.getOrCreateChatRoomId(senderId, recipientId, message.getSenderName());
    
	    chatService.saveMessage(message);
	     
        // 사용자간의 고유 대기열로 메시지 전송
        messagingTemplate.convertAndSend("/queue/chat-" + chatRoomId, message);
        sendMessageToUser(message);
        return message;
    }
    
	 // 1:1 채팅방 페이지를 보여주기 위한 메서드
    @GetMapping("/usr/home/chat")
    public String showChatPage(@RequestParam("memberId") int memberId, Model model) {
    	Member member = memberService.getMemberById(memberId);
    	
    	Member myMember = memberService.getMemberById(rq.getLoginedMemberId());
    	
    	String myName = myMember.getName();
    	int myId = rq.getLoginedMemberId();
    	
    	String recipientName = member.getName();
    
    	String chatRoomId = chatService.getOrCreateChatRoomId(myId, memberId, recipientName);
    	
    	List<ChatMessage> messages = chatService.getMessageHistory(chatRoomId);
    	
    	
    	
    	model.addAttribute("member", member);
    	model.addAttribute("myName", myName);
    	model.addAttribute("myId", myId);
    	model.addAttribute("recipientName", recipientName);
    	model.addAttribute("chatRoomId", chatRoomId);
    	model.addAttribute("messages", messages);
    	
        return "usr/home/chat"; // "chat.jsp" 페이지로 이동
    }
    
    
    @MessageMapping("/chat.group.{groupChatRoomProjectId}")
    public GroupChatMessage handleGroupMessage(@Payload GroupChatMessage message,
                                          @DestinationVariable String groupChatRoomProjectId) {
        // 메시지에 시간을 추가합니다.
        message.setRegDate(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

        // 채팅방 식별자를 통해 채팅방을 찾고, 메시지를 저장합니다.
         chatService.saveGroupMessage(message);

        // 채팅방의 모든 구성원에게 메시지를 브로드캐스트합니다.
        messagingTemplate.convertAndSend("/topic/chat-group-" + groupChatRoomProjectId, message);

        return message;
    }
    
    
    
    
    
	
    @GetMapping("/usr/home/groupChat")
    public String showGroupChatPage(@RequestParam("groupChatRoomProjectId") int groupChatRoomProjectId, Model model) {
        
    	Project project = projectService.getProjectByProjectId(groupChatRoomProjectId);
    	String projectName = project.getProject_name();
    	
    	
    	List<Integer> projectMemberIds = memberService.getprojectMembersIdByprojectId(groupChatRoomProjectId);
    	
    	
    	// 채팅방 정보
        GroupChatRoom groupChatRoom = chatService.getGroupChatRoomById(groupChatRoomProjectId);
        
        
        List<Member> members = chatService.findMembersByGroupChatRoomProjectId(groupChatRoomProjectId);
        int groupChatRoomMembersCount = chatService.getgroupChatRoomMembersCount(groupChatRoomProjectId);
        Member myMember = memberService.getMemberById(rq.getLoginedMemberId());
        String myName = myMember.getName();
    	int myId = rq.getLoginedMemberId();
        
    	
    	List<GroupChatMessage> messages = chatService.getGroupMessageHistory(groupChatRoomProjectId);
        
    	// 채팅방이 존재하지 않는 경우 새로 생성
        if (groupChatRoom == null) {
            groupChatRoom = chatService.insertGroupChatRoom(groupChatRoomProjectId, projectName, projectMemberIds, myId);
        }
        
    	
    	model.addAttribute("myName", myName);
    	model.addAttribute("myId", myId);
        model.addAttribute("groupChatRoom", groupChatRoom);
        model.addAttribute("members", members);
        model.addAttribute("groupChatRoomProjectId", groupChatRoomProjectId);
        model.addAttribute("projectName", projectName);
        model.addAttribute("messages", messages);
        model.addAttribute("groupChatRoomMembersCount", groupChatRoomMembersCount);
        
        return "usr/home/groupChat"; // 단체 채팅을 위한 뷰 페이지로 이동
    }
    
    
    
    private void sendMessageToUser(ChatMessage chatMessage) {
        // '/queue/notify'는 클라이언트가 구독할 대상 주소입니다.
        messagingTemplate.convertAndSend("/queue/notify", chatMessage);
    }
    
	
	
	
	
}

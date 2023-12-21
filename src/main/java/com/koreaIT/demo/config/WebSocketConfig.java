package com.koreaIT.demo.config;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
	// 웹소켓 서버에 접속할 수 있는 '문'을 만드는 과정
	// /chat은 클라이언트가 웹소켓 서버에 접속할 수 있는 경로(문)
	// 클라이언트는 var socket = new SockJS('/chat'); 이렇게 이 경로로 요청을 보냄
	//  이 과정이 성공하면 서버와 클라이언트 간에 양방향 통신 채널이 열림
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/chat").withSockJS(); 
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
    	// 우편을 보낼 때 특정 지역으로 보내기 위해 지역 코드를 앞에 붙이는 것과 비슷
    	// /app 대신 /api나 /actions와 같이 다른 어떤 문자열로도 변경할 수 있음
    	// 중요한 것은 클라이언트가 메시지를 보낼 때 사용하는 경로와 서버 설정에서 정의한 경로가 일치해야 함
    	// stompClient.send("/app/message", {}, JSON.stringify({your: "message"}));
    	registry.setApplicationDestinationPrefixes("/app");
    	// 한 사람이 소리쳤을 때 근처에 있는 사람들 모두가 들을 수 있게 하는 메가폰과 같은 역할
    	// 서버에 /topic/messages라는 경로로 메시지가 보내지면, 이 경로를 구독하고 있는 모든 클라이언트에게 메시지가 전달
    	// /topic 이라는 경로도 실제 폴더나 파일 시스템과 관련이 없음 /topic은 웹소켓 통신에서 사용되는 논리적인 주소(prefix)로서, 메시지 브로커가 클라이언트에게 메시지를 브로드캐스트할 때 사용됨.
    	// /topic으로 시작하는 모든 메시지가 브로드캐스트 메시지로 처리될 수 있음을 의미
    	// stompClient.subscribe('/topic/messages', function(messageOutput) {
        registry.enableSimpleBroker("/topic"); 
    }
}

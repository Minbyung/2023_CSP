package com.koreaIT.demo.config;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.*;


//@Configuration -> 해당 클래스가 스프링의 설정 파일임을 명시합니다. 즉, 이 클래스에서는 빈(Bean) 생성이나 서비스, 리포지토리 등의 설정을 할 수 있습니다.
//@EnableWebSocketMessageBroker -> 스프링에게 웹소켓을 활성화하도록 지시합니다. 이를 통해 웹소켓 서버를 설정하고 사용할 수 있게 됩니다.
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // 원칙적으로 웹소켓 엔드포인트로 사용할 URL은 서버 구성에 따라 자유롭게 정할 수 있습니다. 중요한 것은 클라이언트와 서버 간에 동일한 URL 경로를 사용하여 서로 통신할 수 있도록 일치시키는 것
    	registry.addEndpoint("/ws_endpoint").withSockJS();
    }
    
    
    // 메시지 브로커의 동작을 설정
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 클라이언트가 서버에 데이터를 보낼 때 사용해야 하는 경로(prefix)를 설정합니다. 여기서는 클라이언트가 "/app"으로 시작하는 경로로 메시지를 보내면, 그 메시지가 애플리케이션의 메시지 핸들러로 라우팅(서버 쪽에서 해당 메시지를 받아서하는 특정 함수나 메소드로 연결해주는 것을 말)됩니다.
    	// @MessageMapping에 지정된 경로는 configureMessageBroker() 메소드에서 설정한 setApplicationDestinationPrefixes()에 의해 정의된 애플리케이션 접두사를 이미 포함하고 있다는 것입니다.
    	registry.setApplicationDestinationPrefixes("/app");
        registry.enableSimpleBroker("/queue", "/topic");
    }
}

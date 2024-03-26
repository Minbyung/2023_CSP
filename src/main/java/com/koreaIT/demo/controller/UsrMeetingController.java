package com.koreaIT.demo.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.koreaIT.demo.service.MeetingService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Rq;
import com.koreaIT.demo.vo.ZoomMeetingRequest;
import com.koreaIT.demo.vo.ZoomMeetingResponse;

import jakarta.servlet.http.HttpServletRequest;
import okhttp3.FormBody;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

@Controller
public class UsrMeetingController {
	
	private Rq rq;
	private MeetingService  meetingService;
	
	UsrMeetingController(Rq rq, MeetingService  meetingService) {
		this.rq = rq;
		this.meetingService = meetingService;
	}
	

	@RequestMapping(value="/usr/meeting/zoomApi" , method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
    public String createZoomMeeting(HttpServletRequest req, Model model, @RequestParam String code, @RequestParam(required = false) String state) throws NoSuchAlgorithmException, IOException  {
		//https://zoom.us/oauth/authorize?response_type=code&client_id=hS7eo62IQn4P7NhEDhmtA&redirect_uri=http://localhost:8082/usr/meeting/zoomApi&scope=meeting:write%20meeting:read%20meeting:write:admin%20meeting:read:admin  -> code를 받아올수있다
		// https://zoom.us/oauth/authorize?response_type=code&client_id=hS7eo62IQn4P7NhEDhmtA&redirect_uri=http://localhost:8082/usr/meeting/zoomApi
		//Access token 을 받는 zoom api 호출 url
		String zoomUrl = "https://zoom.us/oauth/token";
		String clientId = "hS7eo62IQn4P7NhEDhmtA"; // Zoom에서 제공받은 Client ID
		String clientSecret = "ZJQQFFCKPpnn9L4NqdBZLCbIA6o8Kw3F"; // Zoom에서 제공받은 Client Secret
		String authValue = clientId + ":" + clientSecret;
		String encodedAuthValue = Base64.getEncoder().encodeToString(authValue.getBytes(StandardCharsets.UTF_8));
		
		String[] parts = state.split(",");
		String projectIdStr = parts[0]; 
		int projectId = Integer.parseInt(projectIdStr); 
		String topic = parts[1]; 
		String durationStr = parts[2]; 
		int duration = Integer.parseInt(durationStr);
		String startTime = parts[3]; 
		String password = parts[4];
		// 받아온 시간 문자열을 파싱하기 위한 포매터
        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        // 받아온 시간을 LocalDateTime 객체로 파싱
        LocalDateTime localDateTime = LocalDateTime.parse(startTime, inputFormatter);
        // 로컬 시간을 시스템 기본 시간대의 ZonedDateTime으로 변환
        ZonedDateTime zonedDateTime = localDateTime.atZone(ZoneId.systemDefault());
        // UTC 시간대로 변환
        ZonedDateTime utcTime = zonedDateTime.withZoneSameInstant(ZoneId.of("UTC"));
        // UTC 시간을 ISO 8601 형식으로 포맷팅
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
        String formattedTime = utcTime.format(outputFormatter);
		
		
		
		
		// 통신을 위한 okhttp 사용 maven 추가 필요
		// OkHttpClient 요청을 보내고 받기 위해 널리 사용되는 외부 라이브러리
		OkHttpClient client = new OkHttpClient();
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		
		FormBody formBody = new FormBody.Builder()
				.add("code", code) // 1단계에서 받은 code 값
				.add("redirect_uri", "http://localhost:8082/usr/meeting/zoomApi") //등록 된 uri
				.add("grant_type", "authorization_code") // 문서에 명시 된 grant_type
				.add("code_verifier", Util.encode(code)) // code를 SHA-256 방식으로 암호화하여 전달
				.build();
		
		Request zoomRequest = new Request.Builder()
                .url(zoomUrl) // 요청을 보낼 Zoom API의 URL을 설정
                .addHeader("Content-Type", "application/x-www-form-urlencoded") // 요청 헤더에 Content-Type을 추가하여 본문의 데이터 타입이 URL 인코딩된 폼 데이터임을 지정 // 이는 공식 문서에서 요구하는 내용이며, 요청 본문에서 사용되는 데이터 형식을 정의
                .addHeader("Authorization","Basic " + encodedAuthValue) // Client_ID:Client_Secret 을  Base64-encoded 한 값
                .post(formBody) // HTTP 메서드로 POST를 사용하며, formBody에 지정된 데이터를 요청 본문으로 전송
                .build(); // 구성된 요청을 최종적으로 빌드하여 Request 객체를 생성
		
		
		// OkHttp 라이브러리를 사용하여 준비된 zoomRequest 요청을 실행하고, 그 결과로 받은 응답을 zoomResponse 객체에 저장하는 과정을 수행
		Response zoomResponse = client.newCall(zoomRequest).execute();
		// 응답본문을 문자열형식으로 읽기위해
		String zoomResponseBody = zoomResponse.body().string();
		
		// Access Token 추출
        JsonNode jsonNode = mapper.readTree(zoomResponseBody);
        String accessToken = jsonNode.get("access_token").asText();
		
        // 회의 생성 요청
        String meetingUrl = "https://api.zoom.us/v2/users/me/meetings";
        String meetingRequestBody = mapper.writeValueAsString(new ZoomMeetingRequest(topic, formattedTime, duration, password));
//        "2024-04-01T15:32:00Z"
        Request meetingRequest = new Request.Builder()
                .url(meetingUrl)
                .addHeader("Authorization", "Bearer " + accessToken)
                .addHeader("Content-Type", "application/json")
                .post(RequestBody.create(meetingRequestBody, MediaType.parse("application/json")))
                .build();
        
        Response meetingResponse = client.newCall(meetingRequest).execute();
        String meetingResponseBody = meetingResponse.body().string();
        // 회의 생성 응답 처리
        ZoomMeetingResponse meetingInfo = mapper.readValue(meetingResponseBody, ZoomMeetingResponse.class);
        // 회의 정보를 모델에 추가하여 뷰에서 사용할 수 있도록 합니다.
        System.out.println("meetingInfo : " + meetingInfo);
        model.addAttribute("meetingInfo", meetingInfo);
        
        
        meetingService.createMeeting(meetingInfo);
        
        
        
          // 회의 리스트
//        String listMeetingsUrl = "https://api.zoom.us/v2/users/me/meetings";
//        Request listMeetingsRequest = new Request.Builder()
//               .url(listMeetingsUrl)
//               .addHeader("Authorization", "Bearer " + accessToken) // 앞서 얻은 액세스 토큰 사용
//               .get()
//               .build();
//
//        Response listMeetingsResponse = client.newCall(listMeetingsRequest).execute();
//        String listMeetingsResponseBody = listMeetingsResponse.body().string();
//        System.out.println("List of Meetings: " + listMeetingsResponseBody);
        
        
 
//		// ObjectMapper의 구성 설정을 변경하는 것으로, JSON 데이터를 Java 객체로 역직렬화(Deserialization)할 때 사용
//		// 단일 값도 배열의 요소로 간주하고 오류 없이 역직렬화를 수행할 수 있습니다.
//		// ex) JSON 데이터가 {"numbers": 1}이고 Java 측에서는 numbers를 int[] 또는 List<Integer>로 기대하는 경우, 이 설정 없이는 오류가 발생할 것입니다
//		// 이 설정을 활성화하면, 1이 단일 요소인 배열 또는 리스트로 처리되어 오류 없이 역직렬화됩니다.
//		mapper.configure(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY, true);
//		
//		// 문자열 형태의 JSON 데이터를 Java 객체로 변환하기 위해 
//		List<Object> list = mapper.readValue(zoomText, new TypeReference<List<Object>>() {});
		
//		return Util.jsHistoryBack(Util.f("%d번 댓글은 존재하지 않습니다", projectId));
		return Util.jsReplace("회의를 생성했습니다", Util.f("../project/detail?projectId=%d", projectId));
	}
	
	
	
}

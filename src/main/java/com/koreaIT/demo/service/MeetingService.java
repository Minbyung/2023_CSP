package com.koreaIT.demo.service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.koreaIT.demo.dao.MeetingDao;
import com.koreaIT.demo.vo.ZoomMeetingRequest;
import com.koreaIT.demo.vo.ZoomMeetingResponse;

import okhttp3.Credentials;
import okhttp3.FormBody;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

@Service
public class MeetingService {
	
	private MeetingDao meetingDao;
	
	public MeetingService(MeetingDao meetingDao) {
		this.meetingDao = meetingDao;
	}

	
	private static final String ZOOM_API_URL = "https://api.zoom.us/v2";
    private static final String CLIENT_ID = "hS7eo62IQn4P7NhEDhmtA";
    private static final String CLIENT_SECRET = "ZJQQFFCKPpnn9L4NqdBZLCbIA6o8Kw3F";
    private static final String REDIRECT_URI = "http://localhost:8082/oauth/callback";

    private final OkHttpClient httpClient = new OkHttpClient();
    private final ObjectMapper objectMapper = new ObjectMapper();

    
    
    // 사용자를 Zoom OAuth 인증 페이지로 리디렉션하여 권한 코드를 얻기 위한 URL을 제공
    public String getOAuthUrl() {
        return "https://zoom.us/oauth/authorize?response_type=code&client_id=" + CLIENT_ID + "&redirect_uri=" + REDIRECT_URI;
    }

    // OAuth 인증 후 얻은 권한 코드를 사용하여 액세스 토큰을 요청
    public String getAccessToken(String authorizationCode) throws IOException {
    	// grant_type, code, redirect_uri를 요청 본문에 추가
        RequestBody body = new FormBody.Builder()
                .add("grant_type", "authorization_code")
                .add("code", authorizationCode)
                .add("redirect_uri", REDIRECT_URI)
                .build();

        // 클라이언트 ID와 클라이언트 시크릿을 Base64로 인코딩한 인증 정보를 생성
        String credential = Credentials.basic(CLIENT_ID, CLIENT_SECRET);
        // OkHttp의 Request 객체를 생성하여 POST 요청을 설정하고, 필요한 헤더와 요청 본문을 추가
        Request request = new Request.Builder()
                .url("https://zoom.us/oauth/token")
                .post(body)
                .header("Authorization", credential)
                .build();
        
        // httpClient.newCall(request).execute()를 호출하여 요청을 실행하고 응답을 처리
        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) throw new IOException("Unexpected code " + response);

            String responseBody = response.body().string();
            Map<String, Object> responseMap = objectMapper.readValue(responseBody, Map.class);
            return (String) responseMap.get("access_token");
        }
    }

    // 액세스 토큰을 사용하여 Zoom 미팅을 생성
    public ZoomMeetingResponse createMeeting(String accessToken, ZoomMeetingRequest meetingRequest) throws IOException {
    	
    	// 미팅 정보를 포함하는 meetingRequest를 JSON 형식으로 변환
        String json = objectMapper.writeValueAsString(meetingRequest);
        // OkHttp의 RequestBody.create를 사용하여 요청 본문을 생성
        RequestBody body = RequestBody.create(json, MediaType.get("application/json; charset=utf-8"));

        Request request = new Request.Builder()
                .url(ZOOM_API_URL + "/users/me/meetings")
                .post(body)
                .header("Authorization", "Bearer " + accessToken)
                .header("Content-Type", "application/json")
                .build();
        
        // httpClient.newCall(request).execute()를 호출하여 요청을 실행하고 응답을 처리
        try (Response response = httpClient.newCall(request).execute()) {
            if (!response.isSuccessful()) throw new IOException("Unexpected code " + response);

            String responseBody = response.body().string();
            // 미팅 정보 반환
            return objectMapper.readValue(responseBody, ZoomMeetingResponse.class);
        }
    }

	public void saveMeeting(ZoomMeetingResponse meetingResponse, int projectId, int memberId) {
		meetingDao.saveMeeting(meetingResponse, projectId, memberId);
		
	}

	public List<ZoomMeetingResponse> getMeetingInfo(int projectId) {
		return meetingDao.getMeetingInfo(projectId);
	}

	public void deleteMeeting(String meetingId) {
		meetingDao.deleteMeeting(meetingId);
		
	}
	
	
	
	
//	public void createMeeting(ZoomMeetingResponse meetingInfo) {
//		String topic = meetingInfo.getTopic();
//		String startUrl = meetingInfo.getStart_url();
//		String joinUrl = meetingInfo.getJoin_url();
//		
//		LocalDateTime startTime = LocalDateTime.parse(meetingInfo.getStart_time(), DateTimeFormatter.ISO_DATE_TIME);
//        LocalDateTime endTime = startTime.plusMinutes(meetingInfo.getDuration());
//		
//        System.out.println(startTime);
//        System.out.println(endTime);
//        
////		return meetingDao.createMeeting(topic, startUrl, joinUrl);
//        return;
//	}
}

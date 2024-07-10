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
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestBody;

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
import jakarta.servlet.http.HttpSession;
import okhttp3.FormBody;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

@Controller
public class UsrMeetingController {
	
	private Rq rq;
	private MeetingService  meetingService;
	
	UsrMeetingController(Rq rq, MeetingService  meetingService) {
		this.rq = rq;
		this.meetingService = meetingService;
	}
	
	
	@GetMapping("/login")
    public String login() {
        return "redirect:" + meetingService.getOAuthUrl();
    }

	
	@PostMapping("/saveZoomMeetingRequest")
    @ResponseBody
    public String saveZoomMeetingRequest(@RequestBody ZoomMeetingRequest meetingRequest, HttpSession session) {
        session.setAttribute("zoomMeetingRequest", meetingRequest);
        return "Request data saved in session";
    }
	
    @GetMapping("/oauth/callback")
    public String callback(@RequestParam String code, @RequestParam String state, Model model, HttpSession session) {
        try {
        	String accessToken = meetingService.getAccessToken(code);
        	
            session.setAttribute("accessToken", accessToken);
         
            // 세션에서 객체를 올바르게 가져옵니다.
            ZoomMeetingRequest meetingRequest = (ZoomMeetingRequest) session.getAttribute("zoomMeetingRequest");
            ZoomMeetingResponse meetingResponse = meetingService.createMeeting(accessToken, meetingRequest);
            
            

            // state에서 projectId를 가져옵니다.
            int projectId = Integer.parseInt(state);
            
            meetingService.saveMeeting(meetingResponse, projectId, rq.getLoginedMemberId()); // 회의 정보를 데이터베이스에 저장

            
            
            return "redirect:/usr/project/meeting?projectId=" + projectId;
            
        } catch (IOException e) {
            model.addAttribute("error", "Failed to retrieve access token: " + e.getMessage());
            return "error";
        }
    }
    
    @RequestMapping("/usr/project/meeting/doDelete")
    @ResponseBody
    public String delete(@RequestParam("meetingId") String meetingId) {
        meetingService.deleteMeeting(meetingId);
        return "회의가 삭제되었습니다";
    }

//    @GetMapping("/createMeeting")
//    public String showCreateMeetingPage() {
//        return "createMeeting";
//    }
//
//    @GetMapping("/createMeetingAction")
//    public String createMeeting(
//            @RequestParam String accessToken,
//    		@RequestParam String code,
//            @RequestParam String topic,
//            @RequestParam String startTime,
//            @RequestParam int duration,
//            @RequestParam String password,
//            Model model) {
//        try {
//            ZoomMeetingRequest meetingRequest = new ZoomMeetingRequest(topic, 2, startTime, duration, password);
//            
//            ZoomMeetingResponse meetingResponse = meetingService.createMeeting(accessToken, meetingRequest);
//            // 미팅 정보
//            model.addAttribute("meetingDetails", meetingResponse);
//            return "meetingDetails";
//            
//        } catch (IOException e) {
//            model.addAttribute("error", "Failed to create meeting: " + e.getMessage());
//            return "error";
//        }
//    }

	
}

package com.koreaIT.demo.vo;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
// Zoom 회의 응답 정보를 담을 DTO 클래스
public class ZoomMeetingResponse {
	private String id;
	private String uuid; // 추가
	private String hostId;
    private String topic;
    private String start_url;
    private String join_url;
    private String password;
    private int duration;
    private Timestamp created_at;
    private Timestamp start_time;
    
    private int projectId;
    private int memberId;
}

package com.koreaIT.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
// Zoom 회의 응답 정보를 담을 DTO 클래스
public class ZoomMeetingResponse {
	private String uuid; // 추가
	private String id;
    private String topic;
    private String start_url;
    private String join_url;
}

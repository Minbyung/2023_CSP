package com.koreaIT.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
// Zoom 회의 요청 정보를 담을 DTO 클래스 (이름 동일하게)
public class ZoomMeetingRequest {
	private String topic;
    private int type;
    private String start_time;
    private int duration;
    private String password;

}

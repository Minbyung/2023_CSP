package com.koreaIT.demo.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.MeetingDao;
import com.koreaIT.demo.vo.ZoomMeetingResponse;

@Service
public class MeetingService {
	
	private MeetingDao meetingDao;
	
	public MeetingService(MeetingDao meetingDao) {
		this.meetingDao = meetingDao;
	}

	public void createMeeting(ZoomMeetingResponse meetingInfo) {
		String topic = meetingInfo.getTopic();
		String startUrl = meetingInfo.getStart_url();
		String joinUrl = meetingInfo.getJoin_url();
		
		LocalDateTime startTime = LocalDateTime.parse(meetingInfo.getStart_time(), DateTimeFormatter.ISO_DATE_TIME);
        LocalDateTime endTime = startTime.plusMinutes(meetingInfo.getDuration());
		
        System.out.println(startTime);
        System.out.println(endTime);
        
//		return meetingDao.createMeeting(topic, startUrl, joinUrl);
        return;
	}
}

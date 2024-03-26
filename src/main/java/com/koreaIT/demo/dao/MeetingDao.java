package com.koreaIT.demo.dao;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MeetingDao {

	String createMeeting(String topic, String startUrl, String joinUrl);


}




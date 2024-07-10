package com.koreaIT.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.koreaIT.demo.vo.ZoomMeetingResponse;

@Mapper
public interface MeetingDao {

	

	@Insert("""
			INSERT INTO zoomMeeting
				SET id = #{meetingResponse.id},
				`uuid` = #{meetingResponse.uuid},
				projectId = #{projectId},
				memberId = #{memberId},
				topic = #{meetingResponse.topic},
				start_url = #{meetingResponse.start_url},
				join_url = #{meetingResponse.join_url},
				duration = #{meetingResponse.duration},
				start_time = #{meetingResponse.start_time},
				`password` = #{meetingResponse.password};
			""")
	void saveMeeting(ZoomMeetingResponse meetingResponse, int projectId, int memberId);

	@Select("""
			SELECT * FROM zoomMeeting
				WHERE projectId = #{projectId}
			""")
	List<ZoomMeetingResponse> getMeetingInfo(int projectId);
}




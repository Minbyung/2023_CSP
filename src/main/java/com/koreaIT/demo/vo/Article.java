package com.koreaIT.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Article {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private String title;
	private String content;
	private String status;
	private String startDate;
	private String endDate;
	
	
	
	private String writerName;
	private String taggedNames;
	private String groupName;
	private int groupId;
	
}

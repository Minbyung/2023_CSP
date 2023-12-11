package com.koreaIT.demo.vo;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ArticleAndTagInfo {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private int projectId;
	private String title;
	private String content;
	private String status;
	
	private String writerName;
	private List<String> taggedMemberNames;
}

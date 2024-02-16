package com.koreaIT.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {
	private int writerId;
	private String writerName;
	private String title;
	private String content;
	private String regDate;
	private String projectName;
}

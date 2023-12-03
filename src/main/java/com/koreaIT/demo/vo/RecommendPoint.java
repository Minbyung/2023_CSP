package com.koreaIT.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecommendPoint {
	private int id;
	private int memberId;
	private String relTypeCode;
	private int relId;
	private int point;
}

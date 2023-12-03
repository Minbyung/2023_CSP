package com.koreaIT.demo.service;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.RecommendDao;
import com.koreaIT.demo.vo.RecommendPoint;
import com.koreaIT.demo.vo.ResultData;

@Service
public class RecommendService {
	
	private RecommendDao recommendDao;
	
	public RecommendService(RecommendDao recommendDao) {
		this.recommendDao = recommendDao;
	}

	public ResultData<RecommendPoint> getRecommendPoint(int loginedMemberId, String relTypeCode, int relId) {
		
		RecommendPoint recommendPoint = recommendDao.getRecommendPoint(loginedMemberId, relTypeCode, relId);
		
		if (recommendPoint == null) {
			return ResultData.from("F-1", "좋아요 기록 없음");
		}
		
		return ResultData.from("S-1", "좋아요 기록 있음", recommendPoint);
	}

	public void insertRecommendPoint(int loginedMemberId, String relTypeCode, int relId) {
		recommendDao.insertRecommendPoint(loginedMemberId, relTypeCode, relId);
	}

	public void deleteRecommendPoint(int loginedMemberId, String relTypeCode, int relId) {
		recommendDao.deleteRecommendPoint(loginedMemberId, relTypeCode, relId);
	}
	
}

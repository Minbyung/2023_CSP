package com.koreaIT.demo.service;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.FavoriteDao;
import com.koreaIT.demo.vo.RecommendPoint;
import com.koreaIT.demo.vo.ResultData;

@Service
public class FavoriteService {
	
	private FavoriteDao favoriteDao;
	
	public FavoriteService(FavoriteDao favoriteDao) {
		this.favoriteDao = favoriteDao;
	}


	public boolean getFavorite(int memberId, int projectId) {
		
		int getFavorite = favoriteDao.getFavorite(memberId, projectId);
		
		if (getFavorite == 0) {
			return false;
		}
		
		return true;
	}	

	public void addFavorite(int memberId, int projectId) {
		favoriteDao.addFavorite(memberId, projectId);
	}

	public void removeFavorite(int memberId, int projectId) {
		favoriteDao.removeFavorite(memberId, projectId);
	}


	public void updateFavorite(int memberId, int projectId, boolean isFavorite) {
		if (isFavorite) {
	        favoriteDao.addFavorite(memberId, projectId);
	    } else {
	        favoriteDao.removeFavorite(memberId, projectId);
	    }
		
	}
	
}

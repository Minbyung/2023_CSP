package com.koreaIT.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.FavoriteService;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrFavoriteController {

	private FavoriteService favoriteService;
	private Rq rq;
	
	UsrFavoriteController(FavoriteService favoriteService, Rq rq) {
		this.favoriteService = favoriteService;
		this.rq = rq;
	}

	@RequestMapping("/usr/favorite/getFavorite")
	@ResponseBody
	public boolean getFavorite(int projectId) {
		return favoriteService.getFavorite(rq.getLoginedMemberId(), projectId);
	}

	@RequestMapping("/usr/favorite/updateFavorite")
	@ResponseBody
	public Boolean updateFavorite(int projectId, boolean isFavorite) {
		
		 favoriteService.updateFavorite(rq.getLoginedMemberId(), projectId, isFavorite);

		 
		 Map<String, Boolean> response = new HashMap<>();
		 response.put("success", true);
		 return isFavorite;
	}
}

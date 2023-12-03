package com.koreaIT.demo.service;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.BoardDao;
import com.koreaIT.demo.vo.Board;

@Service
public class BoardService {
	
	private BoardDao boardDao;
	
	public BoardService(BoardDao boardDao) {
		this.boardDao = boardDao;
	}
	
	public Board getBoardById(int boardId) {
		return boardDao.getBoardById(boardId);
	}
	
}

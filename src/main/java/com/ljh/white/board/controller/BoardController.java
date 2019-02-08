package com.ljh.white.board.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.board.service.BoardService;
import com.ljh.white.common.collection.WhiteMap;

@RestController
public class BoardController {

	@Resource(name = "BoardService")
	private BoardService boardService;
	
	/**
	 * 게시판 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/selectBoardList.ajax" )
	public WhiteMap selectSourceList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);
		
		WhiteMap result = new WhiteMap();
		result.put("itemsCount", boardService.selectBoardCount(param));
		result.put("list", boardService.selectBoardList(param));
		
		return result;
	}
	
	/**
	 * 소스코드 상세 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/selectBoardDtlView.ajax")
	public WhiteMap selectBoardDtlView(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		return boardService.selectBoardDtlView(param);
		
	}
	
	/**
	 * 소스코드 저장
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/insertBoard.ajax" )
	public int insertBoard(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);
		return boardService.insertBoard(param);
	
	}
	
	/**
	 * 소스코드 수정
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/updateBoard.ajax" )
	public int updateBoard(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);		
		return boardService.updateBoard(param);	
	}
	
	/**
	 * 소스코드 삭제
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/deleteBoard.ajax" )
	public int deleteBoard(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);		
		return boardService.deleteBoard(param);	
	}
}

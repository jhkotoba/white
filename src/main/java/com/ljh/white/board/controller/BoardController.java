package com.ljh.white.board.controller;

import java.util.List;

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
	 * 게시판 상세화면 댓글 리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/selectCommentList.ajax")
	public List<WhiteMap> selectBoardCommentList(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		return boardService.selectBoardCommentList(param);
	}
	
	/**
	 * 게시판 상세화면 댓글 저장
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/insertBoardComment.ajax")
	public int insertBoardComment(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		return boardService.insertBoardComment(param);
	}
	
	/**
	 * 게시판 상세화면 댓글 삭제(수정)
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/updateDelComment.ajax")
	public int updateDelComment(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		return boardService.updateDelComment(param);
	}	
	
	/**
	 * 게시판 글 저장
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/insertBoard.ajax" )
	public int insertBoard(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);
		return boardService.insertBoard(param);
	
	}
	
	/**
	 * 게시판 글 수정
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/updateBoard.ajax" )
	public int updateBoard(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);		
		return boardService.updateBoard(param);	
	}
	
	/**
	 * 게시판 글 삭제
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/board/deleteBoard.ajax" )
	public int deleteBoard(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);	
		return boardService.deleteBoard(param);	
	}
}

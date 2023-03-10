package diary.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.FileRenamePolicy;

import common.CommaFileRenamePolicy;
import diary.model.dto.Diary;
import diary.model.service.DiaryService;

/**
 * Servlet implementation class UpdateDiaryServlet
 */
@WebServlet("/diary/updateDiary")
public class UpdateDiaryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DiaryService diaryService = new DiaryService();

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			String saveDirectory = getServletContext().getRealPath("/upload/diary");
			int maxPostSize = 10 * 1024 * 1024;
			String encoding = "utf-8";
			FileRenamePolicy policy = new CommaFileRenamePolicy();
			
			MultipartRequest multiReq = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);
			
			int diaryNo = Integer.valueOf(multiReq.getParameter("updateDiaryNo"));
			
			Diary diary = diaryService.selectOneDiary(diaryNo);
			
			String content = multiReq.getParameter("editContent");
			String _designNo = multiReq.getParameter("designNo");
			String _fontNo = multiReq.getParameter("fontNo");
			int designNo = 0;
			int fontNo = 0;
		
			if(_designNo.isEmpty()) {
				designNo = diary.getDesignNo();
			}else {
				designNo = Integer.valueOf(_designNo);
			}
			if(_fontNo.isEmpty()) {
				fontNo = diary.getFontNo();
			} else {
				fontNo = Integer.valueOf(_fontNo);
			}
			
			
			diary.setContent(content);
			diary.setDesignNo(designNo);
			diary.setFontNo(fontNo);
			
			if (multiReq.getFile("updateFile") != null) {
				diary.setOriginalFilename(multiReq.getOriginalFileName("updateFile"));
				diary.setRenamedFilename(multiReq.getFilesystemName("updateFile"));
			}
			
			int result = diaryService.upDateDiary(diary);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect(request.getContextPath() + "/diary/diaryList");
	}

}

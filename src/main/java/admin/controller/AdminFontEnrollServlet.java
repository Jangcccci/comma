package admin.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import style.model.dto.Font;
import style.model.service.StyleService;

/**
 * Servlet implementation class AdminFontEnrollServlet
 */
@WebServlet("/admin/adminFontEnroll")
public class AdminFontEnrollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private StyleService styleService = new StyleService();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/views/admin/adminFontEnroll.jsp").forward(request, response);
	} // doGet() end

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String name = request.getParameter("name");
			String link = request.getParameter("link");
			
			Font font = new Font(0, name, link);
			
			int result = styleService.insertFont(font);
			request.getSession().setAttribute("msg", "폰트 추가 성공!");
			
		} catch (Exception e) {
			request.getSession().setAttribute("msg", "폰트 추가 실패!");
			e.printStackTrace();
		}
		
		response.sendRedirect(request.getContextPath() + "/admin/adminFontList");
	} // doPost() end

}

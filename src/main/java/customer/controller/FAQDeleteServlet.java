package customer.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import customer.model.service.FAQService;

/**
 * Servlet implementation class FAQDeleteServlet
 */
@WebServlet("/customer/faqDelete")
public class FAQDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private FAQService faqService = new FAQService();

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			int no = Integer.parseInt(request.getParameter("faqNo"));
			int result = faqService.deleteFaq(no);
			
			request.getSession().setAttribute("msg", "FAQ가 정상적으로 삭제되었습니다.");
		} catch(Exception e) {
			request.getSession().setAttribute("msg", "FAQ 삭제에 실패하셨습니다.");
			e.printStackTrace();
		}
		request.setAttribute("type", "faq");
		response.sendRedirect(request.getContextPath() + "/customer");
	} // doPost() end

}

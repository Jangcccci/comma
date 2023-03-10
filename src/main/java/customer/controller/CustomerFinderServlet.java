package customer.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import customer.model.dto.FAQ;
import customer.model.dto.Question;
import customer.model.service.FAQService;
import customer.model.service.QuestionService;
import member.model.dto.Member;
import member.model.dto.MemberRole;

/**
 * Servlet implementation class CustomerFinderServlet
 */
@WebServlet("/customer/customerFinder")
public class CustomerFinderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private QuestionService questionService = new QuestionService();
	private FAQService faqService = new FAQService();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Member member = (Member) request.getSession().getAttribute("loginMember");
		String nickname = request.getParameter("nickname");
		String searchType = request.getParameter("searchType");
		String searchContent = request.getParameter("searchContent");
		
		List<Question> questionList = new ArrayList<>();
		List<FAQ> faqList = new ArrayList<>();
		
		if ("question".equals(searchType)) {
			if ("".equals(searchContent)) {
				if (member.getMemberRole() == MemberRole.A || member.getMemberRole() == MemberRole.M) {
					questionList = questionService.selectAllQuestion();
				} else {
					questionList = questionService.selectMyAllQuestion(nickname);
				}
			} else {
				if (member.getMemberRole() == MemberRole.A || member.getMemberRole() == MemberRole.M) {
					questionList = questionService.selectFindQuestion(searchContent);
				} else {
					questionList = questionService.selectFindMyQuestion(nickname, searchContent);
				}
			}
			faqList = faqService.selectAllFAQ();
		} else {
			if (member.getMemberRole() == MemberRole.A || member.getMemberRole() == MemberRole.M) {
				questionList = questionService.selectAllQuestion();
			} else {
				questionList = questionService.selectMyAllQuestion(nickname);			
			}
			faqList = faqService.selectFindFaq(searchContent);
		}
		
		request.setAttribute("questionList", questionList);
		request.setAttribute("faqList", faqList);		
		request.setAttribute("type", searchType);
		request.getRequestDispatcher("/WEB-INF/views/customer/customerService.jsp").forward(request, response);
	} // doGet() end

}

package customer.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import customer.model.dto.Question;
import customer.model.service.QuestionService;

/**
 * Servlet implementation class Question
 */
@WebServlet("/customer/question")
public class QuestionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private QuestionService questionService = new QuestionService();
       
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<Question> questionList = questionService.selectAllQuestion();
		
		request.setAttribute("questionList", questionList);
		
		request.getRequestDispatcher("/WEB-INF/views/customer/question.jsp")
			.forward(request, response);
	}
}

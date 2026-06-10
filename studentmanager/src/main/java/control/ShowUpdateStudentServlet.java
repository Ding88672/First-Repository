package control;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import entity.Student;
import model.StudentModel;

@WebServlet("/ShowUpdateStudentServlet.do")
public class ShowUpdateStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("ListStudentServlet.do");
            return;
        }
        
        int id = Integer.parseInt(idStr);
        StudentModel model = new StudentModel();
        Student stu = model.getStudentById(id);
        
        if (stu != null) {
            request.setAttribute("student", stu);
            request.getRequestDispatcher("/jsp/studentupdate.jsp").forward(request, response);
        } else {
            response.sendRedirect("ListStudentServlet.do");
        }
    }
}
package control;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import entity.Student;
import model.StudentModel;

@WebServlet("/DoUpdateStudentServlet.do")
public class DoUpdateStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String idStr = request.getParameter("id");
        String studentId = request.getParameter("studentId");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String ageStr = request.getParameter("age");
        String major = request.getParameter("major");
        String grade = request.getParameter("grade");
        
        Student stu = new Student();
        stu.setId(Integer.parseInt(idStr));
        stu.setStudentId(studentId);
        stu.setName(name);
        stu.setGender(gender);
        stu.setAge(ageStr != null && !ageStr.isEmpty() ? Integer.parseInt(ageStr) : 0);
        stu.setMajor(major);
        stu.setGrade(grade);
        
        StudentModel model = new StudentModel();
        boolean success = model.updateStudent(stu);
        
        if (success) {
            response.sendRedirect("ListStudentServlet.do");
        } else {
            request.setAttribute("error", "修改失败！");
            request.setAttribute("student", stu);
            request.getRequestDispatcher("/jsp/studentupdate.jsp").forward(request, response);
        }
    }
}
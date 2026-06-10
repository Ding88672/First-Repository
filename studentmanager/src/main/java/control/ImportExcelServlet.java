package control;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import entity.Student;
import model.StudentModel;

@WebServlet("/ImportExcelServlet.do")
@MultipartConfig
public class ImportExcelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // POI 3.17 中的单元格类型常量
    private static final int CELL_TYPE_STRING = 1;
    private static final int CELL_TYPE_NUMERIC = 0;
    private static final int CELL_TYPE_FORMULA = 2;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            Part filePart = request.getPart("excelFile");
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("error", "请选择要上传的Excel文件！");
                request.getRequestDispatcher("/jsp/upload.jsp").forward(request, response);
                return;
            }
            
            try (InputStream fileContent = filePart.getInputStream();
                 Workbook workbook = new XSSFWorkbook(fileContent)) {
                
                Sheet sheet = workbook.getSheetAt(0);
                List<Student> studentList = new ArrayList<>();
                int failCount = 0;
                
                for (Row row : sheet) {
                    if (row.getRowNum() == 0) continue; // 跳过标题行
                    
                    String studentId = getCellValue(row, 0);
                    String name = getCellValue(row, 1);
                    String gender = getCellValue(row, 2);
                    int age = getIntCellValue(row, 3);
                    String major = getCellValue(row, 4);
                    String grade = getCellValue(row, 5);
                    
                    // 验证必填字段
                    if (studentId == null || studentId.isEmpty() || name == null || name.isEmpty()) {
                        failCount++;
                        continue;
                    }
                    
                    Student stu = new Student();
                    stu.setStudentId(studentId);
                    stu.setName(name);
                    stu.setGender(gender);
                    stu.setAge(age);
                    stu.setMajor(major);
                    stu.setGrade(grade);
                    studentList.add(stu);
                }
                
                if (studentList.isEmpty()) {
                    request.setAttribute("error", "Excel文件中没有有效数据！");
                } else {
                    StudentModel model = new StudentModel();
                    boolean success = model.batchInsert(studentList);
                    
                    if (success) {
                        request.setAttribute("message", "成功导入 " + studentList.size() + " 条学生数据！" + 
                                         (failCount > 0 ? " 跳过无效数据 " + failCount + " 条。" : ""));
                    } else {
                        request.setAttribute("error", "导入失败，请检查数据格式！");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "解析Excel文件失败：" + e.getMessage());
        }
        
        request.getRequestDispatcher("/jsp/upload.jsp").forward(request, response);
    }
    
    /**
     * 获取单元格的字符串值（正确处理数字和科学计数法）
     */
    private String getCellValue(Row row, int cellIndex) {
        Cell cell = row.getCell(cellIndex);
        if (cell == null) return "";
        
        int cellType = cell.getCellType();
        
        if (cellType == CELL_TYPE_STRING) {
            return cell.getStringCellValue().trim();
        } else if (cellType == CELL_TYPE_NUMERIC) {
            double numValue = cell.getNumericCellValue();
            // 如果是整数，转换为整数格式，避免科学计数法
            if (numValue == (long) numValue) {
                return String.valueOf((long) numValue);
            } else {
                return String.valueOf(numValue);
            }
        } else if (cellType == CELL_TYPE_FORMULA) {
            try {
                double formulaValue = cell.getNumericCellValue();
                if (formulaValue == (long) formulaValue) {
                    return String.valueOf((long) formulaValue);
                } else {
                    return String.valueOf(formulaValue);
                }
            } catch (Exception e) {
                return cell.getStringCellValue();
            }
        } else {
            return "";
        }
    }
    
    /**
     * 获取单元格的整数值
     */
    private int getIntCellValue(Row row, int cellIndex) {
        String val = getCellValue(row, cellIndex);
        if (val.isEmpty()) return 0;
        try {
            return (int) Double.parseDouble(val);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
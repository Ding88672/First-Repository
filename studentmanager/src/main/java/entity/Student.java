package entity;

public class Student {
    private int id;
    private String studentId;      // 学号
    private String name;           // 姓名
    private String gender;         // 性别
    private int age;               // 年龄
    private String major;          // 专业
    private String grade;          // 年级
    
    // 无参构造方法
    public Student() {}
    
    // 有参构造方法（不含id，id是数据库自增）
    public Student(String studentId, String name, String gender, int age, String major, String grade) {
        this.studentId = studentId;
        this.name = name;
        this.gender = gender;
        this.age = age;
        this.major = major;
        this.grade = grade;
    }
    
    // ========== 所有getter和setter方法 ==========
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getStudentId() {
        return studentId;
    }
    
    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public int getAge() {
        return age;
    }
    
    public void setAge(int age) {
        this.age = age;
    }
    
    public String getMajor() {
        return major;
    }
    
    public void setMajor(String major) {
        this.major = major;
    }
    
    public String getGrade() {
        return grade;
    }
    
    public void setGrade(String grade) {
        this.grade = grade;
    }
    
    // 方便打印的toString方法
    @Override
    public String toString() {
        return "Student [id=" + id + ", studentId=" + studentId + ", name=" + name + 
               ", gender=" + gender + ", age=" + age + ", major=" + major + ", grade=" + grade + "]";
    }
}
#include<stdio.h>
#include<time.h>
#include<windows.h>
#include<stdlib.h>
#include<string.h>
#include<conio.h>
#include <locale.h>

// 方向定义
#define U 1
#define D 2
#define L 3
#define R 4

// 文件与限制
#define MAX_USER 100
#define MAX_LOG 1000
#define USER_FILE "user.txt"
#define LOG_FILE "log.txt"
#define MAX_USERNAME_LEN 15
#define MAX_PASSWORD_LEN 15

// 蛇身
typedef struct SNAKE {
    int x;
    int y;
    struct SNAKE* next;
} snake;

// 用户
typedef struct {
    int id;
    char username[MAX_USERNAME_LEN + 1];
    char password[MAX_PASSWORD_LEN + 1];
} User;

// 日志
typedef struct {
    int log_id;
    int user_id;
    char username[MAX_USERNAME_LEN + 1];
    char start_time[30];
    int duration;
    int score;
} GameLog;

// 全局
int score = 0, add = 10;
int status, sleeptime = 200;
snake* head, * food;
snake* q;
int endgamestatus = 0;
User current_user;
time_t game_start_time;
char game_start_time_str[30];  // 保存游戏开始时间字符串
GameLog logs[MAX_LOG];
int log_count = 0;
int game_log_saved = 0;  // 标记日志是否已保存

// 函数声明
void Pos(int x, int y);
void SetColor(int color);
void HideCursor();
void creatMap();
void initsnake();
int biteself();
void createfood();
void cantcrosswall();
void snakemove();
void pause();
void gamecircle();
void welcometogame();
void endgame();
void gamestart();
int registerUser();
int loginUser();
void showUserInfo();
void loadLogs();
void saveLog(int user_id, const char* username, const char* start_time, int duration, int score);
void showLog();
void getCurrentTime(char* time_str);
int calculateDuration(time_t start);
int userExists(const char* username);
void redrawGame();
void saveCurrentGameLog();  // 新增：保存当前游戏日志

// 设置光标位置
void Pos(int x, int y) {
    COORD pos;
    HANDLE hOutput = GetStdHandle(STD_OUTPUT_HANDLE);
    pos.X = x;
    pos.Y = y;
    SetConsoleCursorPosition(hOutput, pos);
}

// 设置颜色
void SetColor(int color) {
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color);
}

// 隐藏光标
void HideCursor() {
    CONSOLE_CURSOR_INFO cursor_info = { 1, 0 };
    SetConsoleCursorInfo(GetStdHandle(STD_OUTPUT_HANDLE), &cursor_info);
}

// 获取当前时间
void getCurrentTime(char* time_str) {
    time_t now = time(NULL);
    struct tm* t = localtime(&now);
    sprintf(time_str, "%04d-%02d-%02d %02d:%02d:%02d",
        t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
        t->tm_hour, t->tm_min, t->tm_sec);
}

// 计算时长
int calculateDuration(time_t start) {
    return (int)(time(NULL) - start);
}

// 检查用户是否已存在
int userExists(const char* username) {
    FILE* fp = fopen(USER_FILE, "r");
    if (!fp) return 0;

    User temp;
    while (fscanf(fp, "%d,%[^,],%[^\n]\n", &temp.id, temp.username, temp.password) != EOF) {
        if (strcmp(temp.username, username) == 0) {
            fclose(fp);
            return 1;
        }
    }
    fclose(fp);
    return 0;
}

// 注册
int registerUser() {
    system("cls");
    SetColor(11);
    printf("==================== 注册账号 ====================\n");
    SetColor(7);

    FILE* fp = fopen(USER_FILE, "a+");
    if (!fp) {
        SetColor(12);
        printf("❌ 文件打开失败！\n");
        SetColor(7);
        system("pause");
        return 0;
    }

    User new_user;
    int max_id = 0;
    while (fscanf(fp, "%d,%[^,],%[^\n]\n", &new_user.id, new_user.username, new_user.password) != EOF) {
        if (new_user.id > max_id) max_id = new_user.id;
    }
    fclose(fp);

    while (1) {
        SetColor(14);
        printf("请输入用户名（1-%d位）：", MAX_USERNAME_LEN);
        SetColor(7);
        scanf("%s", new_user.username);

        if (strlen(new_user.username) < 1 || strlen(new_user.username) > MAX_USERNAME_LEN) {
            SetColor(12);
            printf("❌ 用户名长度不符合要求！\n");
            SetColor(7);
            system("pause");
            system("cls");
            continue;
        }

        if (userExists(new_user.username)) {
            SetColor(12);
            printf("❌ 用户名已存在！\n");
            SetColor(7);
            system("pause");
            system("cls");
            continue;
        }
        break;
    }

    while (1) {
        SetColor(14);
        printf("请输入密码（1-%d位）：", MAX_PASSWORD_LEN);
        SetColor(7);
        scanf("%s", new_user.password);

        if (strlen(new_user.password) < 1 || strlen(new_user.password) > MAX_PASSWORD_LEN) {
            SetColor(12);
            printf("❌ 密码长度不符合要求！\n");
            SetColor(7);
            system("pause");
            system("cls");
            continue;
        }
        break;
    }

    new_user.id = max_id + 1;

    fp = fopen(USER_FILE, "a");
    fprintf(fp, "%d,%s,%s\n", new_user.id, new_user.username, new_user.password);
    fclose(fp);

    SetColor(10);
    printf("\n✅ 注册成功！请使用新账号登录\n");
    SetColor(7);
    system("pause");
    system("cls");
    return 1;
}

// 登录
int loginUser() {
    while (1) {
        system("cls");
        SetColor(11);
        printf("==================== 贪吃蛇登录 ====================\n");
        SetColor(7);

        FILE* fp = fopen(USER_FILE, "r");
        if (!fp) {
            SetColor(14);
            printf("📝 未检测到用户文件，请先注册账号\n");
            SetColor(7);
            system("pause");
            registerUser();
            continue;
        }

        User users[MAX_USER];
        int user_count = 0;
        while (fscanf(fp, "%d,%[^,],%[^\n]\n", &users[user_count].id,
            users[user_count].username, users[user_count].password) != EOF) {
            user_count++;
            if (user_count >= MAX_USER) break;
        }
        fclose(fp);

        if (user_count == 0) {
            SetColor(14);
            printf("📝 暂无用户，请先注册账号\n");
            SetColor(7);
            system("pause");
            registerUser();
            continue;
        }

        char username[MAX_USERNAME_LEN + 1], password[MAX_PASSWORD_LEN + 1];
        int error_count = 0;
        while (error_count < 3) {
            SetColor(14);
            printf("\n用户名：");
            SetColor(7);
            scanf("%s", username);
            SetColor(14);
            printf("密码：");
            SetColor(7);
            scanf("%s", password);

            for (int i = 0; i < user_count; i++) {
                if (strcmp(users[i].username, username) == 0 &&
                    strcmp(users[i].password, password) == 0) {
                    current_user = users[i];
                    system("cls");
                    SetColor(10);
                    printf("✅ 登录成功！欢迎回来：%s\n", current_user.username);
                    SetColor(7);
                    system("pause");
                    return 1;
                }
            }

            error_count++;
            SetColor(12);
            printf("❌ 账号或密码错误！剩余 %d 次尝试机会\n", 3 - error_count);
            SetColor(7);

            if (error_count == 3) {
                SetColor(12);
                printf("错误次数过多，程序退出\n");
                SetColor(7);
                system("pause");
                return 0;
            }

            SetColor(14);
            printf("按 1 尝试重新登录，按 2 注册新账号：");
            int choice;
            scanf("%d", &choice);
            if (choice == 2) {
                registerUser();
                break;
            }
            system("cls");
        }
    }
}

// 显示用户信息
void showUserInfo() {
    // 标题：贪吃蛇作战
    SetColor(14);
    Pos(60, 1);  printf("======== 🐍 贪吃蛇 作战 🐍 ========");

    // 玩家信息
    SetColor(11);
    Pos(60, 3);  printf("┌──────────── 玩家信息 ────────────┐");
    SetColor(14);
    Pos(60, 4);  printf("│ 玩家：%-15s           │", current_user.username);
    SetColor(11);
    Pos(60, 5);  printf("└─────────────────────────────────┘");

    // 操作说明
    Pos(60, 7);  printf("┌──────────── 操作说明 ────────────┐");
    SetColor(7);
    Pos(60, 8);  printf("│ ↑↓←→ 移动   F5 查看日志         │");
    Pos(60, 9);  printf("│ F1 加速   F2 减速               │");
    Pos(60, 10); printf("│ 空格暂停   ESC 退出              │");
    SetColor(11);
    Pos(60, 11); printf("└─────────────────────────────────┘");
}

// 重新绘制游戏界面
void redrawGame() {
    // 清屏
    system("cls");
    // 重新绘制地图边界
    creatMap();
    // 重新绘制用户信息面板
    showUserInfo();
    // 重新绘制蛇
    q = head;
    while (q != NULL) {
        Pos(q->x, q->y);
        SetColor(10);
        printf("■");
        q = q->next;
    }
    // 重新绘制食物
    if (food != NULL) {
        Pos(food->x, food->y);
        SetColor(12);
        printf("■");
    }
    SetColor(7);
    // 重新绘制游戏数据
    SetColor(14);
    Pos(60, 13); printf("┌──────────── 游戏数据 ────────────┐");
    Pos(60, 14); printf("│ 得分：%-6d  单食：%d 分        │", score, add);
    Pos(60, 15); printf("└─────────────────────────────────┘");
    SetColor(7);
}

// 加载日志
void loadLogs() {
    FILE* fp = fopen(LOG_FILE, "r");
    if (!fp) {
        log_count = 0;
        return;
    }
    log_count = 0;
    GameLog temp;
    while (fscanf(fp, "%d,%d,%[^,],%[^,],%d,%d\n",
        &temp.log_id, &temp.user_id, temp.username, temp.start_time,
        &temp.duration, &temp.score) == 6) {
        if (log_count >= MAX_LOG) break;
        logs[log_count++] = temp;
    }
    fclose(fp);
}

// 保存日志
void saveLog(int user_id, const char* username, const char* start_time, int duration, int score) {
    FILE* fp;
    int max_log_id = 0;
    GameLog temp;

    // 读取当前最大ID
    fp = fopen(LOG_FILE, "r");
    if (fp != NULL) {
        while (fscanf(fp, "%d,%d,%[^,],%[^,],%d,%d\n",
            &temp.log_id, &temp.user_id, temp.username, temp.start_time,
            &temp.duration, &temp.score) == 6) {
            if (temp.log_id > max_log_id) max_log_id = temp.log_id;
        }
        fclose(fp);
    }

    // 追加新日志
    fp = fopen(LOG_FILE, "a");
    if (!fp) return;
    int new_log_id = max_log_id + 1;
    fprintf(fp, "%d,%d,%s,%s,%d,%d\n",
        new_log_id, user_id, username, start_time, duration, score);
    fclose(fp);

    // 重新加载日志到内存
    loadLogs();
}

// 保存当前游戏日志
void saveCurrentGameLog() {
    if (!game_log_saved) {
        int duration = calculateDuration(game_start_time);
        saveLog(current_user.id, current_user.username, game_start_time_str, duration, score);
        game_log_saved = 1;
    }
}

// 显示日志
void showLog() {
    // 先保存当前游戏的日志（如果还没保存的话）
    // 注意：查看日志时不应该保存当前游戏，因为游戏还在进行中
    // 所以这里不调用 saveCurrentGameLog()

    system("cls");
    SetColor(11);
    printf("==================== 游戏日志 ====================\n");
    SetColor(7);
    printf("%-6s %-8s %-12s %-20s %-8s %-6s\n",
        "日志ID", "用户ID", "用户名", "开始时间", "时长(秒)", "得分");
    printf("--------------------------------------------------------\n");

    int has_log = 0;
    for (int i = 0; i < log_count; i++) {
        if (logs[i].user_id == current_user.id) {
            printf("%-6d %-8d %-12s %-20s %-8d %-6d\n",
                logs[i].log_id, logs[i].user_id, logs[i].username,
                logs[i].start_time, logs[i].duration, logs[i].score);
            has_log = 1;
        }
    }

    if (!has_log) {
        SetColor(14);
        printf("\n暂无游戏记录，快去开始你的第一局游戏吧！\n");
        SetColor(7);
    }

    SetColor(10);
    printf("\n按任意键返回游戏...\n");
    SetColor(7);
    _getch();

    // 重新绘制游戏界面
    redrawGame();
}

// 创建地图
void creatMap() {
    SetColor(11);
    int i;
    for (i = 0; i < 58; i += 2) {
        Pos(i, 0); printf("■");
        Pos(i, 26); printf("■");
    }
    for (i = 1; i < 26; i++) {
        Pos(0, i); printf("■");
        Pos(56, i); printf("■");
    }
    SetColor(7);
}

// 初始化蛇
void initsnake() {
    snake* tail;
    int i;
    tail = (snake*)malloc(sizeof(snake));
    tail->x = 24;
    tail->y = 5;
    tail->next = NULL;

    for (i = 1; i <= 4; i++) {
        head = (snake*)malloc(sizeof(snake));
        head->next = tail;
        head->x = 24 + 2 * i;
        head->y = 5;
        tail = head;
    }

    SetColor(10);
    q = head;
    while (q != NULL) {
        Pos(q->x, q->y);
        printf("■");
        q = q->next;
    }
    SetColor(7);
}

// 自咬判断
int biteself() {
    snake* self = head->next;
    while (self != NULL) {
        if (self->x == head->x && self->y == head->y) return 1;
        self = self->next;
    }
    return 0;
}

// 生成食物
void createfood() {
    snake* food_1 = (snake*)malloc(sizeof(snake));
    while (1) {
        food_1->x = rand() % 52 + 2;
        food_1->y = rand() % 24 + 1;
        if (food_1->x % 2 == 0) break;
    }

    q = head;
    while (q != NULL) {
        if (q->x == food_1->x && q->y == food_1->y) {
            free(food_1);
            createfood();
            return;
        }
        q = q->next;
    }

    Pos(food_1->x, food_1->y);
    SetColor(12);
    printf("■");
    SetColor(7);
    food = food_1;
}

// 撞墙
void cantcrosswall() {
    if (head->x == 0 || head->x == 56 || head->y == 0 || head->y == 26) {
        endgamestatus = 1;
        saveCurrentGameLog();  // 保存日志
        endgame();
    }
}

// 蛇移动
void snakemove() {
    snake* nexthead = (snake*)malloc(sizeof(snake));
    cantcrosswall();

    if (status == U) {
        nexthead->x = head->x; nexthead->y = head->y - 1;
    } else if (status == D) {
        nexthead->x = head->x; nexthead->y = head->y + 1;
    } else if (status == L) {
        nexthead->x = head->x - 2; nexthead->y = head->y;
    } else if (status == R) {
        nexthead->x = head->x + 2; nexthead->y = head->y;
    }

    nexthead->next = head;
    head = nexthead;

    if (head->x == food->x && head->y == food->y) {
        score += add;
        createfood();
    } else {
        q = head;
        while (q->next->next != NULL) q = q->next;
        Pos(q->next->x, q->next->y);
        printf("  ");
        free(q->next);
        q->next = NULL;
    }

    SetColor(10);
    q = head;
    while (q != NULL) {
        Pos(q->x, q->y);
        printf("■");
        q = q->next;
    }
    SetColor(7);

    if (biteself()) {
        endgamestatus = 2;
        saveCurrentGameLog();  // 保存日志
        endgame();
    }
}

// 暂停
void pause() {
    while (1) {
        Sleep(100);
        if (GetAsyncKeyState(VK_SPACE)) break;
    }
}

// 游戏主循环
void gamecircle() {
    showUserInfo();
    status = R;
    game_start_time = time(NULL);
    getCurrentTime(game_start_time_str);
    game_log_saved = 0;  // 重置日志保存标记

    while (1) {
        SetColor(14);
        Pos(60, 13); printf("┌──────────── 游戏数据 ────────────┐");
        Pos(60, 14); printf("│ 得分：%-6d  单食：%d 分        │", score, add);
        Pos(60, 15); printf("└─────────────────────────────────┘");
        SetColor(7);

        if (GetAsyncKeyState(VK_UP) && status != D) status = U;
        else if (GetAsyncKeyState(VK_DOWN) && status != U) status = D;
        else if (GetAsyncKeyState(VK_LEFT) && status != R) status = L;
        else if (GetAsyncKeyState(VK_RIGHT) && status != L) status = R;
        else if (GetAsyncKeyState(VK_SPACE)) pause();
        else if (GetAsyncKeyState(VK_ESCAPE)) {
            endgamestatus = 3;
            saveCurrentGameLog();  // ESC退出时保存日志
            break;
        }
        else if (GetAsyncKeyState(VK_F1)) {
            if (sleeptime >= 50) { sleeptime -= 30; add += 2; }
        } else if (GetAsyncKeyState(VK_F2)) {
            if (sleeptime < 350) { sleeptime += 30; add = (add - 2 < 1) ? 1 : add - 2; }
        } else if (GetAsyncKeyState(VK_F5)) {
            showLog();
        }

        Sleep(sleeptime);
        snakemove();
    }
}

// 欢迎页 - 完全清空
void welcometogame() {
    system("cls");
    // 完全清空欢迎页
}

// 结束游戏
void endgame() {
    system("cls");
    SetColor(12);
    Pos(25, 8);  printf("=====================================");
    Pos(25, 9);  printf("=                                   =");
    Pos(25, 10); printf("=           游戏结束                =");
    Pos(25, 11); printf("=                                   =");
    Pos(25, 12); printf("=====================================");

    SetColor(14);
    Pos(30, 14);
    if (endgamestatus == 1) printf("原因：撞到墙壁");
    else if (endgamestatus == 2) printf("原因：咬到自己");
    else if (endgamestatus == 3) printf("原因：主动退出");

    Pos(30, 15); printf("最终得分：%d", score);
    Pos(30, 16); printf("游戏时长：%d 秒", calculateDuration(game_start_time));
    SetColor(7);

    Pos(30, 18);
    system("pause");
    exit(0);
}

// 游戏初始化
void gamestart() {
    system("mode con cols=100 lines=30");
    SetConsoleTitle("贪吃蛇游戏 - 美化版");
    HideCursor();
    loadLogs();
    welcometogame();
    creatMap();
    initsnake();
    createfood();
}

// 主函数
int main() {
    // 解决中文乱码
    system("chcp 65001");
    setlocale(LC_ALL, ".UTF8");

    srand((unsigned)time(NULL));
    if (!loginUser()) return 0;
    gamestart();
    gamecircle();
    endgame();
    return 0;
}

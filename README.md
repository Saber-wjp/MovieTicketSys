# 电影院购票系统（MovieTicketSys）

基于 JSP/Servlet 的电影院购票平台。用户可以浏览电影、选择场次、在线选座购票，并查看订单历史。

## 🎯 功能特性

### ✅ 用户功能
- 用户注册与登录（支持手机号和邮箱唯一性验证）
- 浏览所有电影与分类筛选（喜剧、动作、科幻、恐怖、爱情）
- 查看电影详情与放映场次
- 在线选座与购票
- 查看订单历史
- 个人中心与密码修改
- 订单退票功能（v1.1.0新增）

### ✅ 管理员功能
- 管理员登录与身份验证
- 电影管理（增删改查，合并列表和编辑界面）
- 场次管理（增删改查，合并列表和编辑界面）
- 用户管理（查看用户列表）
- 数据统计（用户数、电影数、今日场次数）
- 后台界面采用 Element UI 美化，提供更好的用户体验

### ✅ 核心特性
- 实时座位状态显示（可选/已售/已选）
- 多影厅场次管理（2个影厅，每个50座）
- 订单记录与追踪
- 自动座位初始化
- 字符编码自动处理
- 用户登录权限验证

## 🏗️ 技术栈

| 技术 | 版本 |
|------|------|
| Java | JDK 8+ |
| Servlet | 4.0+ |
| JSP | 2.3+ |
| MySQL | 8.0+ |
| Maven | 3.6+ |
| Tomcat | 7.0+（内置）|
| Element UI | 2.15.0+ |

## 📋 环境要求

### 快速安装
- **JDK 8+** - Java 开发工具包
- **MySQL 8.0+** - 数据库
- **Maven 3.6+** - 构建工具（可选，IDE 通常内置）
- **Windows / Linux / macOS** - 操作系统

### 数据库配置

**默认数据库配置** (位置：`src/main/java/com/movieticket/util/DBUtil.java`)

```properties
数据库主机: localhost
数据库端口: 3306
数据库名: MovieTicketSys
用户名: root
密码: 123456
```

## 🚀 快速开始

### 1️⃣ 初始化数据库

**方式一：MySQL 图形工具（推荐）**
1. 打开 DataGrip / MySQL Workbench
2. 连接到本地 MySQL
3. 打开项目根目录的 `database.sql`
4. 执行全部 SQL

**方式二：命令行**
```bash
mysql -u root -p123456 < database.sql
```

验证：连接 MySQL，执行 `SHOW DATABASES;`，应该能看到 `MovieTicketSys`

**注意：** `database.sql` 脚本会自动创建所有表结构和测试数据，包括：
- 10部电影
- 2个影厅（各50座）
- 40个场次
- 自动为每个场次生成50个座位
- 10个测试用户
- 5个示例订单

### 2️⃣ 启动应用

**在 IDE 中运行（推荐开发使用）**
- IntelliJ IDEA：右键项目 → `Run` 或按 `Shift + F10`
- 会自动编译并部署到 Tomcat

**命令行启动**
```bash
mvn clean compile
mvn tomcat7:run
```

### 3️⃣ 访问应用

打开浏览器访问：
```
http://localhost:8080/MovieTicketSys_war_exploded
```

或者直接：
```
http://localhost:8080
```

## 📱 使用指南

### 首页 - 电影浏览
```
URL: http://localhost:8080/index.jsp
功能: 
  - 展示所有电影
  - 按类型分类（全部、动作、科幻、恐怖、喜剧）
  - 点击电影卡片进入详情
```

### 注册 - 新用户
```
URL: http://localhost:8080/register.jsp
必填: 用户名、密码
可选: 手机号、邮箱
验证: 防重复注册（用户名、手机号、邮箱唯一性验证）
```

### 登录 - 用户认证
```
URL: http://localhost:8080/login.jsp
输入: 注册时的用户名和密码
验证: 密码必须完全匹配
```

### 电影详情 - 查看场次
```
URL: http://localhost:8080/movie/detail?id={电影ID}
显示: 
  - 电影信息（导演、演员、时长、描述）
  - 所有可用场次
  - 场次价格和影厅信息
  - 场次时间（可筛选未开场次）
操作: 点击"立即购票"进入选座
```

### 选座购票 - 在线购票
```
URL: http://localhost:8080/order/selectSeat?scheduleId={场次ID}
座位颜色:
  - 🟩 绿色：可选座位
  - 🟥 红色：已售座位
  - 🟧 橙色：已选座位
操作: 
  - 点击绿色座位选中
  - 点击已选座位取消
  - 提交订单完成购票
```

### 我的订单 - 查看历史
```
URL: http://localhost:8080/user/orders.jsp
信息: 
  - 订单号
  - 电影名称
  - 购票时间
  - 座位号
  - 支付状态
权限: 仅登录用户可访问
操作: 点击订单可申请退票（未过场次时间的订单）
```

### 个人中心 - 账户管理
```
URL: http://localhost:8080/user/profile.jsp
功能: 
  - 查看个人信息
  - 修改密码
权限: 仅登录用户可访问
```

### 管理员后台 - 系统管理
```
URL: http://localhost:8080/admin/login
功能: 
  - 管理员登录验证
  - 电影管理（添加、编辑、删除电影，采用合并式界面设计）
  - 场次管理（安排、编辑、删除场次，采用合并式界面设计）
  - 用户管理（查看所有用户）
  - 数据统计展示
权限: 仅管理员可访问
默认账户: admin / 123456
注意: 请访问 /admin/login 而不是 /admin/login.jsp
特点: 后台界面采用 Element UI 美化，提供现代化的用户界面体验
```

## 📊 数据库架构

### 核心数据表

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| **users** | 用户信息 | id, username, password, email, phone |
| **movies** | 电影信息 | id, title, type, director, duration, poster_url |
| **halls** | 影厅信息 | id, name, total_seats, rows, cols |
| **schedules** | 放映场次 | id, movie_id, hall_id, show_time, price |
| **seats** | 座位信息 | id, schedule_id, seat_number, status |
| **orders** | 订单信息 | id, order_number, user_id, schedule_id, seat_numbers, total_price, status |
| **admin** | 管理员信息 | id, username, password, create_time |

### ER 关系图
```
users (1) ──── (N) orders
                    |
                    | (1)
               schedules (1) ──── (N) seats
                    |
        ┌───────────┴──────────┐
        | (1)                  | (1)
      movies                 halls

admin (1) ──── (N) movies (管理)
admin (1) ──── (N) schedules (管理)
```

## 🧪 测试数据

初始化数据库后自动包含：

| 项目 | 数量 | 说明                               |
|------|------|----------------------------------|
| **电影** | 10部 | 喜剧、动作、科幻、恐怖、爱情 5种类型              |
| **影厅** | 2个 | 每个 50 座（5行×10列）                  |
| **场次** | 40场 | 时间范围：2025-12-20 至 2025-12-24     |
| **用户** | 10个 | user1~user10，密码都是123456          |
| **订单** | 5个 | 示例订单用于测试（状态：0=待支付, 1=已支付, 3=已取消） |

### 订单状态说明

| 状态值 | 含义 | 说明 |
|--------|------|------|
| 0 | 待支付 | 订单已创建但未付款 |
| 1 | 已支付 | 订单已付款，可退票 |
| 3 | 已取消 | 订单已退票 |

### 测试账户
```
用户名: user1  密码: 123456
用户名: user2  密码: 123456
...
用户名: user10 密码: 123456

管理员账户:
用户名: admin  密码: 123456
```

## 📁 完整项目结构

```
MoviesSys/
│
├── 📂 src/main/java/com/movieticket/
│   ├── dao/                      (数据访问层 - 6个 DAO)
│   │   ├── UserDAO.java          # 用户数据操作
│   │   ├── MovieDAO.java         # 电影数据操作
│   │   ├── OrderDAO.java         # 订单数据操作
│   │   ├── ScheduleDAO.java      # 场次数据操作
│   │   ├── HallDAO.java          # 影厅数据操作
│   │   └── AdminDAO.java         # 管理员数据操作
│   │
│   ├── entity/                   (实体类 - 6个 Entity)
│   │   ├── User.java             # 用户实体
│   │   ├── Movie.java            # 电影实体
│   │   ├── Order.java            # 订单实体
│   │   ├── Schedule.java         # 场次实体
│   │   ├── Hall.java             # 影厅实体
│   │   └── Admin.java            # 管理员实体
│   │
│   ├── servlet/                  (控制层 - 5个 Servlet)
│   │   ├── AuthServlet.java      # 认证处理（登录）
│   │   ├── MovieServlet.java     # 电影处理（列表、详情）
│   │   ├── OrderServlet.java     # 订单处理（选座、购票、退票）
│   │   ├── UserServlet.java      # 用户处理（注册、个人中心）
│   │   └── AdminServlet.java     # 管理员后台处理
│   │
│   ├── filter/                   (过滤器 - 3个 Filter)
│   │   ├── CharacterEncodingFilter.java  # 字符编码
│   │   ├── UserLoginFilter.java  # 用户登录验证
│   │   └── AdminLoginFilter.java  # 管理员登录验证
│   │
│   └── util/                     (工具类)
│       └── DBUtil.java           # 数据库连接
│
├── 📂 src/main/webapp/           (前端页面 - 13个 JSP)
│   ├── 📂 WEB-INF/
│   │   ├── web.xml               # Servlet 配置
│   │   ├── classes/              # 编译输出（自动生成）
│   │   └── lib/                  # 依赖库
│   │
│   ├── 📂 movie/                 (电影相关)
│   │   ├── list.jsp              # 电影列表（分类筛选）
│   │   └── detail.jsp            # 电影详情（场次选择）
│   │
│   ├── 📂 WEB-INF/views/order/   (订单相关)
│   │   ├── selectSeat.jsp        # 选座界面
│   │   └── success.jsp           # 购票成功
│   │
│   ├── 📂 WEB-INF/views/user/    (用户相关)
│   │   ├── profile.jsp           # 个人中心
│   │   └── orders.jsp            # 我的订单
│   │
│   ├── 📂 WEB-INF/views/admin/   (管理员后台 - 采用Element UI美化)
│   │   ├── login.jsp             # 管理员登录页
│   │   ├── index.jsp             # 后台首页
│   │   ├── user_list.jsp         # 用户管理
│   │   ├── movies.jsp            # 电影管理（合并列表和编辑）
│   │   ├── schedules.jsp         # 场次管理（合并列表和编辑）
│   │   └── instructions.jsp     # 管理员操作说明
│   │
│   ├── index.jsp                 # 首页
│   ├── login.jsp                 # 登录页
│   ├── register.jsp              # 注册页
│   └── error.jsp                 # 错误页面
│
├── 📂 target/                    (Maven 构建输出 - 可忽略)
│
├── pom.xml                       # Maven 配置文件
├── database.sql                  # 数据库初始化脚本
└── README.md                     # 本文件
```

## 🔧 常用命令

```bash
# 构建和运行
mvn clean                    # 清理构建目录
mvn compile                  # 编译源代码
mvn package                  # 打包成 WAR
mvn tomcat7:run             # 运行内置 Tomcat
mvn clean package -DskipTests  # 打包但跳过测试

# 数据库初始化
mysql -u root -p < database.sql      # Linux/Mac
mysql -u root -p123456 < database.sql  # Windows
```

## ❓ 常见问题

### Q1: 数据库连接失败
**症状：** 启动报错 `java.sql.SQLException: Cannot get a connection`

**解决步骤：**
1. ✓ 确认 MySQL 服务已启动
2. ✓ 运行 `mysql -u root -p123456` 验证连接
3. ✓ 检查 `DBUtil.java` 中的数据库配置是否正确
4. ✓ 确保 `database.sql` 已执行成功

### Q2: 电影详情页面 404
**症状：** 点击电影详情显示 404 错误

**解决步骤：**
1. ✓ 重新部署应用（Clean + Rebuild）
2. ✓ 检查 URL 格式是否为 `/movie/detail?id=1`
3. ✓ 确认数据库中确实存在该电影 ID

### Q3: 选座功能不工作
**症状：** 点击座位无反应或显示错误

**解决步骤：**
1. ✓ 查看浏览器开发者工具（F12）的 Console 是否有错误
2. ✓ 确认场次 ID 正确
3. ✓ 确保已登录用户
4. ✓ 检查JavaScript函数是否正确处理data属性
5. ✓ 确认页面已正确加载所有必要资源

### Q4: 修改数据库配置
**操作：** 编辑 `src/main/java/com/movieticket/util/DBUtil.java`

```java
private static final String URL = "jdbc:mysql://localhost:3306/MovieTicketSys?...";
private static final String USERNAME = "root";
private static final String PASSWORD = "123456";  // 改为您的密码
```

### Q5: 打包成 WAR 文件
**命令：** `mvn clean package`

生成的 WAR 文件位于 `target/MovieTicketSys.war`，可部署到任何 Tomcat 服务器。

### Q6: 管理员登录页面出现重定向循环
**症状：** 访问管理员登录页面时浏览器提示"重定向次数过多"

**解决步骤：**
1. ✓ 确保访问的是正确的URL：`http://localhost:8080/admin/login`
2. ✓ 不要直接访问JSP文件（如`/admin/login.jsp`）
3. ✓ 检查浏览器缓存，尝试清除缓存后重新访问
4. ✓ 重启Tomcat服务器

### Q7: 管理员登录后出现500错误
**症状：** 管理员登录成功后访问首页或其他页面时出现500内部服务器错误

**解决步骤：**
1. ✓ 检查控制台日志，查找具体的错误信息
2. ✓ 确认JSP页面中对session属性的引用是否正确
3. ✓ 检查Servlet中session属性的类型是否匹配

### Q8: 如何退票？
**操作：** 
1. 登录系统后进入"我的订单"页面
2. 找到需要退票的订单（状态为"已支付"）
3. 点击订单右侧的"退票"按钮
4. 确认退票操作
5. 退票成功后订单状态将变为"已取消"

**注意：**
- 只能退还未过场次时间的订单
- 只能退状态为"已支付"的订单
- 退票后金额将原路退回（演示系统中仅为状态变更）

## 🚢 部署指南

### 本地开发
1. 在 IDE 中直接运行（推荐）
2. 或使用 `mvn tomcat7:run` 启动

### 远程部署（生产环境）

**准备步骤：**
1. 修改 `DBUtil.java` 中的数据库连接信息
2. 修改默认测试用户密码
3. 运行 `mvn clean package` 生成 WAR
4. 将 `MovieTicketSys.war` 放入 Tomcat 的 `webapps` 目录
5. 启动 Tomcat

**生产建议：**
- 使用数据库连接池（HikariCP、Druid）
- 配置 HTTPS
- 修改默认密码
- 定期备份数据库
- 考虑添加日志系统（Log4j）

## 📄 许可证

MIT License

## 👤 作者

Developed with 王金鹏&&赖泽谋&&朱备浪❤️

---

**有问题？** 查看上面的 FAQ 部分或检查控制台日志了解更多信息。

## 📝 更新日志

### 场次管理页面，修改现有记录，添加新的场次，存在bug。日后再修复了 

### v1.2.1（最新版本）
- ✅ 修复前台页面图片加载导致的布局混乱问题
- ✅ 优化电影海报图片加载失败时的默认显示效果
- ✅ 统一前台页面样式，增强布局稳定性
- ✅ 修复不同页面间样式不一致的问题
- ✅ 修复电影详情页场次显示问题，现在可以显示所有场次（不仅限于未来场次）
- ✅ 增强管理员用户管理功能，支持用户的增删改查操作
- ✅ 修复选座页面JavaScript闭包问题，解决点击座位无反应的问题
- ✅ 管理员后台界面采用 Element UI 美化，提升用户体验
- ✅ 电影管理和场次管理页面采用合并式设计（列表和编辑在同一页面）

### v1.2.0
- ✅ 添加管理员后台管理系统
- ✅ 实现电影和场次的增删改查功能
- ✅ 添加用户管理界面
- ✅ 实现数据统计展示
- ✅ 添加管理员登录验证
- ✅ 增强用户注册验证（手机号、邮箱格式和唯一性验证）
- ✅ 添加订单退票功能
- ✅ 修复注册成功后提示信息显示问题
- ✅ 优化所有数据库查询的资源管理
- ✅ 增强错误处理和日志记录
- ✅ 修复管理员登录页面重定向循环问题
- ✅ 修复管理员登录后500错误问题
- ✅ 修复所有管理员JSP页面中的Session引用问题
- ✅ 修复电影添加时无法设置上映日期的问题
- ✅ 修复场次安排时的日期时间解析问题
- ✅ 修复影厅属性引用不一致的问题
- ✅ 更新管理员功能文档说明

### v1.0.1
- ✅ 修复电影详情 404 错误
- ✅ 优化 Servlet 路由配置
- ✅ 完善数据库字段映射
- ✅ 添加详细调试日志
- ✅ 清理编译产物目录

### v1.0.0
- ✅ 用户注册/登录功能
- ✅ 电影浏览与分类筛选
- ✅ 在线选座购票
- ✅ 订单管理
- ✅ 个人中心
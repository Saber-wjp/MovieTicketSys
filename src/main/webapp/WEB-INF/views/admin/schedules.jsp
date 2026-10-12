<%-- src/main/webapp/WEB-INF/views/admin/schedule_management.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>场次管理 - 江南影院</title>
  <!-- 引入 Element UI 样式 -->
  <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
  <!-- 引入 Vue 和 Element UI JS -->
  <script src="https://unpkg.com/vue@2.6.14/dist/vue.js"></script>
  <script src="https://unpkg.com/element-ui/lib/index.js"></script>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif;
      background-color: #f5f7fa;
      height: 100vh;
      overflow: hidden;
    }
    .admin-container {
      height: 100vh;
      display: flex;
      flex-direction: column;
    }
    .header-container {
      background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
      color: white;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    }
    .header-content {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 20px;
      height: 60px;
    }
    .header-left {
      display: flex;
      align-items: center;
    }
    .logo {
      font-size: 24px;
      font-weight: 600;
      margin-right: 10px;
      color: #ecf0f1;
    }
    .logo-icon {
      margin-right: 10px;
      font-size: 26px;
      color: #ecf0f1;
    }
    .admin-info {
      display: flex;
      align-items: center;
      gap: 15px;
    }
    .admin-avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.2);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      color: white;
    }
    .main-container {
      display: flex;
      flex: 1;
      overflow: hidden;
    }
    .sidebar-container {
      width: 220px;
      background-color: #fff;
      box-shadow: 2px 0 8px 0 rgba(29,35,41,.05);
      overflow-y: auto;
      transition: all 0.3s;
    }
    .sidebar-menu {
      border-right: none;
    }
    .content-container {
      flex: 1;
      padding: 20px;
      overflow-y: auto;
    }
    .page-header {
      background: white;
      padding: 20px 24px;
      border-radius: 8px;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
      margin-bottom: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .page-title {
      font-size: 20px;
      font-weight: 600;
      color: #303133;
      display: flex;
      align-items: center;
    }
    .page-title i {
      margin-right: 10px;
      color: #409EFF;
    }
    .header-actions {
      display: flex;
      gap: 10px;
    }
    .table-container {
      background: white;
      border-radius: 8px;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
      overflow: hidden;
      padding: 20px;
    }
    .empty-message {
      text-align: center;
      padding: 50px;
      color: #909399;
      font-size: 16px;
    }
    .footer {
      text-align: center;
      padding: 15px 0;
      color: #909399;
      font-size: 14px;
      border-top: 1px solid #e4e7ed;
      background-color: #fff;
    }
    .schedule-count {
      color: #909399;
      font-size: 14px;
      margin-top: 15px;
    }
    .action-buttons {
      display: flex;
      gap: 8px;
    }
    .time-display {
      font-size: 14px;
      color: rgba(255, 255, 255, 0.9);
      margin-right: 20px;
      font-family: monospace;
      background-color: rgba(0, 0, 0, 0.2);
      padding: 4px 8px;
      border-radius: 4px;
    }
    .el-button--small {
      padding: 7px 15px;
    }
    .el-dialog {
      border-radius: 8px;
    }
    .el-form-item__label {
      font-weight: 500;
    }
    .el-input__inner {
      border-radius: 4px;
    }
    .time-badge {
      background-color: #e6f7ff;
      color: #1890ff;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      border: 1px solid #91d5ff;
    }
    .price-badge {
      background-color: #f6ffed;
      color: #52c41a;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      border: 1px solid #b7eb8f;
    }
    .movie-info,
    .hall-info {
      background: #fafafa;
      padding: 12px;
      border-radius: 6px;
      margin-top: 10px;
      border-left: 4px solid #409EFF;
    }
    .movie-info h4,
    .hall-info h4 {
      margin: 0 0 8px 0;
      color: #303133;
      font-size: 14px;
      font-weight: 600;
    }
    .movie-info p,
    .hall-info p {
      margin: 4px 0;
      color: #606266;
      font-size: 13px;
    }
    .hint-box {
      background-color: #fffbe6;
      border: 1px solid #ffe58f;
      border-left: 4px solid #faad14;
      padding: 16px;
      border-radius: 6px;
      margin-top: 20px;
    }
    .hint-box h4 {
      margin-top: 0;
      margin-bottom: 8px;
      color: #d48806;
      font-size: 14px;
    }
    .hint-box p {
      margin: 4px 0;
      color: #d48806;
      font-size: 13px;
    }
    .error-message {
      background: #ffebee;
      color: #f44336;
      padding: 15px;
      border-radius: 5px;
      margin-bottom: 20px;
      border-left: 4px solid #f44336;
    }
    @media (max-width: 992px) {
      .sidebar-container {
        width: 64px;
      }
      .logo-text {
        display: none;
      }
    }
  </style>
</head>
<body>
<div id="app" class="admin-container">
  <!-- 头部导航 -->
  <el-header class="header-container">
    <div class="header-content">
      <div class="header-left">
        <i class="el-icon-film logo-icon"></i>
        <span class="logo">江南影院后台管理系统</span>
        <div class="time-display">{{currentTime}}</div>
      </div>
      <div class="admin-info">
        <div class="admin-avatar">
          <i class="el-icon-user"></i>
        </div>
        <span>管理员：${admin}</span>
        <el-button type="text" @click="handleLogout" style="color: white;">
          退出登录 <i class="el-icon-switch-button"></i>
        </el-button>
      </div>
    </div>
  </el-header>

  <div class="main-container">
    <!-- 侧边栏菜单 -->
    <aside class="sidebar-container">
      <el-menu
              :default-active="activeMenu"
              class="sidebar-menu"
              background-color="#fff"
              text-color="#303133"
              active-text-color="#409EFF"
              :collapse="isCollapse"
              @select="handleMenuSelect">
        <el-menu-item index="1">
          <i class="el-icon-s-home"></i>
          <span slot="title">首页</span>
        </el-menu-item>
        <el-menu-item index="2">
          <i class="el-icon-user"></i>
          <span slot="title">用户管理</span>
        </el-menu-item>
        <el-menu-item index="3">
          <i class="el-icon-video-camera"></i>
          <span slot="title">电影管理</span>
        </el-menu-item>
        <el-menu-item index="4">
          <i class="el-icon-date"></i>
          <span slot="title">场次管理</span>
        </el-menu-item>
      </el-menu>
    </aside>

    <!-- 主内容区域 -->
    <main class="content-container">
      <!-- 页面标题 -->
      <div class="page-header">
        <h2 class="page-title">
          <i class="el-icon-date"></i> 场次管理
        </h2>
        <div class="header-actions">
          <el-button type="primary" icon="el-icon-circle-plus-outline" @click="showAddDialog">
            安排新场次
          </el-button>
          <el-button type="default" icon="el-icon-s-home" @click="goToHome">
            返回首页
          </el-button>
        </div>
      </div>

      <!-- 错误提示 -->
      <c:if test="${not empty param.error}">
        <div class="error-message">
          ${param.error}
        </div>
      </c:if>

      <!-- 场次表格 -->
      <div class="table-container">
        <el-table
                :data="schedules"
                style="width: 100%"
                v-loading="loading"
                border
                stripe>
          <el-table-column prop="id" label="ID" width="80" align="center"></el-table-column>
          <el-table-column prop="movieTitle" label="电影名称" width="180"></el-table-column>
          <el-table-column prop="hallName" label="影厅" width="120"></el-table-column>
          <el-table-column prop="totalSeats" label="座位数" width="100" align="center">
            <template slot-scope="scope">
              ${scope.row.hall.totalSeats}
            </template>
          </el-table-column>
          <el-table-column prop="showTime" label="放映时间" width="180" align="center">
            <template slot-scope="scope">
              <span class="time-badge">{{ formatDateTime(scope.row.showTime) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="price" label="票价" width="120" align="center">
            <template slot-scope="scope">
              <span class="price-badge">￥{{ scope.row.price }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="180" align="center" fixed="right">
            <template slot-scope="scope">
              <div class="action-buttons">
                <el-button
                        type="primary"
                        size="small"
                        icon="el-icon-edit"
                        @click="handleEdit(scope.row)">
                  编辑
                </el-button>
                <el-popconfirm
                        title="确定要删除这个场次吗？"
                        @confirm="handleDelete(scope.row)"
                        confirm-button-text="确定"
                        cancel-button-text="取消"
                        icon="el-icon-warning"
                        icon-color="red">
                  <el-button
                          slot="reference"
                          type="danger"
                          size="small"
                          icon="el-icon-delete">
                    删除
                  </el-button>
                </el-popconfirm>
              </div>
            </template>
          </el-table-column>
        </el-table>

        <!-- 空状态 -->
        <div v-if="!schedules || schedules.length === 0" class="empty-message">
          <i class="el-icon-date" style="font-size: 48px; color: #dcdfe6; margin-bottom: 16px;"></i>
          <p>暂无场次数据</p>
          <p style="margin-top: 10px; font-size: 14px;">点击"安排新场次"按钮开始安排</p>
        </div>

        <!-- 场次统计 -->
        <div class="schedule-count" v-if="schedules && schedules.length > 0">
          共 {{ schedules.length }} 个场次
        </div>
      </div>

      <!-- 提示信息 -->
      <div class="hint-box">
        <h4><i class="el-icon-warning"></i> 提示：</h4>
        <p>1. 安排场次后，系统会自动为该场次生成座位信息</p>
        <p>2. 放映时间请选择未来的时间</p>
        <p>3. 票价应合理设置，建议在30-150元之间</p>
      </div>
    </main>
  </div>

  <!-- 页脚 -->
  <footer class="footer">
    <p>© 2025 江南影院售票平台 | 后台管理系统 v2.0</p>
  </footer>

  <!-- 添加/编辑场次对话框 -->
  <el-dialog
          :title="dialogTitle"
          :visible.sync="scheduleDialogVisible"
          width="600px"
          @close="resetScheduleForm">
    <el-form ref="scheduleForm" :model="scheduleForm" :rules="formRules" label-width="100px">
      <el-input type="hidden" v-model="scheduleForm.id"></el-input>

      <el-form-item label="选择电影" prop="movieId">
        <el-select
                v-model="scheduleForm.movieId"
                placeholder="选择电影"
                style="width: 100%"
                @change="onMovieChange">
          <el-option
                  v-for="movie in movies"
                  :key="movie.id"
                  :label="`${movie.title} (${movie.type}, ${movie.duration}分钟)`"
                  :value="movie.id">
          </el-option>
        </el-select>

        <div v-if="selectedMovie" class="movie-info">
          <h4>{{ selectedMovie.title }}</h4>
          <p>类型：{{ selectedMovie.type }}</p>
          <p>导演：{{ selectedMovie.director }}</p>
          <p>时长：{{ selectedMovie.duration }}分钟</p>
        </div>
      </el-form-item>

      <el-form-item label="选择影厅" prop="hallId">
        <el-select
                v-model="scheduleForm.hallId"
                placeholder="选择影厅"
                style="width: 100%"
                @change="onHallChange">
          <el-option
                  v-for="hall in halls"
                  :key="hall.id"
                  :label="`${hall.name} (${hall.totalSeats}座, ${hall.rowsCount}行${hall.colsCount}列)`"
                  :value="hall.id">
          </el-option>
        </el-select>

        <div v-if="selectedHall" class="hall-info">
          <h4>{{ selectedHall.name }}</h4>
          <p>总座位数：{{ selectedHall.totalSeats }}</p>
          <p>座位布局：{{ selectedHall.rowsCount }}行 {{ selectedHall.colsCount }}列</p>
        </div>
      </el-form-item>

      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="放映时间" prop="showTime">
            <el-date-picker
                    v-model="scheduleForm.showTime"
                    type="datetime"
                    placeholder="选择放映时间"
                    value-format="yyyy-MM-dd HH:mm:ss"
                    format="yyyy-MM-dd HH:mm"
                    style="width: 100%"
                    :picker-options="datePickerOptions">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="票价(元)" prop="price">
            <el-input-number
                    v-model="scheduleForm.price"
                    :min="0"
                    :max="1000"
                    :step="10"
                    placeholder="请输入票价"
                    style="width: 100%">
            </el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <span slot="footer" class="dialog-footer">
            <el-button @click="scheduleDialogVisible = false">取消</el-button>
            <el-button type="primary" @click="submitScheduleForm" :loading="scheduleLoading">
                {{ dialogTitle === '安排新场次' ? '安排场次' : '保存修改' }}
            </el-button>
        </span>
  </el-dialog>
</div>

<script>
  new Vue({
    el: '#app',
    data() {
      return {
        activeMenu: '4',
        isCollapse: false,
        currentTime: '',
        loading: false,
        scheduleDialogVisible: false,
        scheduleLoading: false,
        dialogTitle: '安排新场次',
        scheduleForm: {
          id: '',
          movieId: '',
          hallId: '',
          showTime: '',
          price: 50
        },
        selectedMovie: null,
        selectedHall: null,
        formRules: {
          movieId: [
            { required: true, message: '请选择电影', trigger: 'change' }
          ],
          hallId: [
            { required: true, message: '请选择影厅', trigger: 'change' }
          ],
          showTime: [
            { required: true, message: '请选择放映时间', trigger: 'blur' },
            {
              validator: (rule, value, callback) => {
                if (!value) {
                  callback(new Error('请选择放映时间'));
                  return;
                }
                const selectedTime = new Date(value);
                const now = new Date();
                if (selectedTime <= now) {
                  callback(new Error('放映时间必须晚于当前时间'));
                } else {
                  callback();
                }
              },
              trigger: 'blur'
            }
          ],
          price: [
            { required: true, message: '请输入票价', trigger: 'blur' },
            { type: 'number', min: 0, message: '票价不能为负数', trigger: 'blur' }
          ]
        },
        datePickerOptions: {
          disabledDate(time) {
            return time.getTime() < Date.now();
          }
        },
        schedules: [],
        movies: [],
        halls: [],
        contextPath: '${pageContext.request.contextPath}'
      };
    },
    mounted() {
      this.updateTime();
      setInterval(this.updateTime, 1000);

      // 加载数据
      this.loadSchedules();
      this.loadMovies();
      this.loadHalls();

      // 根据当前URL设置激活的菜单项
      const path = window.location.pathname;
      if (path.includes('/admin/users')) {
        this.activeMenu = '2';
      } else if (path.includes('/admin/movies')) {
        this.activeMenu = '3';
      } else if (path.includes('/admin/schedules')) {
        this.activeMenu = '4';
      } else {
        this.activeMenu = '1';
      }
    },
    methods: {
      updateTime() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hour = String(now.getHours()).padStart(2, '0');
        const minute = String(now.getMinutes()).padStart(2, '0');
        const second = String(now.getSeconds()).padStart(2, '0');
        this.currentTime = `${year}-${month}-${day} ${hour}:${minute}:${second}`;
      },
      handleMenuSelect(index) {
        switch(index) {
          case '1':
            window.location.href = this.contextPath + '/admin/';
            break;
          case '2':
            window.location.href = this.contextPath + '/admin/users';
            break;
          case '3':
            window.location.href = this.contextPath + '/admin/movies';
            break;
          case '4':
            window.location.href = this.contextPath + '/admin/schedules';
            break;
        }
      },
      handleLogout() {
        this.$confirm('确定要退出登录吗?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          window.location.href = this.contextPath + '/admin/logout';
        }).catch(() => {
          // 用户取消操作
        });
      },
      goToHome() {
        window.location.href = this.contextPath + '/admin/';
      },
      loadSchedules() {
        // 将JSP中的场次数据转换为Vue数据
        this.schedules = [
          <c:forEach var="schedule" items="${schedules}" varStatus="status">
          {
            id: ${schedule.id},
            movieId: ${schedule.movieId},
            movieTitle: '${schedule.movie.title}',
            hallId: ${schedule.hallId},
            hallName: '${schedule.hall.name}',
            showTime: '${schedule.showTime}',
            price: ${schedule.price},
            hall: {
              totalSeats: ${schedule.hall.totalSeats},
              rowsCount: ${schedule.hall.rowsCount},
              colsCount: ${schedule.hall.colsCount}
            }
          }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ];
      },
      loadMovies() {
        // 将JSP中的电影数据转换为Vue数据
        this.movies = [
          <c:forEach var="movie" items="${movies}" varStatus="status">
          {
            id: ${movie.id},
            title: '${movie.title}',
            type: '${movie.type}',
            director: '${movie.director}',
            duration: ${movie.duration}
          }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ];
      },
      loadHalls() {
        // 将JSP中的影厅数据转换为Vue数据
        this.halls = [
          <c:forEach var="hall" items="${halls}" varStatus="status">
          {
            id: ${hall.id},
            name: '${hall.name}',
            totalSeats: ${hall.totalSeats},
            rowsCount: ${hall.rowsCount},
            colsCount: ${hall.colsCount}
          }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ];
      },
      formatDateTime(dateStr) {
        if (!dateStr) return '';
        const date = new Date(dateStr);
        return date.toLocaleString('zh-CN', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit',
          hour12: false
        }).replace(/\//g, '-').replace(' ', ' ');
      },
      showAddDialog() {
        this.dialogTitle = '安排新场次';
        this.scheduleDialogVisible = true;
        this.selectedMovie = null;
        this.selectedHall = null;
      },
      resetScheduleForm() {
        if (this.$refs.scheduleForm) {
          this.$refs.scheduleForm.resetFields();
        }
        this.scheduleForm = {
          id: '',
          movieId: '',
          hallId: '',
          showTime: '',
          price: 50
        };
        this.selectedMovie = null;
        this.selectedHall = null;
      },
      onMovieChange(movieId) {
        this.selectedMovie = this.movies.find(movie => movie.id === movieId) || null;
      },
      onHallChange(hallId) {
        this.selectedHall = this.halls.find(hall => hall.id === hallId) || null;
      },
      handleEdit(schedule) {
        this.dialogTitle = '编辑场次';
        this.scheduleForm = {
          id: schedule.id,
          movieId: schedule.movieId,
          hallId: schedule.hallId,
          showTime: schedule.showTime,
          price: schedule.price
        };

        // 设置选中的电影和影厅信息
        this.selectedMovie = this.movies.find(movie => movie.id === schedule.movieId) || null;
        this.selectedHall = this.halls.find(hall => hall.id === schedule.hallId) || null;

        this.scheduleDialogVisible = true;
      },
      submitScheduleForm() {
        this.$refs.scheduleForm.validate((valid) => {
          if (valid) {
            this.scheduleLoading = true;

            // 创建表单提交
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = this.contextPath + '/admin/schedule_save';
            form.style.display = 'none';

            // 添加表单字段
            const fields = ['id', 'movie_id', 'hall_id', 'show_time', 'price'];
            fields.forEach(field => {
              const input = document.createElement('input');
              input.type = 'text';
              input.name = field;

              let value;
              switch(field) {
                case 'movie_id':
                  value = this.scheduleForm.movieId;
                  break;
                case 'hall_id':
                  value = this.scheduleForm.hallId;
                  break;
                case 'show_time':
                  value = this.scheduleForm.showTime;
                  break;
                case 'price':
                  value = this.scheduleForm.price;
                  break;
                default:
                  value = this.scheduleForm[field];
              }

              if (value === null || value === undefined) {
                value = '';
              }

              // 处理数字类型
              if (field === 'price' && typeof value === 'number') {
                value = value.toString();
              }

              input.value = value;
              form.appendChild(input);
            });

            document.body.appendChild(form);
            form.submit();
          } else {
            return false;
          }
        });
      },
      handleDelete(schedule) {
        // 使用原生表单提交删除请求
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = this.contextPath + '/admin/schedule_delete';
        form.style.display = 'none';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = schedule.id;
        form.appendChild(input);

        document.body.appendChild(form);
        form.submit();
      }
    }
  });
</script>
</body>
</html>
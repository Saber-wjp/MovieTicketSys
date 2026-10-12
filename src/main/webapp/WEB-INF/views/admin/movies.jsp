<%-- src/main/webapp/WEB-INF/views/admin/movies.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>电影管理 - 江南影院</title>
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
            margin-bottom: 20px;
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
        .movie-count {
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
        .type-tag {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .type-action {
            background-color: #e8f4fd;
            color: #1890ff;
            border: 1px solid #a3d3ff;
        }
        .type-comedy {
            background-color: #f6ffed;
            color: #52c41a;
            border: 1px solid #b7eb8f;
        }
        .type-scifi {
            background-color: #f0f9ff;
            color: #096dd9;
            border: 1px solid #91d5ff;
        }
        .type-romance {
            background-color: #fff0f6;
            color: #eb2f96;
            border: 1px solid #ffadd2;
        }
        .type-horror {
            background-color: #fff7e6;
            color: #fa8c16;
            border: 1px solid #ffd591;
        }
        .type-animation {
            background-color: #f9f0ff;
            color: #722ed1;
            border: 1px solid #d3adf7;
        }
        .type-other {
            background-color: #fafafa;
            color: #8c8c8c;
            border: 1px solid #d9d9d9;
        }
        .movie-poster {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
        }
        .no-poster {
            width: 80px;
            height: 100px;
            background-color: #f5f5f5;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #bfbfbf;
            font-size: 12px;
        }
        .el-button {
            transition: all 0.3s;
        }
        .el-button:hover {
            transform: translateY(-2px);
        }
        .el-button:active {
            transform: translateY(0);
        }
        .el-table {
            border-radius: 8px;
        }
        .el-table th {
            background-color: #fafafa;
            color: #303133;
            font-weight: 600;
        }
        @media (max-width: 992px) {
            .sidebar-container {
                width: 64px;
            }
            .logo-text {
                display: none;
            }
        }
        .el-dialog {
            border-radius: 8px;
        }
        .el-dialog__body {
            padding: 20px;
        }
        .el-form-item {
            margin-bottom: 20px;
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
                    <i class="el-icon-video-camera"></i> 电影管理
                </h2>
                <div class="header-actions">
                    <el-button type="default" icon="el-icon-s-home" @click="goToHome">
                        返回首页
                    </el-button>
                    <el-button type="primary" icon="el-icon-circle-plus-outline" @click="showAddDialog">
                        添加新电影
                    </el-button>
                </div>
            </div>

            <!-- 错误提示 -->
            <c:if test="${not empty param.error}">
                <el-alert
                        title="${param.error}"
                        type="error"
                        show-icon
                        :closable="false"
                        style="margin-bottom: 20px;">
                </el-alert>
            </c:if>

            <!-- 电影表格 -->
            <div class="table-container">
                <el-table
                        :data="movies"
                        style="width: 100%"
                        border
                        stripe>
                    <el-table-column label="海报" width="100" align="center">
                        <template slot-scope="scope">
                            <div v-if="scope.row.posterUrl">
                                <img :src="scope.row.posterUrl" :alt="scope.row.title" class="movie-poster">
                            </div>
                            <div v-else class="no-poster">
                                无海报
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column prop="title" label="电影名称" width="200"></el-table-column>
                    <el-table-column prop="type" label="类型" width="120">
                        <template slot-scope="scope">
                            <span :class="getTypeClass(scope.row.type)" class="type-tag">
                                {{ scope.row.type }}
                            </span>
                        </template>
                    </el-table-column>
                    <el-table-column prop="director" label="导演" width="150"></el-table-column>
                    <el-table-column prop="duration" label="时长" width="100">
                        <template slot-scope="scope">
                            {{ scope.row.duration }}分钟
                        </template>
                    </el-table-column>
                    <el-table-column prop="releaseDate" label="上映日期" width="120">
                        <template slot-scope="scope">
                            {{ formatDate(scope.row.releaseDate) }}
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
                                        :title="`确定要删除电影【${scope.row.title}】吗？此操作不可恢复！`"
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
                <c:choose>
                    <c:when test="${empty movies}">
                        <div class="empty-message">
                            <i class="el-icon-video-camera" style="font-size: 48px; color: #dcdfe6; margin-bottom: 16px;"></i>
                            <p>暂无电影数据，点击"添加新电影"按钮开始添加电影</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- 电影统计 -->
                        <div class="movie-count">
                            共 ${movies.size()} 部电影
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <!-- 页脚 -->
    <footer class="footer">
        <p>© 2025 江南影院售票平台 | 后台管理系统 v2.0</p>
    </footer>

    <!-- 添加/编辑电影对话框 -->
    <el-dialog
            :title="dialogTitle"
            :visible.sync="movieDialogVisible"
            width="600px"
            @close="resetMovieForm">
        <el-form ref="movieForm" :model="movieForm" :rules="formRules" label-width="100px">
            <el-input type="hidden" v-model="movieForm.id"></el-input>

            <el-form-item label="电影名称" prop="title">
                <el-input v-model="movieForm.title" placeholder="请输入电影名称"></el-input>
            </el-form-item>

            <el-form-item label="电影类型" prop="type">
                <el-select v-model="movieForm.type" placeholder="选择类型" style="width: 100%">
                    <el-option value="" label="选择类型"></el-option>
                    <el-option value="动作" label="动作"></el-option>
                    <el-option value="喜剧" label="喜剧"></el-option>
                    <el-option value="科幻" label="科幻"></el-option>
                    <el-option value="爱情" label="爱情"></el-option>
                    <el-option value="恐怖" label="恐怖"></el-option>
                    <el-option value="动画" label="动画"></el-option>
                    <el-option value="悬疑" label="悬疑"></el-option>
                    <el-option value="战争" label="战争"></el-option>
                    <el-option value="其他" label="其他"></el-option>
                </el-select>
            </el-form-item>

            <el-form-item label="导演" prop="director">
                <el-input v-model="movieForm.director" placeholder="请输入导演"></el-input>
            </el-form-item>

            <el-form-item label="时长(分钟)" prop="duration">
                <el-input-number
                        v-model="movieForm.duration"
                        :min="60"
                        :max="300"
                        placeholder="请输入时长"
                        style="width: 100%">
                </el-input-number>
            </el-form-item>

            <el-form-item label="上映日期" prop="releaseDate">
                <el-date-picker
                        v-model="movieForm.releaseDate"
                        type="date"
                        placeholder="选择上映日期"
                        format="yyyy-MM-dd"
                        value-format="yyyy-MM-dd"
                        style="width: 100%">
                </el-date-picker>
            </el-form-item>

            <el-form-item label="主演" prop="actors">
                <el-input
                        v-model="movieForm.actors"
                        placeholder="多个主演用逗号分隔"
                        :autosize="{ minRows: 2, maxRows: 4 }"
                        type="textarea">
                </el-input>
            </el-form-item>

            <el-form-item label="海报" prop="posterUrl">
                <el-input
                        v-model="movieForm.posterUrl"
                        placeholder="请输入电影海报的图片链接"
                        :autosize="{ minRows: 2, maxRows: 4 }"
                        type="textarea">
                </el-input>
                <div style="font-size: 12px; color: #999; margin-top: 5px;">注意：目前仅支持本地图片</div>
            </el-form-item>

            <el-form-item label="电影简介" prop="description">
                <el-input
                        v-model="movieForm.description"
                        placeholder="请输入电影简介"
                        :autosize="{ minRows: 4, maxRows: 6 }"
                        type="textarea">
                </el-input>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
            <el-button @click="movieDialogVisible = false">取消</el-button>
            <el-button type="primary" @click="submitMovieForm" :loading="submitting">
                {{ dialogTitle === '添加新电影' ? '添加电影' : '保存修改' }}
            </el-button>
        </span>
    </el-dialog>
</div>

<script>
    new Vue({
        el: '#app',
        data: {
            activeMenu: '3',
            currentTime: '',
            movies: [],
            movieDialogVisible: false,
            dialogTitle: '添加新电影',
            submitting: false,
            movieForm: {
                id: '',
                title: '',
                type: '',
                director: '',
                duration: 120,
                releaseDate: '',
                actors: '',
                posterUrl: '',
                description: ''
            },
            formRules: {
                title: [
                    { required: true, message: '请输入电影名称', trigger: 'blur' },
                    { min: 1, max: 100, message: '长度在 1 到 100 个字符', trigger: 'blur' }
                ],
                type: [
                    { required: true, message: '请选择电影类型', trigger: 'change' }
                ],
                duration: [
                    { required: true, message: '请输入时长', trigger: 'blur' },
                    { type: 'number', min: 60, max: 300, message: '时长应在60-300分钟之间', trigger: 'blur' }
                ],
                director: [
                    { min: 0, max: 50, message: '长度不超过 50 个字符', trigger: 'blur' }
                ],
                actors: [
                    { min: 0, max: 200, message: '长度不超过 200 个字符', trigger: 'blur' }
                ],
                description: [
                    { min: 0, max: 1000, message: '长度不超过 1000 个字符', trigger: 'blur' }
                ]
            },
            contextPath: '${pageContext.request.contextPath}'
        },
        mounted() {
            this.updateTime();
            setInterval(this.updateTime, 1000);

            // 从JSP数据初始化Vue表格数据
            this.initMovies();

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
            initMovies() {
                const movies = [];

                // 使用JSP生成的数据
                <c:forEach var="movie" items="${movies}">
                movies.push({
                    id: ${movie.id},
                    title: '${movie.title}',
                    type: '${movie.type}',
                    director: '${movie.director}',
                    duration: ${movie.duration},
                    releaseDate: '<fmt:formatDate value="${movie.releaseDate}" pattern="yyyy-MM-dd" />',
                    posterUrl: '${pageContext.request.contextPath}${movie.posterUrl}',
                    actors: '${movie.actors}',
                    description: '${movie.description}'
                });
                </c:forEach>

                this.movies = movies;
            },
            getTypeClass(type) {
                switch(type) {
                    case '动作': return 'type-action';
                    case '喜剧': return 'type-comedy';
                    case '科幻': return 'type-scifi';
                    case '爱情': return 'type-romance';
                    case '恐怖': return 'type-horror';
                    case '动画': return 'type-animation';
                    default: return 'type-other';
                }
            },
            formatDate(dateStr) {
                if (!dateStr) return '';
                return dateStr.substring(0, 10); // 返回YYYY-MM-DD格式
            },
            showAddDialog() {
                this.dialogTitle = '添加新电影';
                this.movieDialogVisible = true;
            },
            resetMovieForm() {
                if (this.$refs.movieForm) {
                    this.$refs.movieForm.resetFields();
                }
                this.movieForm = {
                    id: '',
                    title: '',
                    type: '',
                    director: '',
                    duration: 120,
                    releaseDate: '',
                    actors: '',
                    posterUrl: '',
                    description: ''
                };
            },
            handleEdit(movie) {
                this.dialogTitle = '编辑电影';
                this.movieForm = {
                    id: movie.id,
                    title: movie.title,
                    type: movie.type,
                    director: movie.director || '',
                    duration: movie.duration,
                    releaseDate: movie.releaseDate || '',
                    actors: movie.actors || '',
                    posterUrl: movie.posterUrl.replace(this.contextPath, '') || '',
                    description: movie.description || ''
                };
                this.movieDialogVisible = true;
            },
            submitMovieForm() {
                this.$refs.movieForm.validate((valid) => {
                    if (valid) {
                        this.submitting = true;

                        // 创建表单提交
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = this.contextPath + '/admin/movie_save';
                        form.style.display = 'none';

                        // 添加表单字段（注意字段名与后端对应）
                        const fields = [
                            { name: 'id', value: this.movieForm.id },
                            { name: 'title', value: this.movieForm.title },
                            { name: 'type', value: this.movieForm.type },
                            { name: 'director', value: this.movieForm.director },
                            { name: 'duration', value: this.movieForm.duration },
                            { name: 'release_date', value: this.movieForm.releaseDate },
                            { name: 'actors', value: this.movieForm.actors },
                            { name: 'poster_url', value: this.movieForm.posterUrl },
                            { name: 'description', value: this.movieForm.description }
                        ];

                        fields.forEach(field => {
                            const input = document.createElement('input');
                            input.type = 'text';
                            input.name = field.name;
                            input.value = field.value || '';
                            form.appendChild(input);
                        });

                        document.body.appendChild(form);
                        form.submit();
                    } else {
                        return false;
                    }
                });
            },
            handleDelete(movie) {
                // 使用原生表单提交删除请求
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = this.contextPath + '/admin/movie_delete';
                form.style.display = 'none';

                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'id';
                input.value = movie.id;
                form.appendChild(input);

                document.body.appendChild(form);
                form.submit();
            }
        }
    });
</script>
</body>
</html>
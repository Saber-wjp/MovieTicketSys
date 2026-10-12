<%-- src/main/webapp/WEB-INF/views/admin/user_list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 江南影院</title>
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
        .user-count {
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
        .user-status-tag {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-active {
            background-color: #f0f9eb;
            color: #67c23a;
            border: 1px solid #c2e7b0;
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
                    <i class="el-icon-user-solid"></i> 用户管理
                </h2>
                <div class="header-actions">
                    <el-button type="primary" icon="el-icon-circle-plus-outline" @click="showAddDialog">
                        添加用户
                    </el-button>
                    <el-button type="default" icon="el-icon-s-home" @click="goToHome">
                        返回首页
                    </el-button>
                </div>
            </div>

            <!-- 用户表格 -->
            <div class="table-container">
                <el-table
                        :data="users"
                        style="width: 100%"
                        v-loading="loading"
                        border
                        stripe>
                    <el-table-column prop="id" label="ID" width="80" align="center"></el-table-column>
                    <el-table-column prop="username" label="用户名" width="180"></el-table-column>
                    <el-table-column prop="email" label="邮箱"></el-table-column>
                    <el-table-column prop="phone" label="手机号" width="140"></el-table-column>
                    <el-table-column prop="createTime" label="注册时间" width="180">
                        <template slot-scope="scope">
                            {{ formatDate(scope.row.createTime) }}
                        </template>
                    </el-table-column>
                    <el-table-column label="状态" width="100" align="center">
                        <template slot-scope="scope">
                            <span class="user-status-tag status-active">正常</span>
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
                                        title="确定要删除这个用户吗？"
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
                <div v-if="!users || users.length === 0" class="empty-message">
                    <i class="el-icon-user" style="font-size: 48px; color: #dcdfe6; margin-bottom: 16px;"></i>
                    <p>暂无用户数据</p>
                </div>

                <!-- 用户统计 -->
                <div class="user-count" v-if="users && users.length > 0">
                    共 {{ users.length }} 个用户
                </div>
            </div>
        </main>
    </div>

    <!-- 页脚 -->
    <footer class="footer">
        <p>© 2025 江南影院售票平台 | 后台管理系统 v2.0</p>
    </footer>

    <!-- 添加用户对话框 -->
    <el-dialog
            title="添加新用户"
            :visible.sync="addDialogVisible"
            width="500px"
            @close="resetAddForm">
        <el-form ref="addForm" :model="addForm" :rules="formRules" label-width="80px">
            <el-form-item label="用户名" prop="username">
                <el-input v-model="addForm.username" placeholder="请输入用户名"></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password">
                <el-input v-model="addForm.password" type="password" placeholder="请输入密码" show-password></el-input>
            </el-form-item>
            <el-form-item label="邮箱" prop="email">
                <el-input v-model="addForm.email" type="email" placeholder="请输入邮箱"></el-input>
            </el-form-item>
            <el-form-item label="手机号" prop="phone">
                <el-input v-model="addForm.phone" placeholder="请输入手机号"></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
                <el-button @click="addDialogVisible = false">取消</el-button>
                <el-button type="primary" @click="submitAddForm" :loading="addLoading">添加用户</el-button>
            </span>
    </el-dialog>

    <!-- 编辑用户对话框 -->
    <el-dialog
            title="编辑用户"
            :visible.sync="editDialogVisible"
            width="500px"
            @close="resetEditForm">
        <el-form ref="editForm" :model="editForm" :rules="formRules" label-width="80px">
            <el-input type="hidden" v-model="editForm.id"></el-input>
            <el-form-item label="用户名" prop="username">
                <el-input v-model="editForm.username" placeholder="请输入用户名"></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password">
                <el-input v-model="editForm.password" type="password" placeholder="留空则不修改密码" show-password></el-input>
            </el-form-item>
            <el-form-item label="邮箱" prop="email">
                <el-input v-model="editForm.email" type="email" placeholder="请输入邮箱"></el-input>
            </el-form-item>
            <el-form-item label="手机号" prop="phone">
                <el-input v-model="editForm.phone" placeholder="请输入手机号"></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
                <el-button @click="editDialogVisible = false">取消</el-button>
                <el-button type="primary" @click="submitEditForm" :loading="editLoading">更新用户</el-button>
            </span>
    </el-dialog>
</div>

<script>
    new Vue({
        el: '#app',
        data: {
            activeMenu: '2',
            isCollapse: false,
            currentTime: '',
            loading: false,
            addDialogVisible: false,
            editDialogVisible: false,
            addLoading: false,
            editLoading: false,
            addForm: {
                username: '',
                password: '',
                email: '',
                phone: ''
            },
            editForm: {
                id: '',
                username: '',
                password: '',
                email: '',
                phone: ''
            },
            formRules: {
                username: [
                    { required: true, message: '请输入用户名', trigger: 'blur' },
                    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
                ],
                password: [
                    { required: true, message: '请输入密码', trigger: 'blur' },
                    { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
                ],
                email: [
                    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
                ],
                phone: [
                    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
                ]
            },
            users: [],
            contextPath: '${pageContext.request.contextPath}'
        },
        mounted() {
            this.updateTime();
            setInterval(this.updateTime, 1000);

            // 加载用户数据
            this.loadUsers();

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
            loadUsers() {
                // 用户数据从服务器端传递，不需要额外加载
                // 将JSP中的用户数据转换为Vue数据
                this.users = [
                    <c:forEach var="user" items="${users}" varStatus="status">
                    {
                        id: ${user.id},
                        username: '${user.username}',
                        email: '${user.email}',
                        phone: '${user.phone}',
                        createTime: '${user.createTime}'
                    }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ];
            },
            formatDate(dateStr) {
                if (!dateStr) return '';
                const date = new Date(dateStr);
                return date.toLocaleString('zh-CN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false
                }).replace(/\//g, '-');
            },
            showAddDialog() {
                this.addDialogVisible = true;
            },
            resetAddForm() {
                this.$refs.addForm.resetFields();
            },
            submitAddForm() {
                this.$refs.addForm.validate((valid) => {
                    if (valid) {
                        this.addLoading = true;

                        // 创建表单提交
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = this.contextPath + '/admin/user_add';
                        form.style.display = 'none';

                        // 添加表单字段
                        const fields = ['username', 'password', 'email', 'phone'];
                        fields.forEach(field => {
                            const input = document.createElement('input');
                            input.type = 'text';
                            input.name = field;
                            input.value = this.addForm[field];
                            form.appendChild(input);
                        });

                        document.body.appendChild(form);
                        form.submit();
                    } else {
                        return false;
                    }
                });
            },
            handleEdit(user) {
                this.editForm = {
                    id: user.id,
                    username: user.username,
                    password: '',
                    email: user.email || '',
                    phone: user.phone || ''
                };
                this.editDialogVisible = true;
            },
            resetEditForm() {
                this.$refs.editForm.resetFields();
            },
            submitEditForm() {
                this.$refs.editForm.validate((valid) => {
                    if (valid) {
                        this.editLoading = true;

                        // 创建表单提交
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = this.contextPath + '/admin/user_update';
                        form.style.display = 'none';

                        // 添加表单字段
                        const fields = ['id', 'username', 'password', 'email', 'phone'];
                        fields.forEach(field => {
                            const input = document.createElement('input');
                            input.type = 'text';
                            input.name = field;
                            input.value = this.editForm[field] || '';
                            form.appendChild(input);
                        });

                        document.body.appendChild(form);
                        form.submit();
                    } else {
                        return false;
                    }
                });
            },
            handleDelete(user) {
                // 使用原生表单提交删除请求
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = this.contextPath + '/admin/user_delete';
                form.style.display = 'none';

                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'id';
                input.value = user.id;
                form.appendChild(input);

                document.body.appendChild(form);
                form.submit();
            }
        }
    });
</script>
</body>
</html>
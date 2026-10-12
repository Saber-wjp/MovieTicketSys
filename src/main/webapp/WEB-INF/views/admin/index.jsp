<%-- src/main/webapp/WEB-INF/views/admin/index.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>后台管理 - 江南影院</title>
    <!-- 引入 Element UI 样式 -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <!-- 引入 Vue 和 Element UI JS -->
    <script src="https://unpkg.com/vue@2.6.14/dist/vue.js"></script>
    <script src="https://unpkg.com/element-ui/lib/index.js"></script>
    <!-- 引入图标库 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f0f2f5;
            height: 100vh;
            overflow: hidden;
        }
        .admin-container {
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .header-container {
            background: linear-gradient(135deg, #303133 0%, #606266 100%);
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
        }
        .logo-icon {
            margin-right: 10px;
            font-size: 26px;
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
        .welcome-card {
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
        }
        .welcome-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .welcome-icon {
            font-size: 24px;
            color: #409EFF;
            margin-right: 10px;
        }
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .stat-card {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.15);
        }
        .stat-header {
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }
        .stat-content {
            padding: 20px;
            border-top: 1px solid #eee;
        }
        .stat-number {
            font-size: 32px;
            font-weight: 700;
            color: #303133;
            margin-bottom: 5px;
        }
        .stat-text {
            color: #909399;
            font-size: 14px;
        }
        .quick-actions-card {
            border-radius: 8px;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
        }
        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        .action-button {
            min-width: 150px;
        }
        .footer {
            text-align: center;
            padding: 15px 0;
            color: #909399;
            font-size: 14px;
            border-top: 1px solid #e4e7ed;
            background-color: #fff;
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
        .welcome-text {
            font-size: 16px;
            color: #606266;
            line-height: 1.8;
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
            <!-- 欢迎卡片 -->
            <el-card class="welcome-card">
                <div class="welcome-header">
                    <i class="el-icon-s-promotion welcome-icon"></i>
                    <h2>欢迎回来，管理员 ${admin}！</h2>
                </div>
                <p class="welcome-text">
                    您可以通过左侧菜单管理系统中的用户、电影和场次信息。系统运行状态良好，祝您工作愉快！
                </p>
            </el-card>

            <!-- 统计数据卡片 -->
            <div class="stats-container">
                <el-card class="stat-card">
                    <div class="stat-header">
                        <div>
                            <h3>总用户数</h3>
                            <p>注册用户总数</p>
                        </div>
                        <div class="stat-icon" style="background: linear-gradient(135deg, #36D1DC 0%, #5B86E5 100%);">
                            <i class="el-icon-user"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${totalUsers}</div>
                        <div class="stat-text">较上月增长 12%</div>
                    </div>
                </el-card>

                <el-card class="stat-card">
                    <div class="stat-header">
                        <div>
                            <h3>在映电影</h3>
                            <p>当前可购票电影</p>
                        </div>
                        <div class="stat-icon" style="background: linear-gradient(135deg, #FF9A9E 0%, #FAD0C4 100%);">
                            <i class="el-icon-video-camera"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${totalMovies}</div>
                        <div class="stat-text">本周新增 3 部</div>
                    </div>
                </el-card>

                <el-card class="stat-card">
                    <div class="stat-header">
                        <div>
                            <h3>今日场次</h3>
                            <p>今日排片场次数</p>
                        </div>
                        <div class="stat-icon" style="background: linear-gradient(135deg, #A18CD1 0%, #FBC2EB 100%);">
                            <i class="el-icon-date"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${todaySchedules}</div>
                        <div class="stat-text">已售出 85% 的座位</div>
                    </div>
                </el-card>
            </div>

            <!-- 快捷操作卡片 -->
            <el-card class="quick-actions-card">
                <template #header>
                    <div style="display: flex; align-items: center;">
                        <i class="el-icon-s-operation" style="margin-right: 10px; color: #409EFF;"></i>
                        <span>快捷操作</span>
                    </div>
                </template>
                <div class="action-buttons">
                    <el-button
                            type="primary"
                            icon="el-icon-circle-plus-outline"
                            class="action-button"
                            @click="goToPage('movies')">
                        添加新电影
                    </el-button>
                    <el-button
                            type="success"
                            icon="el-icon-circle-plus"
                            class="action-button"
                            @click="goToPage('schedules')">
                        安排新场次
                    </el-button>
                    <el-button
                            type="info"
                            icon="el-icon-user-solid"
                            class="action-button"
                            @click="goToPage('users')">
                        查看用户列表
                    </el-button>
                    <el-button
                            type="warning"
                            icon="el-icon-monitor"
                            class="action-button"
                            @click="goToFrontend">
                        访问前台网站
                    </el-button>
                </div>
            </el-card>
        </main>
    </div>

    <!-- 页脚 -->
    <footer class="footer">
        <p>© 2025 江南影院售票平台 | 后台管理系统 v2.0</p>
    </footer>
</div>

<script>
    new Vue({
        el: '#app',
        data: {
            activeMenu: '1',
            isCollapse: false,
            currentTime: '',
            contextPath: '${pageContext.request.contextPath}'
        },
        mounted() {
            this.updateTime();
            setInterval(this.updateTime, 1000);

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
            goToPage(page) {
                switch(page) {
                    case 'movies':
                        window.location.href = this.contextPath + '/admin/movies';
                        break;
                    case 'schedules':
                        window.location.href = this.contextPath + '/admin/schedules';
                        break;
                    case 'users':
                        window.location.href = this.contextPath + '/admin/users';
                        break;
                    default:
                        window.location.href = this.contextPath + '/admin/';
                }
            },
            goToFrontend() {
                window.location.href = this.contextPath + '/';
            }
        }
    });
</script>
</body>
</html>
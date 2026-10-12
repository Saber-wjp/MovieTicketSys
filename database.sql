-- 设置客户端字符集
SET NAMES utf8mb4;

-- 创建数据库
DROP DATABASE IF EXISTS MovieTicketSys;
CREATE DATABASE MovieTicketSys DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE MovieTicketSys;

-- 用户表
CREATE TABLE users (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(32) NOT NULL,
                       email VARCHAR(100),
                       phone VARCHAR(20),
                       create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 电影表
CREATE TABLE movies (
                        id INT PRIMARY KEY AUTO_INCREMENT,
                        title VARCHAR(100) NOT NULL,
                        director VARCHAR(100),
                        actors VARCHAR(255),
                        type VARCHAR(50),
                        duration INT,
                        description TEXT,
                        release_date DATE,
                        poster_url VARCHAR(255),
                        status INT DEFAULT 1,
                        create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        INDEX idx_status (status),
                        INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 放映厅表 (注意：rows是保留字，用反引号括起来)
CREATE TABLE halls (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       name VARCHAR(50) NOT NULL UNIQUE,
                       total_seats INT DEFAULT 50,
                       `rows` INT DEFAULT 5,
                       cols INT DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 场次表
CREATE TABLE schedules (
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           movie_id INT NOT NULL,
                           hall_id INT NOT NULL,
                           show_time DATETIME NOT NULL,
                           price DECIMAL(10, 2) NOT NULL,
                           status INT DEFAULT 1,
                           create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
                           FOREIGN KEY (hall_id) REFERENCES halls(id) ON DELETE CASCADE,
                           INDEX idx_movie (movie_id),
                           INDEX idx_hall (hall_id),
                           INDEX idx_show_time (show_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 座位表
CREATE TABLE seats (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       schedule_id INT NOT NULL,
                       seat_number VARCHAR(10) NOT NULL,
                       row_num INT NOT NULL,
                       col_num INT NOT NULL,
                       status INT DEFAULT 0,
                       FOREIGN KEY (schedule_id) REFERENCES schedules(id) ON DELETE CASCADE,
                       INDEX idx_schedule (schedule_id),
                       UNIQUE KEY uk_schedule_seat (schedule_id, seat_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 订单表
CREATE TABLE orders (
                        id INT PRIMARY KEY AUTO_INCREMENT,
                        order_number VARCHAR(50) NOT NULL UNIQUE,
                        user_id INT NOT NULL,
                        schedule_id INT NOT NULL,
                        seat_numbers VARCHAR(255) NOT NULL,
                        total_price DECIMAL(10, 2) NOT NULL,
                        create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        status INT DEFAULT 0,
                        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                        FOREIGN KEY (schedule_id) REFERENCES schedules(id) ON DELETE CASCADE,
                        INDEX idx_user (user_id),
                        INDEX idx_create_time (create_time),
                        INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 插入测试数据 ==========

-- 插入用户数据
INSERT INTO users (username, password, email, phone) VALUES
                                                         ('user1', '123456', 'user1@cinema.com', '13800138001'),
                                                         ('user2', '123456', 'user2@cinema.com', '13800138002'),
                                                         ('user3', '123456', 'user3@cinema.com', '13800138003'),
                                                         ('user4', '123456', 'user4@cinema.com', '13800138004'),
                                                         ('user5', '123456', 'user5@cinema.com', '13800138005'),
                                                         ('user6', '123456', 'user6@cinema.com', '13800138006'),
                                                         ('user7', '123456', 'user7@cinema.com', '13800138007'),
                                                         ('user8', '123456', 'user8@cinema.com', '13800138008'),
                                                         ('user9', '123456', 'user9@cinema.com', '13800138009'),
                                                         ('user10', '123456', 'user10@cinema.com', '13800138010');

-- 插入电影数据
INSERT INTO movies (title, director, actors, type, duration, description, release_date, poster_url, status) VALUES
                                                                                                                ('笑傲江湖', '王晶', '周星驰,张学友', '喜剧', 120, '一部轻松幽默的喜剧电影', '2025-12-01', '/images/笑傲江湖.jpg', 1),
                                                                                                                ('开心麻花', '李昂', '沈腾,马丽', '喜剧', 110, '年度爆笑喜剧', '2025-12-01', '/images/开心麻花.jpg', 1),
                                                                                                                ('霸王别姬', '陈凯歌', '程蝶衣,段小楼', '动作', 180, '经典动作大片', '2025-12-05', '/images/霸王别姬.jpg', 1),
                                                                                                                ('速度与激情', '林诣彬', '范·迪塞尔,道恩·强森', '动作', 145, '超级赛车动作片', '2025-12-05', '/images/速度与激情.jpg', 1),
                                                                                                                ('流浪地球', '郭帆', '吴京,青山', '科幻', 125, '人类逃离太阳系', '2025-12-10', '/images/流浪地球.jpg', 1),
                                                                                                                ('星际穿越', '诺兰', '马修·麦康纳,安妮·海瑟薇', '科幻', 169, '跨越时空的冒险', '2025-12-10', '/images/星际穿越.jpg', 1),
                                                                                                                ('怪物猎人', '保罗·沃特·安德森', '蜜拉·乔沃维奇', '恐怖', 100, '恐怖冒险电影', '2025-12-15', '/images/怪物猎人.jpg', 1),
                                                                                                                ('招魂', '温子仁', '维拉·法梅加,帕特里克·威尔森', '恐怖', 112, '超自然恐怖片', '2025-12-15', '/images/招魂.jpg', 1),
                                                                                                                ('泰坦尼克号', '詹姆斯·卡梅隆', '莱昂纳多,凯特', '爱情', 194, '永恒的爱情传奇', '2025-12-20', '/images/泰坦尼克号.jpg', 1),
                                                                                                                ('阿凡达', '詹姆斯·卡梅隆', '萨姆·沃辛顿,佐伊', '科幻', 162, '潘多拉星球的冒险', '2025-12-20', '/images/阿凡达.jpg', 1);

-- 插入影厅数据 (注意列名要用反引号括起来)
INSERT INTO halls (name, total_seats, `rows`, cols) VALUES
                                                        ('1号影厅', 50, 5, 10),
                                                        ('2号影厅', 50, 5, 10);

-- 插入场次数据
INSERT INTO schedules (movie_id, hall_id, show_time, price, status) VALUES
                                                                        (1, 1, '2025-12-20 08:00:00', 35.00, 1),
                                                                        (1, 1, '2025-12-20 10:30:00', 35.00, 1),
                                                                        (1, 1, '2025-12-20 14:00:00', 40.00, 1),
                                                                        (1, 2, '2025-12-20 16:30:00', 40.00, 1),
                                                                        (1, 2, '2025-12-20 19:00:00', 45.00, 1),

                                                                        (2, 2, '2025-12-20 09:00:00', 35.00, 1),
                                                                        (2, 1, '2025-12-20 11:30:00', 35.00, 1),
                                                                        (2, 2, '2025-12-20 15:00:00', 40.00, 1),
                                                                        (2, 1, '2025-12-20 17:30:00', 40.00, 1),

                                                                        (3, 1, '2025-12-21 08:00:00', 40.00, 1),
                                                                        (3, 2, '2025-12-21 11:00:00', 40.00, 1),
                                                                        (3, 1, '2025-12-21 14:00:00', 45.00, 1),
                                                                        (3, 2, '2025-12-21 17:00:00', 45.00, 1),

                                                                        (4, 2, '2025-12-21 09:30:00', 40.00, 1),
                                                                        (4, 1, '2025-12-21 12:00:00', 40.00, 1),
                                                                        (4, 2, '2025-12-21 15:00:00', 45.00, 1),
                                                                        (4, 1, '2025-12-21 18:00:00', 45.00, 1),

                                                                        (5, 1, '2025-12-22 08:00:00', 40.00, 1),
                                                                        (5, 2, '2025-12-22 10:30:00', 40.00, 1),
                                                                        (5, 1, '2025-12-22 13:00:00', 45.00, 1),
                                                                        (5, 2, '2025-12-22 16:00:00', 45.00, 1),

                                                                        (6, 2, '2025-12-22 09:00:00', 40.00, 1),
                                                                        (6, 1, '2025-12-22 11:30:00', 40.00, 1),
                                                                        (6, 2, '2025-12-22 14:30:00', 45.00, 1),
                                                                        (6, 1, '2025-12-22 17:30:00', 45.00, 1),

                                                                        (7, 1, '2025-12-23 08:00:00', 35.00, 1),
                                                                        (7, 2, '2025-12-23 10:00:00', 35.00, 1),
                                                                        (7, 1, '2025-12-23 14:00:00', 40.00, 1),
                                                                        (7, 2, '2025-12-23 19:00:00', 45.00, 1),

                                                                        (8, 2, '2025-12-23 09:00:00', 35.00, 1),
                                                                        (8, 1, '2025-12-23 11:00:00', 35.00, 1),
                                                                        (8, 2, '2025-12-23 15:00:00', 40.00, 1),
                                                                        (8, 1, '2025-12-23 17:00:00', 40.00, 1),

                                                                        (9, 1, '2025-12-24 08:00:00', 45.00, 1),
                                                                        (9, 2, '2025-12-24 11:00:00', 45.00, 1),
                                                                        (9, 1, '2025-12-24 14:30:00', 50.00, 1),
                                                                        (9, 2, '2025-12-24 18:00:00', 50.00, 1),

                                                                        (10, 2, '2025-12-24 09:30:00', 45.00, 1),
                                                                        (10, 1, '2025-12-24 12:00:00', 45.00, 1),
                                                                        (10, 2, '2025-12-24 15:30:00', 50.00, 1),
                                                                        (10, 1, '2025-12-24 19:00:00', 50.00, 1);

-- ========== 为所有场次创建座位 ==========
DELIMITER //
CREATE PROCEDURE create_seats()
BEGIN
    DECLARE schedule_id INT;
    DECLARE row_num INT;
    DECLARE col_num INT;
    DECLARE row_char VARCHAR(1);
    DECLARE schedule_cursor CURSOR FOR SELECT id FROM schedules;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET schedule_id = NULL;

    OPEN schedule_cursor;
    seats_loop: LOOP
        FETCH schedule_cursor INTO schedule_id;
        IF schedule_id IS NULL THEN
            LEAVE seats_loop;
        END IF;

        -- 为每个场次创建50个座位 (5行 x 10列)
        SET row_num = 1;
        WHILE row_num <= 5 DO
                SET col_num = 1;
                SET row_char = CHAR(64 + row_num);  -- A, B, C, D, E
                WHILE col_num <= 10 DO
                        INSERT INTO seats (schedule_id, seat_number, row_num, col_num, status)
                        VALUES (schedule_id, CONCAT(row_char, col_num), row_num, col_num, 0);
                        SET col_num = col_num + 1;
                    END WHILE;
                SET row_num = row_num + 1;
            END WHILE;
    END LOOP;
    CLOSE schedule_cursor;
END //
DELIMITER ;

CALL create_seats();
DROP PROCEDURE create_seats;

-- 插入示例订单数据
INSERT INTO orders (order_number, user_id, schedule_id, seat_numbers, total_price, status) VALUES
                                                                                               ('ORD20251220001', 1, 1, 'A1,A2,A3', 105.00, 1),
                                                                                               ('ORD20251220002', 2, 1, 'B5,B6', 70.00, 1),
                                                                                               ('ORD20251220003', 3, 2, 'C10,D1,D2,D3', 160.00, 1),
                                                                                               ('ORD20251221001', 4, 5, 'A5,A6,A7', 120.00, 1),
                                                                                               ('ORD20251221002', 5, 6, 'B2,B3', 80.00, 1);

-- 查询数据确认
SELECT '用户数量:', COUNT(*) FROM users;
SELECT '电影数量:', COUNT(*) FROM movies;
SELECT '影厅数量:', COUNT(*) FROM halls;
SELECT '场次数量:', COUNT(*) FROM schedules;
SELECT '座位总数:', COUNT(*) FROM seats;
SELECT '订单数量:', COUNT(*) FROM orders;

-- 管理员表（简单版本）
CREATE TABLE admin (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(50) NOT NULL,
                       create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入默认管理员账号
INSERT INTO admin (username, password) VALUES ('admin', '123456');

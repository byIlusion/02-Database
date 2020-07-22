DROP DATABASE IF EXISTS gb_vk;
CREATE DATABASE gb_vk CHARACTER SET utf8 COLLATE utf8_general_ci;
USE gb_vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	email VARCHAR(120) UNIQUE,
    phone VARCHAR(15), 
    pass VARCHAR(200)
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	id SERIAL PRIMARY key,
	user_id BIGINT UNSIGNED NOT NULL,
    gender CHAR(1),
    name VARCHAR(100),
    surname VARCHAR(100),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    -- bio TEXT,
    FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE NO ACTION
);


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    is_read BOOL,
    created_at DATETIME default NOW(),
    INDEX(from_user_id),
  	INDEX(to_user_id),
  	FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE NO ACTION,
  	FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE NO ACTION
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	status ENUM('requested', 'approved', 'unfriended', 'declined') default 'requested',
	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME,
	PRIMARY KEY(initiator_user_id, target_user_id),
	INDEX(initiator_user_id),
	INDEX(target_user_id),
	FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON DELETE NO ACTION,
  	FOREIGN KEY (target_user_id) REFERENCES users(id) ON DELETE NO ACTION
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	INDEX(name)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	is_admin BOOL,
	PRIMARY KEY (user_id, community_id), 
  	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION,
  	FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	body text,
	attachments JSON,
	metadata JSON,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION	
);

DROP TABLE IF EXISTS comments;
CREATE TABLE comments(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	post_id BIGINT UNSIGNED NOT NULL,
	body text,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION,
	FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE NO ACTION
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos(
	id SERIAL PRIMARY KEY,
	file VARCHAR(255),
	user_id BIGINT UNSIGNED NOT NULL,
	description text,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION
);

DROP TABLE IF EXISTS repost;
CREATE TABLE repost(
	id SERIAL PRIMARY KEY,
	post_id BIGINT UNSIGNED NOT NULL,
	reposted_to BIGINT UNSIGNED NOT NULL,
	reposted_from BIGINT UNSIGNED NOT NULL,
	reposted_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (reposted_to) REFERENCES users(id) ON DELETE NO ACTION,
	FOREIGN KEY (reposted_from) REFERENCES users(id) ON DELETE NO ACTION,
	FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- РўР°Р±Р»РёС†Р° Р»Р°Р№РєРѕРІ (РІСЃРµС…, РєР°Рє РІР°СЂРёР°РЅС‚)
/*DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	user_id BIGINT UNSIGNED NOT NULL,
    source_id BIGINT UNSIGNED NOT NULL,
    source_type ENUM('user', 'photo', 'post'),
	created_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (user_id, source_id, source_type),
    INDEX(source_id, source_type),
    INDEX(user_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);*/

-- РўР°Р±Р»РёС†С‹ Р»Р°Р№РєРѕРІ (РїРѕ РѕС‚РґРµР»СЊРЅРѕСЃС‚Рё)
-- Р›Р°Р№РєРё С„РѕС‚РѕРє
DROP TABLE IF EXISTS likes_photos;
CREATE TABLE likes_photos(
	user_id BIGINT UNSIGNED NOT NULL,
    photo_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (user_id, photo_id),
    INDEX(user_id),
    INDEX(photo_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION,
    FOREIGN KEY (photo_id) REFERENCES photos(id)
);

-- Р›Р°Р№РєРё РїРѕСЃС‚РѕРІ
DROP TABLE IF EXISTS likes_posts;
CREATE TABLE likes_posts(
	user_id BIGINT UNSIGNED NOT NULL,
    post_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (user_id, post_id),
    INDEX(user_id),
    INDEX(post_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION,
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- Р›Р°Р№РєРё СЋР·РµСЂРѕРІ
DROP TABLE IF EXISTS likes_users;
CREATE TABLE likes_users(
	user_id BIGINT UNSIGNED NOT NULL,
    liked_user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (user_id, liked_user_id),
    INDEX(user_id),
    INDEX(liked_user_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION,
    FOREIGN KEY (liked_user_id) REFERENCES users(id) ON DELETE NO ACTION
);

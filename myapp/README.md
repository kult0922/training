# README

## DBスキーマ
### User
```sql
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `encrypted_password` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4
```

### Task
```sql
CREATE TABLE `tasks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `expire_date` datetime DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `priority` tinyint(4) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tasks_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_4d2a9e4d7e` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4
```

### Task Label
```sql
CREATE TABLE `task_labels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `label_id` bigint(20) NOT NULL,
  `task_id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_task_label` (`task_id`,`label_id`),
  KEY `index_task_labels_on_label_id` (`label_id`),
  KEY `index_task_labels_on_task_id` (`task_id`),
  CONSTRAINT `fk_rails_7dc7cd6c47` FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`),
  CONSTRAINT `fk_rails_fcbbc0fa3c` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
```

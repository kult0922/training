# モデル図

## users

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  name  | VARCHAR |
|  email  | VARCHAR |
|  password  | VARCHAR |
|  created_at  | DATETIME |
|  updated_at  | DATETIME |

## tasks

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  user_id  | INT |
|  status  | TINYINT |
|  title  | VARCHAR |
|  description  | VARCHAR |
|  priority  | INT |
|  due_date  | DATE |
|  created_at  | DATETIME |
|  updated_at  | DATETIME |

## labels

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  name  | VARCHAR |
|  created_at  | DATETIME |
|  updated_at  | DATETIME |

## task_labels

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  task_id  | INT |
|  label_id  | INT |
|  created_at  | DATETIME |
|  updated_at  | DATETIME |


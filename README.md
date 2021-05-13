# モデル図

## user

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  name  | VARCHAR |
|  email  | VARCHAR |
|  password  | VARCHAR |

## task

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  user_id  | INT |
|  status  | TINYINT |
|  title  | VARCHAR |
|  description  | VARCHAR |
|  priority  | INT |

## label

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  name  | VARCHAR |

## task_label

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  task_id  | INT |
|  label_id  | INT |


# Docker Compose コマンド早見表

## 🚀 基本コマンド

```bash
# 全サービス起動（バックグラウンド）
docker-compose up -d

# 全サービス起動（ログ表示）
docker-compose up

# 全サービス停止
docker-compose down

# 全サービス停止 + ボリューム削除（DB初期化）
docker-compose down -v
```

## 📊 状態確認

```bash
# サービス一覧
docker-compose ps

# ログ確認（全サービス）
docker-compose logs

# ログ確認（特定サービス）
docker-compose logs frontend
docker-compose logs backend
docker-compose logs db

# リアルタイムログ
docker-compose logs -f
```

## 🔄 再起動・リビルド

```bash
# 特定サービス再起動
docker-compose restart frontend
docker-compose restart backend

# コード変更後のリビルド
docker-compose up -d --build

# キャッシュなしで完全リビルド
docker-compose build --no-cache
docker-compose up -d
```

## 🐚 コンテナ内でコマンド実行

```bash
# バックエンドコンテナに入る
docker-compose exec backend sh

# フロントエンドコンテナに入る
docker-compose exec frontend sh

# データベースに接続
docker-compose exec db psql -U ecuser -d mini_ec_db

# バックエンドでnpmコマンド実行
docker-compose exec backend npm install パッケージ名
```

## 🗄️ データベース操作

```bash
# PostgreSQLに接続
docker-compose exec db psql -U ecuser -d mini_ec_db

# SQL実行後、終了
\q

# テーブル一覧
\dt

# テーブル構造確認
\d products

# データ確認
SELECT * FROM products;
```

## 🧹 クリーンアップ

```bash
# プロジェクトの全コンテナ・ネットワーク削除
docker-compose down

# + ボリューム（データベース）も削除
docker-compose down -v

# + イメージも削除
docker-compose down -v --rmi all

# Docker全体のクリーンアップ
docker system prune -a
```

## 🚨 トラブル時

```bash
# 完全リセット（最終手段）
docker-compose down -v
docker system prune -a
docker-compose up -d --build

# 特定コンテナの再作成
docker-compose up -d --force-recreate backend

# ボリューム一覧確認
docker volume ls

# 特定ボリュームの削除
docker volume rm mini-ec-site_postgres_data
```

## 📦 パッケージ管理

```bash
# バックエンドにパッケージ追加
docker-compose exec backend npm install パッケージ名
docker-compose restart backend

# フロントエンドにパッケージ追加
docker-compose exec frontend npm install パッケージ名
docker-compose restart frontend

# package.json更新後の再インストール
docker-compose up -d --build
```

## 💻 開発ワークフロー

```bash
# 1. 作業開始
cd C:\dev\mini-ec-site
docker-compose up -d
code .

# 2. コード編集
# （VSCodeでファイル編集）

# 3. 動作確認
# http://localhost:3000 （フロントエンド）
# http://localhost:4000/api/health （バックエンド）

# 4. ログ確認（必要に応じて）
docker-compose logs -f

# 5. 作業終了
docker-compose down
# または起動したままでもOK
```

## 🔍 デバッグ

```bash
# エラー調査
docker-compose logs backend | findstr "error"
docker-compose logs frontend | findstr "Error"

# コンテナの詳細情報
docker inspect mini-ec-backend

# リソース使用状況
docker stats

# ネットワーク確認
docker network ls
docker network inspect mini-ec-site_mini-ec-network
```

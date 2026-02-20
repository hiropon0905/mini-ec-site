# Docker Compose環境構築ガイド - ミニECサイト

## 📋 概要

このプロジェトでは、Docker Composeを使って以下の環境を完全にコンテナ化します：

- **フロントエンド**: Next.js 14 + TypeScript + Tailwind CSS
- **バックエンド**: Express + TypeScript
- **データベース**: PostgreSQL 15

**メリット**:
- ローカル環境にNode.jsをインストール不要
- プロジェクトごとに完全に独立した環境
- 1コマンドで全環境が起動
- 削除も簡単で環境を汚さない

---

## 🚀 クイックスタート（5分で起動）

### 前提条件

- Docker Desktopがインストール済み ✅
- Git がインストール済み ✅

### ステップ1: プロジェクトのダウンロード

```bash
# プロジェクト用ディレクトリを作成
mkdir C:\dev
cd C:\dev

# このフォルダ構成を作成（後述の「プロジェクト構成」参照）
```

### ステップ2: フロントエンドプロジェクトの作成（Docker経由）

**重要**: ローカル環境にNode.jsをインストールせず、Docker経由でNext.jsプロジェクトを作成します。

```bash
cd C:\dev\mini-ec-site

# frontendフォルダを作成
mkdir frontend
cd frontend

# DockerでNext.jsプロジェクトを作成（カレントディレクトリに展開）
docker run --rm -it -v "%cd%":/app -w /app node:20-alpine npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --no-import-alias

# 完了まで2-3分かかります
# "Success! Created ..." と表示されれば成功
```

**PowerShellを使う場合**:
```powershell
docker run --rm -it -v "${PWD}:/app" -w /app node:20-alpine npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --no-import-alias
```

**このコマンドの説明**:
- `docker run --rm`: 一時的なコンテナを実行（終了後自動削除）
- `-v "%cd%":/app`: 現在のフォルダをコンテナ内の /app にマウント
- `node:20-alpine`: Node.js 20のDockerイメージを使用
- `npx create-next-app@latest .`: カレントディレクトリにNext.jsを作成
- 各オプション（--typescript等）でYes/Noの質問をスキップ

### ステップ3: frontendフォルダにDockerfileを配置

先ほど作成した `frontend/Dockerfile` を配置（既に提供済み）

### ステップ4: 環境変数ファイルの作成

```bash
# backendフォルダ内で .env ファイルを作成
cd backend
copy .env.example .env
```

### ステップ5: Docker Composeで起動

```bash
# プロジェクトルートに戻る
cd C:\dev\mini-ec-site

# Docker Composeで全サービスを起動
docker-compose up -d

# 初回は5-10分かかります（イメージのビルド）
# 2回目以降は30秒程度で起動します
```

### ステップ6: 動作確認

起動後、以下のURLにアクセス：

- **フロントエンド**: http://localhost:3000
- **バックエンド ヘルスチェック**: http://localhost:4000/api/health
- **データベース接続テスト**: http://localhost:4000/api/db-test

---

## 📁 プロジェクト構成

プロジェクトの完全なフォルダ構成：

```
C:\dev\mini-ec-site\
├── docker-compose.yml          # Docker Compose設定ファイル
├── .gitignore                  # Git除外設定
├── README.md                   # このファイル
│
├── backend/                    # バックエンド
│   ├── Dockerfile              # バックエンド用Dockerイメージ
│   ├── package.json            # 依存関係定義
│   ├── tsconfig.json           # TypeScript設定
│   ├── .env.example            # 環境変数のサンプル
│   ├── .env                    # 環境変数（自分で作成）
│   └── src/
│       ├── index.ts            # エントリーポイント
│       ├── db.ts               # データベース接続
│       ├── routes/             # ルート定義（今後追加）
│       └── controllers/        # コントローラー（今後追加）
│
├── frontend/                   # フロントエンド
│   ├── Dockerfile              # フロントエンド用Dockerイメージ
│   ├── package.json            # Next.jsが自動生成
│   ├── next.config.js          # Next.js設定
│   ├── tsconfig.json           # TypeScript設定
│   ├── tailwind.config.ts      # Tailwind CSS設定
│   └── src/
│       └── app/                # App Router
│           ├── layout.tsx
│           ├── page.tsx
│           └── ...
│
└── db/                         # データベース
    └── init.sql                # 初期データ投入SQL
```

---

## 🔧 よく使うコマンド

### 基本操作

```bash
# 全サービスを起動（バックグラウンド）
docker-compose up -d

# 全サービスを起動（ログを表示）
docker-compose up

# 全サービスを停止
docker-compose down

# 全サービスを停止＋データベースも削除
docker-compose down -v

# ログを確認
docker-compose logs

# 特定のサービスのログを確認
docker-compose logs frontend
docker-compose logs backend
docker-compose logs db

# リアルタイムでログを見る
docker-compose logs -f

# サービスの状態を確認
docker-compose ps
```

### 開発中によく使うコマンド

```bash
# コードを変更後、コンテナを再ビルド
docker-compose up -d --build

# 特定のサービスだけ再起動
docker-compose restart frontend
docker-compose restart backend

# コンテナ内でコマンドを実行
docker-compose exec backend sh
docker-compose exec frontend sh

# データベースに接続
docker-compose exec db psql -U ecuser -d mini_ec_db
```

### トラブル時のコマンド

```bash
# 全てを削除してクリーンアップ
docker-compose down -v
docker system prune -a

# その後、再度ビルドして起動
docker-compose up -d --build
```

---

## 🛠️ 開発フロー

### 1. 毎日の作業開始時

```bash
cd C:\dev\mini-ec-site
docker-compose up -d

# VSCodeでプロジェクトを開く
code .
```

### 2. コード編集

- `backend/src/` 配下のファイルを編集
- `frontend/src/` 配下のファイルを編集
- ファイル保存すると自動的に反映される（ホットリロード）

### 3. 作業終了時

```bash
# コンテナを停止（データは保持される）
docker-compose down

# または、起動したままでもOK
```

---

## 📊 データベース操作

### データベースに接続

```bash
# PostgreSQLのCLIに接続
docker-compose exec db psql -U ecuser -d mini_ec_db

# 接続後、SQLを実行できる
SELECT * FROM products;

# 終了
\q
```

### テーブルの確認

```sql
-- テーブル一覧
\dt

-- テーブル構造の確認
\d products

-- データの確認
SELECT * FROM products;
```

### データベースのリセット

```bash
# データベースを含めて完全に削除
docker-compose down -v

# 再起動（init.sqlが再実行される）
docker-compose up -d
```

---

## 🐛 トラブルシューティング

### ポートが既に使用されている

```
Error: Port 3000 is already in use
```

**解決方法**:
```bash
# 使用中のプロセスを確認
netstat -ano | findstr :3000

# docker-compose.ymlのポート番号を変更
ports:
  - "3001:3000"  # 3000 → 3001に変更
```

### データベースに接続できない

**解決方法**:
```bash
# データベースの状態を確認
docker-compose ps

# ログを確認
docker-compose logs db

# データベースを再起動
docker-compose restart db
```

### 環境変数が読み込まれない

**解決方法**:
```bash
# .envファイルが存在するか確認
ls backend/.env

# なければ作成
cd backend
copy .env.example .env

# コンテナを再ビルド
docker-compose up -d --build
```

### コンテナのビルドが失敗する

**解決方法**:
```bash
# キャッシュをクリアして再ビルド
docker-compose build --no-cache

# それでもダメなら全削除して再構築
docker-compose down -v
docker system prune -a
docker-compose up -d --build
```

### ファイル変更が反映されない

**解決方法**:
```bash
# コンテナを再起動
docker-compose restart frontend
docker-compose restart backend

# それでもダメならリビルド
docker-compose up -d --build
```

---

## 📦 新しいパッケージの追加方法

### バックエンドにパッケージを追加

```bash
# 方法1: package.jsonに直接追加して再ビルド
# backend/package.json に依存関係を追加
docker-compose up -d --build backend

# 方法2: コンテナ内でインストール
docker-compose exec backend npm install パッケージ名
docker-compose restart backend
```

### フロントエンドにパッケージを追加

```bash
# frontend/package.json に依存関係を追加
docker-compose up -d --build frontend

# または
docker-compose exec frontend npm install パッケージ名
docker-compose restart frontend
```

---

## 🎯 次のステップ

環境構築が完了したら、以下の順で開発を進めます：

### Week 1: バックエンドAPI開発
1. 商品一覧取得API (`GET /api/products`)
2. 商品詳細取得API (`GET /api/products/:id`)
3. 商品作成API (`POST /api/products`)
4. 商品更新API (`PUT /api/products/:id`)
5. 商品削除API (`DELETE /api/products/:id`)

### Week 2: フロントエンド開発
1. トップページ（商品一覧表示）
2. 商品詳細ページ
3. カートページ
4. デザイン調整（Tailwind CSS）

### Week 3: 機能拡張
1. カート機能
2. 検索・フィルター機能
3. レスポンシブ対応
4. パフォーマンス最適化

---

## 🚢 デプロイ準備

このDocker Compose環境は、以下のサービスにそのままデプロイできます：

- **フロントエンド**: Vercel / Netlify
- **バックエンド**: Railway / Render / Fly.io
- **データベース**: Supabase / Neon / Railway

デプロイ手順は、実装が進んだ段階で詳しく説明します。

---

## 💡 便利なTips

### VSCodeでコンテナ内のファイルを編集

VSCodeの「Dev Containers」拡張機能をインストールすると、コンテナ内で直接開発できます。

### Docker Desktopでコンテナを管理

Docker Desktop のGUIから、各コンテナの状態確認・ログ表示・停止/起動ができます。

### データベースGUIツール

以下のツールでデータベースを視覚的に管理できます：
- DBeaver（無料）
- pgAdmin（無料）
- TablePlus（有料・無料版あり）

接続情報：
- Host: localhost
- Port: 5432
- Database: mini_ec_db
- Username: ecuser
- Password: ecpass123

---

## 🔗 参考リンク

- [Docker Compose公式ドキュメント](https://docs.docker.com/compose/)
- [Next.js公式ドキュメント](https://nextjs.org/docs)
- [Express公式ガイド](https://expressjs.com/)
- [PostgreSQL公式ドキュメント](https://www.postgresql.org/docs/)

---

## ❓ 質問・サポート

環境構築やコーディングで困ったことがあれば、いつでも質問してください！

- エラーメッセージを共有してください
- どの手順で詰まったか教えてください
- 一緒に解決していきましょう

---

**Happy Coding! 🎉**

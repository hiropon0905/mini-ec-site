# ミニECサイト環境構築 - ステップバイステップ手順

## ✅ セットアップチェックリスト

このチェックリストに従って進めれば、確実に環境構築できます。

---

## 📋 前提条件の確認

- [x] Docker Desktopがインストール済み
- [x] Docker Desktopが起動している
- [x] Gitがインストール済み
- [x] VSCodeがインストール済み

---

## 🔧 セットアップ手順

### ステップ1: プロジェクトフォルダの作成

```bash
# コマンドプロンプトまたはPowerShellで実行
mkdir C:\dev\mini-ec-site
cd C:\dev\mini-ec-site
```

- [x] フォルダ作成完了

---

### ステップ2: 必要なサブフォルダを作成

```bash
# mini-ec-siteフォルダ内で実行
mkdir backend
mkdir backend\src
mkdir db
```

- [x] backend フォルダ作成完了
- [x] backend\src フォルダ作成完了
- [x] db フォルダ作成完了

---

### ステップ3: ダウンロードしたファイルを配置

以下のファイルを、指定された場所に配置してください：

**プロジェクトルート (C:\dev\mini-ec-site\)**
- [x] docker-compose.yml
- [x] README.md
- [x] COMMANDS.md
- [x] .gitignore

**backend フォルダ (C:\dev\mini-ec-site\backend\)**
- [x] Dockerfile (backend-Dockerfileをリネーム)
- [x] package.json
- [x] tsconfig.json
- [x] .env.example

**backend\src フォルダ (C:\dev\mini-ec-site\backend\src\)**
- [x] index.ts
- [x] db.ts

**db フォルダ (C:\dev\mini-ec-site\db\)**
- [x] init.sql

---

### ステップ4: 環境変数ファイルの作成

```bash
# backendフォルダに移動
cd C:\dev\mini-ec-site\backend

# .envファイルを作成（.env.exampleをコピー）
copy .env.example .env
```

- [x] .env ファイル作成完了

---

### ステップ5: frontendフォルダを作成してNext.jsをセットアップ

```bash
# プロジェクトルートに戻る
cd C:\dev\mini-ec-site

# frontendフォルダを作成
mkdir frontend
cd frontend

# Docker経由でNext.jsプロジェクトを作成
# コマンドプロンプトの場合:
docker run --rm -it -v "%cd%":/app -w /app node:20-alpine npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --no-import-alias

# PowerShellの場合:
# docker run --rm -it -v "${PWD}:/app" -w /app node:20-alpine npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --no-import-alias
```

**所要時間**: 2-3分

**成功のサイン**: "Success! Created ..." と表示される

- [x] Next.jsプロジェクト作成完了
- [x] frontend フォルダ内に package.json が作成されている

---

### ステップ6: frontendにDockerfileを配置

ダウンロードした `frontend-Dockerfile` を以下の場所に配置：

**配置先**: `C:\dev\mini-ec-site\frontend\Dockerfile`

⚠️ 注意: ファイル名から `-` を削除して `Dockerfile` にリネーム

- [x] frontend\Dockerfile 配置完了

---

### ステップ7: プロジェクト構成の最終確認

以下の構成になっているか確認してください：

```
C:\dev\mini-ec-site\
├── docker-compose.yml ✓
├── README.md ✓
├── COMMANDS.md ✓
├── .gitignore ✓
│
├── backend\
│   ├── Dockerfile ✓
│   ├── package.json ✓
│   ├── tsconfig.json ✓
│   ├── .env.example ✓
│   ├── .env ✓
│   └── src\
│       ├── index.ts ✓
│       └── db.ts ✓
│
├── frontend\
│   ├── Dockerfile ✓
│   ├── package.json ✓
│   ├── next.config.js ✓
│   ├── tsconfig.json ✓
│   └── src\
│       └── app\
│           ├── layout.tsx ✓
│           └── page.tsx ✓
│
└── db\
    └── init.sql ✓
```

- [ ] すべてのファイルが正しい場所にある

---

### ステップ8: Docker Composeで環境を起動

```bash
# プロジェクトルートに移動
cd C:\dev\mini-ec-site

# Dockerコンテナをビルド&起動
docker-compose up -d

# ⏱️ 初回は5-10分かかります（イメージのダウンロード&ビルド）
# 2回目以降は30秒程度で起動します
```

**進行状況の確認**:
```bash
# 別のターミナルで実行
docker-compose logs -f
```

- [x] docker-compose up -d 実行完了
- [x] エラーが出ていない

---

### ステップ9: 動作確認

ブラウザで以下のURLにアクセスして確認：

**フロントエンド**: http://localhost:3000
- [x] Next.jsの初期画面が表示される

**バックエンド ヘルスチェック**: http://localhost:4000/api/health
- [x] `{"status":"OK","message":"Backend is running!",...}` が表示される

**データベース接続テスト**: http://localhost:4000/api/db-test
- [x] `{"success":true,"data":{...}}` が表示される

---

### ステップ10: VSCodeでプロジェクトを開く

```bash
# プロジェクトルートで実行
cd C:\dev\mini-ec-site
code .
```

- [x] VSCodeでプロジェクトが開いた
- [x] ファイル一覧が表示されている

---

## 🎉 完了！

すべてのチェックが完了したら、環境構築は完璧です！

---

## 🐛 トラブルシューティング

### Docker Desktopが起動していない

**エラー**: `Cannot connect to the Docker daemon`

**解決方法**:
1. Docker Desktopを起動
2. タスクバーにDockerアイコンが表示されるまで待つ
3. もう一度 `docker-compose up -d` を実行

---

### ポートが既に使用されている

**エラー**: `Bind for 0.0.0.0:3000 failed: port is already allocated`

**解決方法**:
```bash
# 使用中のプロセスを確認
netstat -ano | findstr :3000

# docker-compose.ymlのポート番号を変更
# ports:
#   - "3001:3000"  # 左側の数字を変更
```

---

### Next.jsプロジェクト作成がエラーになる

**エラー**: `EACCES: permission denied`

**解決方法**:
1. frontendフォルダを削除
2. フォルダを再作成
3. 管理者権限でコマンドプロンプトを起動
4. もう一度Dockerコマンドを実行

---

### データベースに接続できない

**エラー**: `Database connection failed`

**解決方法**:
```bash
# データベースコンテナの状態確認
docker-compose ps

# データベースのログ確認
docker-compose logs db

# データベースコンテナを再起動
docker-compose restart db

# それでもダメなら完全リセット
docker-compose down -v
docker-compose up -d
```

---

### ファイルが見つからない

**エラー**: `No such file or directory`

**解決方法**:
1. ステップ7の「プロジェクト構成の最終確認」を再確認
2. ファイルが正しい場所にあるか確認
3. ファイル名が正しいか確認（特にDockerfile）

---

## 📞 サポート

それでも解決しない場合は、以下の情報を共有してください：

1. エラーメッセージ全文
2. 実行したコマンド
3. どのステップで詰まったか

一緒に解決していきましょう！

---

## 🚀 次のステップ

環境構築が完了したら：

1. **コードの編集を試す**
   - `frontend/src/app/page.tsx` を編集
   - ブラウザで変更が反映されるか確認

2. **APIの動作確認**
   - http://localhost:4000/api/health にアクセス
   - http://localhost:4000/api/db-test にアクセス

3. **データベースの確認**
   ```bash
   docker-compose exec db psql -U ecuser -d mini_ec_db
   SELECT * FROM products;
   \q
   ```

4. **実装開始**
   - 商品一覧API開発
   - フロントエンド画面作成
   - 機能追加

お疲れ様でした！🎉

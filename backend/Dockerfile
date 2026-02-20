FROM node:20-alpine

WORKDIR /app

# package.jsonとpackage-lock.jsonをコピー
COPY package*.json ./

# 依存関係のインストール
RUN npm install

# アプリケーションのソースコードをコピー
COPY . .

# ポート4000を公開
EXPOSE 4000

# 開発サーバーの起動（docker-compose.ymlでオーバーライド可能）
CMD ["npm", "run", "dev"]

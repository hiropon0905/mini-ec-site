-- データベース初期化スクリプト

-- 更新日時を自動更新する関数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 商品テーブル
-- 既存のテーブルを削除
DROP TABLE IF EXISTS products CASCADE;

-- テーブル定義
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price INTEGER NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    image_url VARCHAR(500),
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- トリガーの作成
DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- サンプルデータの挿入
INSERT INTO products (name, description, price, stock, category) VALUES
    ('ノートPC', '高性能なノートパソコン', 120000, 10, 'Electronics'),
    ('ワイヤレスマウス', 'Bluetooth対応マウス', 3500, 50, 'Electronics'),
    ('キーボード', 'メカニカルキーボード', 15000, 30, 'Electronics'),
    ('モニター', '27インチ4Kモニター', 45000, 15, 'Electronics'),
    ('ヘッドフォン', 'ノイズキャンセリング機能付き', 25000, 25, 'Electronics')
ON CONFLICT DO NOTHING;

-- インデックスの作成
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);

-- ユーザーテーブル（将来の拡張用）
-- 既存のusersテーブルを削除
DROP TABLE IF EXISTS users CASCADE;

-- テーブル定義
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- トリガーの作成
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- サンプルデータの挿入
-- 今は管理者ユーザーだけ追加（パスワードは後でハッシュ化します）
INSERT INTO users (name, email, password_hash, role) VALUES
    ('管理者', 'admin@example.com', 'dummy_hash', 'admin')
ON CONFLICT (email) DO NOTHING;

-- インデックスの作成
-- なし
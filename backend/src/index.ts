import express, { Request, Response } from 'express';
import cors from 'cors';
import pool from './db';

const app = express();
const PORT = process.env.PORT || 4000;

// ミドルウェア
app.use(cors());
app.use(express.json());

// ヘルスチェックエンドポイント
app.get('/api/health', (req: Request, res: Response) => {
  res.json({ 
    status: 'OK', 
    message: 'Backend is running!',
    timestamp: new Date().toISOString()
  });
});

// データベース接続テスト
app.get('/api/db-test', async (req: Request, res: Response) => {
  try {
    const result = await pool.query('SELECT NOW() as current_time, version() as pg_version');
    res.json({ 
      success: true, 
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Database connection error:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Database connection failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

// サーバー起動
app.listen(PORT, () => {
  console.log(`🚀 Server is running on http://localhost:${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/api/health`);
  console.log(`💾 DB test: http://localhost:${PORT}/api/db-test`);
});

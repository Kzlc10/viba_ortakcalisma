-- 1. Users tablosunu oluştur
CREATE TABLE IF NOT EXISTS users (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  surname TEXT NOT NULL,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  email TEXT,
  role TEXT,
  photo TEXT,
  uuid TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

-- 2. BroadcastMessages tablosunu oluştur
CREATE TABLE IF NOT EXISTS broadcastmessages (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  senderID INTEGER NOT NULL,
  message TEXT,
  type TEXT NOT NULL,
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (senderID) REFERENCES users(ID) ON DELETE CASCADE
);

-- 3. BroadcastMessageRecipients tablosunu oluştur
CREATE TABLE IF NOT EXISTS broadcastmessagerecipients (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  broadcastMessageID INTEGER NOT NULL,
  receiverID INTEGER NOT NULL,
  status TEXT DEFAULT 'sent',
  deliveredAt TIMESTAMP,
  seenAt TIMESTAMP,
  FOREIGN KEY (broadcastMessageID) REFERENCES broadcastmessages(ID) ON DELETE CASCADE,
  FOREIGN KEY (receiverID) REFERENCES users(ID) ON DELETE CASCADE
);

-- 4. Calls tablosunu oluştur
CREATE TABLE IF NOT EXISTS calls (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  callerID INTEGER NOT NULL,
  receiverID INTEGER NOT NULL,
  call_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  call_end TIMESTAMP,
  duration INTEGER,
  call_status TEXT,
  FOREIGN KEY (callerID) REFERENCES users(ID) ON DELETE CASCADE,
  FOREIGN KEY (receiverID) REFERENCES users(ID) ON DELETE CASCADE
);

-- 5. LoginRegisterLogs tablosunu oluştur
CREATE TABLE IF NOT EXISTS loginregisterlogs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  operation TEXT NOT NULL,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  ip_address TEXT NOT NULL,
  status TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(ID)
);

-- 6. Messages tablosunu oluştur
CREATE TABLE IF NOT EXISTS messages (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  message TEXT,
  type TEXT NOT NULL,  -- Mesajın türü: text, image, video, vb.
  receiverID INTEGER,
  senderID INTEGER NOT NULL,
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status TEXT DEFAULT 'not_seen',  -- 'not_seen', 'delivered', 'seen'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at DATETIME,
  message_type TEXT DEFAULT 'text',  -- 'text', 'image', 'video', vb.
  FOREIGN KEY (receiverID) REFERENCES users(ID) ON DELETE SET NULL,
  FOREIGN KEY (senderID) REFERENCES users(ID) ON DELETE CASCADE
);

-- 7. Sessions tablosunu oluştur
CREATE TABLE IF NOT EXISTS sessions (
  UUID TEXT PRIMARY KEY,
  userID INTEGER NOT NULL,
  token TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userID) REFERENCES users(ID) ON DELETE CASCADE
);
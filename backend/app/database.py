import sqlite3
import os
import string
import random
from datetime import datetime
from typing import Optional, List, Dict, Any

DB_PATH = os.path.join(os.path.dirname(__file__), "agribridge.db")

def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_connection()
    cursor = conn.cursor()
    
    # Land registrations table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS land_registrations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reference_no TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        city TEXT NOT NULL,
        state TEXT NOT NULL,
        district TEXT NOT NULL,
        village TEXT NOT NULL,
        size REAL NOT NULL,
        unit TEXT NOT NULL,
        water_source TEXT NOT NULL,
        notes TEXT,
        status TEXT DEFAULT 'Details submitted',
        created_at TEXT NOT NULL
    );
    """)
    
    # Worker registrations table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS worker_registrations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reference_no TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        village TEXT NOT NULL,
        skills TEXT NOT NULL,
        status TEXT DEFAULT 'Registered',
        created_at TEXT NOT NULL
    );
    """)
    
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_land_ref ON land_registrations(reference_no);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_land_phone ON land_registrations(phone);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_worker_ref ON worker_registrations(reference_no);")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_worker_phone ON worker_registrations(phone);")
    
    conn.commit()
    conn.close()

def generate_reference(prefix: str) -> str:
    """Generates a 5-char alphanumeric unique reference (e.g. LAND-FC6LM or WORK-FC6LM)."""
    chars = string.ascii_uppercase + string.digits
    conn = get_connection()
    cursor = conn.cursor()
    
    table = "land_registrations" if prefix == "LAND" else "worker_registrations"
    while True:
        code = f"{prefix}-" + "".join(random.choices(chars, k=5))
        cursor.execute(f"SELECT id FROM {table} WHERE reference_no = ?", (code,))
        if not cursor.fetchone():
            conn.close()
            return code

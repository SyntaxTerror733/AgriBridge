import os
import sys

# Ensure current and parent directories are in python path for both local and Render execution
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.abspath(os.path.join(current_dir, ".."))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)
if parent_dir not in sys.path:
    sys.path.insert(0, parent_dir)

from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime
import json
import re
from typing import List, Dict, Any, Optional

from app.database import init_db, get_connection, generate_reference
from app.schemas import (
    LandRegisterRequest, LandResponse,
    WorkerRegisterRequest, WorkerResponse,
    CropAdvisorRequest, CropAdvisorResponse,
    AdvisorQueryRequest, AdvisorQueryResponse
)
from app.advisor_engine import get_recommendations, query_advisor

# Automatically ensure database and tables exist on module load & startup
init_db()

app = FastAPI(
    title="Agribridge API",
    description="Remote Farming & Village Labor Platform API",
    version="1.0.0"
)

# Enable CORS for all origins, methods, and headers
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/api/health")
def health_check():
    return {
        "status": "healthy",
        "service": "Agribridge Backend",
        "timestamp": datetime.utcnow().isoformat()
    }

# ----------------- LAND REGISTRATION -----------------

@app.post("/api/land/register", response_model=LandResponse, status_code=status.HTTP_201_CREATED)
def register_land(req: LandRegisterRequest):
    ref_no = generate_reference("LAND")
    created_at = datetime.utcnow().isoformat()
    default_status = "Details submitted"
    
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO land_registrations 
        (reference_no, name, phone, city, state, district, village, size, unit, water_source, notes, status, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        ref_no, req.name.strip(), req.phone.strip(), req.city.strip(),
        req.state.strip(), req.district.strip(), req.village.strip(),
        req.size, req.unit.strip(), req.water_source.strip(),
        req.notes.strip() if req.notes else "", default_status, created_at
    ))
    row_id = cursor.lastrowid
    conn.commit()
    conn.close()
    
    return LandResponse(
        id=row_id,
        reference_no=ref_no,
        name=req.name.strip(),
        phone=req.phone.strip(),
        city=req.city.strip(),
        state=req.state.strip(),
        district=req.district.strip(),
        village=req.village.strip(),
        size=req.size,
        unit=req.unit.strip(),
        water_source=req.water_source.strip(),
        notes=req.notes.strip() if req.notes else "",
        status=default_status,
        created_at=created_at
    )

@app.get("/api/land/{ref_or_phone}", response_model=LandResponse)
def get_land(ref_or_phone: str):
    cleaned_query = ref_or_phone.strip()
    digits = re.sub(r"[^\d]", "", cleaned_query)
    
    conn = get_connection()
    cursor = conn.cursor()
    
    if len(digits) == 10:
        cursor.execute("""
            SELECT * FROM land_registrations 
            WHERE phone = ? 
            ORDER BY id DESC LIMIT 1
        """, (digits,))
    else:
        cursor.execute("""
            SELECT * FROM land_registrations 
            WHERE UPPER(reference_no) = UPPER(?) 
            ORDER BY id DESC LIMIT 1
        """, (cleaned_query,))
        
    row = cursor.fetchone()
    conn.close()
    
    if not row:
        raise HTTPException(
            status_code=404,
            detail=f"No land registration found for query '{ref_or_phone}'"
        )
        
    return LandResponse(
        id=row["id"],
        reference_no=row["reference_no"],
        name=row["name"],
        phone=row["phone"],
        city=row["city"],
        state=row["state"],
        district=row["district"],
        village=row["village"],
        size=row["size"],
        unit=row["unit"],
        water_source=row["water_source"],
        notes=row["notes"],
        status=row["status"],
        created_at=row["created_at"]
    )

# ----------------- WORKER REGISTRATION -----------------

@app.post("/api/workers/register", response_model=WorkerResponse, status_code=status.HTTP_201_CREATED)
def register_worker(req: WorkerRegisterRequest):
    ref_no = generate_reference("WORK")
    created_at = datetime.utcnow().isoformat()
    default_status = "Registered"
    skills_json = json.dumps(req.skills, ensure_ascii=False)
    
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO worker_registrations 
        (reference_no, name, phone, village, skills, status, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, (
        ref_no, req.name.strip(), req.phone.strip(), req.village.strip(),
        skills_json, default_status, created_at
    ))
    row_id = cursor.lastrowid
    conn.commit()
    conn.close()
    
    return WorkerResponse(
        id=row_id,
        reference_no=ref_no,
        name=req.name.strip(),
        phone=req.phone.strip(),
        village=req.village.strip(),
        skills=req.skills,
        status=default_status,
        created_at=created_at
    )

@app.get("/api/workers/{ref_or_phone}", response_model=WorkerResponse)
def get_worker(ref_or_phone: str):
    cleaned_query = ref_or_phone.strip()
    digits = re.sub(r"[^\d]", "", cleaned_query)
    
    conn = get_connection()
    cursor = conn.cursor()
    
    if len(digits) == 10:
        cursor.execute("""
            SELECT * FROM worker_registrations 
            WHERE phone = ? 
            ORDER BY id DESC LIMIT 1
        """, (digits,))
    else:
        cursor.execute("""
            SELECT * FROM worker_registrations 
            WHERE UPPER(reference_no) = UPPER(?) 
            ORDER BY id DESC LIMIT 1
        """, (cleaned_query,))
        
    row = cursor.fetchone()
    conn.close()
    
    if not row:
        raise HTTPException(
            status_code=404,
            detail=f"No worker registration found for query '{ref_or_phone}'"
        )
        
    skills_list = json.loads(row["skills"]) if row["skills"] else []
    return WorkerResponse(
        id=row["id"],
        reference_no=row["reference_no"],
        name=row["name"],
        phone=row["phone"],
        village=row["village"],
        skills=skills_list,
        status=row["status"],
        created_at=row["created_at"]
    )

# ----------------- SMART CROP ADVISOR -----------------

@app.post("/api/advisor/recommend", response_model=CropAdvisorResponse)
def recommend_crops(req: CropAdvisorRequest):
    return get_recommendations(req.state, req.season, req.soil, req.water)

@app.post("/api/advisor/query", response_model=AdvisorQueryResponse)
def ask_advisor(req: AdvisorQueryRequest):
    return query_advisor(req.question)

# ----------------- ADMIN & STATS -----------------

@app.get("/api/admin/stats")
def get_stats():
    conn = get_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT COUNT(*) as total_lands, SUM(size) as total_acres FROM land_registrations")
    land_row = cursor.fetchone()
    
    cursor.execute("SELECT COUNT(*) as total_workers FROM worker_registrations")
    worker_row = cursor.fetchone()
    
    conn.close()
    
    return {
        "total_lands": land_row["total_lands"] or 0,
        "total_acres_managed": round(land_row["total_acres"] or 0, 2),
        "total_workers": worker_row["total_workers"] or 0,
        "active_districts": 42
    }

@app.get("/api/admin/lands", response_model=List[LandResponse])
def get_all_lands():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM land_registrations ORDER BY id DESC")
    rows = cursor.fetchall()
    conn.close()
    
    return [
        LandResponse(
            id=r["id"],
            reference_no=r["reference_no"],
            name=r["name"],
            phone=r["phone"],
            city=r["city"],
            state=r["state"],
            district=r["district"],
            village=r["village"],
            size=r["size"],
            unit=r["unit"],
            water_source=r["water_source"],
            notes=r["notes"],
            status=r["status"],
            created_at=r["created_at"]
        ) for r in rows
    ]

@app.get("/api/admin/workers", response_model=List[WorkerResponse])
def get_all_workers():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM worker_registrations ORDER BY id DESC")
    rows = cursor.fetchall()
    conn.close()
    
    return [
        WorkerResponse(
            id=r["id"],
            reference_no=r["reference_no"],
            name=r["name"],
            phone=r["phone"],
            village=r["village"],
            skills=json.loads(r["skills"]) if r["skills"] else [],
            status=r["status"],
            created_at=r["created_at"]
        ) for r in rows
    ]

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("app.main:app", host="0.0.0.0", port=port, reload=False)

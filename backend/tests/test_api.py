import pytest
import os
import sys

# Ensure backend root is in sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from fastapi.testclient import TestClient
from app.main import app
from app.database import init_db, DB_PATH

@pytest.fixture(scope="session", autouse=True)
def setup_test_db():
    # Remove existing db if needed or re-init
    if os.path.exists(DB_PATH):
        try:
            os.remove(DB_PATH)
        except Exception:
            pass
    init_db()
    yield
    # Cleanup after tests
    if os.path.exists(DB_PATH):
        try:
            os.remove(DB_PATH)
        except Exception:
            pass

client = TestClient(app)

def test_health_check():
    response = client.get("/api/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "Agribridge Backend" in data["service"]

def test_land_registration_and_lookups():
    # 1. Invalid phone number should fail
    bad_payload = {
        "name": "Ramesh Kumar",
        "phone": "12345",  # invalid length
        "city": "Lucknow",
        "state": "Uttar Pradesh",
        "district": "Barabanki",
        "village": "Fatehpur",
        "size": 5.5,
        "unit": "Acre",
        "water_source": "Borewell",
        "notes": "Testing plot registration"
    }
    bad_res = client.post("/api/land/register", json=bad_payload)
    assert bad_res.status_code == 422

    # 2. Valid land registration
    valid_payload = {
        "name": "Suryansh Chaturvedi",
        "phone": "9876543210",
        "city": "New Delhi",
        "state": "Uttar Pradesh",
        "district": "Ayodhya",
        "village": "Bhikharipur",
        "size": 4.0,
        "unit": "Acre",
        "water_source": "Borewell",
        "notes": "Near main canal road"
    }
    res = client.post("/api/land/register", json=valid_payload)
    assert res.status_code == 201
    data = res.json()
    assert data["name"] == "Suryansh Chaturvedi"
    assert data["phone"] == "9876543210"
    assert data["status"] == "Details submitted"
    assert data["reference_no"].startswith("LAND-")
    assert len(data["reference_no"]) == 10  # LAND- + 5 chars

    ref_no = data["reference_no"]

    # 3. Lookup by reference number
    ref_res = client.get(f"/api/land/{ref_no}")
    assert ref_res.status_code == 200
    assert ref_res.json()["reference_no"] == ref_no
    assert ref_res.json()["name"] == "Suryansh Chaturvedi"

    # 4. Lookup by phone number
    phone_res = client.get("/api/land/9876543210")
    assert phone_res.status_code == 200
    assert phone_res.json()["reference_no"] == ref_no

    # 5. Non-existent lookup
    nf_res = client.get("/api/land/LAND-99999")
    assert nf_res.status_code == 404

def test_worker_registration_and_lookups():
    # 1. Valid worker registration
    worker_payload = {
        "name": "Ramesh Yadav",
        "phone": "9812345678",
        "village": "Bilaspur",
        "skills": ["Ploughing", "Tractor driving", "Harvesting"]
    }
    res = client.post("/api/workers/register", json=worker_payload)
    assert res.status_code == 201
    data = res.json()
    assert data["name"] == "Ramesh Yadav"
    assert data["phone"] == "9812345678"
    assert data["status"] == "Registered"
    assert data["reference_no"].startswith("WORK-")
    assert len(data["reference_no"]) == 10  # WORK- + 5 chars
    assert "Ploughing" in data["skills"]

    ref_no = data["reference_no"]

    # 2. Lookup by worker reference number
    ref_res = client.get(f"/api/workers/{ref_no}")
    assert ref_res.status_code == 200
    assert ref_res.json()["name"] == "Ramesh Yadav"
    assert ref_res.json()["village"] == "Bilaspur"

    # 3. Lookup by worker phone number
    phone_res = client.get("/api/workers/9812345678")
    assert phone_res.status_code == 200
    assert phone_res.json()["reference_no"] == ref_no

    # 4. Non-existent lookup
    nf_res = client.get("/api/workers/WORK-00000")
    assert nf_res.status_code == 404

def test_crop_advisor_recommendations():
    # Test across multiple states and seasons
    test_cases = [
        {"state": "Uttar Pradesh", "season": "Rabi (Winter: Nov - Apr)", "soil": "Alluvial Soil (जलोढ़ मिट्टी)", "water": "Canal / Borewell (Assured High)"},
        {"state": "Punjab", "season": "Kharif (Monsoon: Jun - Oct)", "soil": "Clay (चिकनी मिट्टी)", "water": "Canal / Borewell (Assured High)"},
        {"state": "Rajasthan", "season": "Rabi (Winter: Nov - Apr)", "soil": "Sandy Loam (बलुई दोमट)", "water": "Low / Rainfed"},
        {"state": "Maharashtra", "season": "Kharif (Monsoon: Jun - Oct)", "soil": "Black Soil (काली मिट्टी)", "water": "Medium / Tubewell"},
        {"state": "Gujarat", "season": "Zaid (Summer: Mar - Jun)", "soil": "Sandy Loam", "water": "Canal / Borewell (Assured High)"},
        {"state": "Madhya Pradesh", "season": "Rabi", "soil": "Black Soil", "water": "Medium"},
        {"state": "Haryana", "season": "Kharif", "soil": "Alluvial Soil", "water": "High"},
        {"state": "Bihar", "season": "Zaid", "soil": "Alluvial Soil", "water": "Medium"}
    ]

    for tc in test_cases:
        res = client.post("/api/advisor/recommend", json=tc)
        assert res.status_code == 200
        data = res.json()
        assert "summary" in data and len(data["summary"]) > 0
        assert "summary_hi" in data and len(data["summary_hi"]) > 0
        assert len(data["crops"]) >= 2
        assert len(data["best_practices"]) == 4
        assert len(data["best_practices_hi"]) == 4

        # Validate top crop structure
        top_crop = data["crops"][0]
        assert top_crop["is_top_pick"] is True
        assert len(top_crop["name"]) > 0
        assert len(top_crop["name_hi"]) > 0
        assert "Acre" in top_crop["est_yield"]
        assert "₹" in top_crop["est_profit"]
        assert len(top_crop["key_advice"]) > 0
        assert len(top_crop["key_advice_hi"]) > 0

def test_crop_advisor_qa():
    queries = [
        "Best crop to plant after mustard?",
        "When should I do the first irrigation for wheat?",
        "Most profitable crop with low water requirement?",
        "How to prevent aphid pests in mustard?",
        "General advice for new farm land"
    ]

    for q in queries:
        res = client.post("/api/advisor/query", json={"question": q})
        assert res.status_code == 200
        data = res.json()
        assert data["title"] == "Agronomy Engine Advisory"
        assert data["verified_label"] == "Verified guidance"
        assert len(data["answer"]) > 10
        assert len(data["answer_hi"]) > 10
        assert len(data["tags"]) >= 2

def test_admin_and_stats():
    # 1. Stats
    stats_res = client.get("/api/admin/stats")
    assert stats_res.status_code == 200
    stats = stats_res.json()
    assert stats["total_lands"] >= 1
    assert stats["total_workers"] >= 1
    assert stats["total_acres_managed"] > 0

    # 2. All lands
    lands_res = client.get("/api/admin/lands")
    assert lands_res.status_code == 200
    assert len(lands_res.json()) >= 1

    # 3. All workers
    workers_res = client.get("/api/admin/workers")
    assert workers_res.status_code == 200
    assert len(workers_res.json()) >= 1

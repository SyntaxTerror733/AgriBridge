import sys
import os
import json

# Add backend directory to sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.database import init_db, get_connection, DB_PATH
from app.schemas import (
    LandRegisterRequest, WorkerRegisterRequest,
    CropAdvisorRequest, AdvisorQueryRequest
)
from app.main import (
    health_check, register_land, get_land,
    register_worker, get_worker,
    recommend_crops, ask_advisor,
    get_stats, get_all_lands, get_all_workers
)
from fastapi import HTTPException

def run_all_tests():
    print("=" * 60)
    print("AGRIBRIDGE BACKEND COMPREHENSIVE ENDPOINT VERIFICATION")
    print("=" * 60)
    
    # Clean DB for fresh test run
    if os.path.exists(DB_PATH):
        try:
            os.remove(DB_PATH)
        except Exception:
            pass
    init_db()

    passed = 0
    failed = 0

    # 1. Health check
    try:
        h = health_check()
        assert h["status"] == "healthy"
        print("[PASS] [GET /api/health] -> Status: healthy")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [GET /api/health]: {e}")
        failed += 1

    # 2. Land Registration - Validation failure (invalid phone)
    try:
        try:
            LandRegisterRequest(
                name="Ramesh",
                phone="12345",  # Invalid phone
                city="Lucknow",
                state="Uttar Pradesh",
                district="Barabanki",
                village="Fatehpur",
                size=5.0
            )
            print("[FAIL] [POST /api/land/register]: Did not catch invalid phone")
            failed += 1
        except ValueError:
            print("[PASS] [POST /api/land/register - Validation] -> Correctly rejected 5-digit phone")
            passed += 1
    except Exception as e:
        print(f"[FAIL] Validation test failed: {e}")
        failed += 1

    # 3. Land Registration - Successful registration
    land_ref = ""
    try:
        req = LandRegisterRequest(
            name="Suryansh Chaturvedi",
            phone="9876543210",
            city="New Delhi",
            state="Uttar Pradesh",
            district="Ayodhya",
            village="Bhikharipur",
            size=4.5,
            unit="Acre",
            water_source="Borewell",
            notes="Near main canal road"
        )
        res = register_land(req)
        assert res.reference_no.startswith("LAND-")
        assert len(res.reference_no) == 10  # LAND- + 5 random chars
        assert res.status == "Details submitted"
        assert res.name == "Suryansh Chaturvedi"
        land_ref = res.reference_no
        print(f"[PASS] [POST /api/land/register] -> Created {land_ref}, Status: '{res.status}'")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [POST /api/land/register]: {e}")
        failed += 1

    # 4. Land Lookup by Reference Number
    try:
        res = get_land(land_ref)
        assert res.reference_no == land_ref
        assert res.district == "Ayodhya"
        print(f"[PASS] [GET /api/land/{land_ref}] -> Reference lookup matched {res.name}")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [GET /api/land/ref]: {e}")
        failed += 1

    # 5. Land Lookup by 10-digit Phone Number
    try:
        res = get_land("9876543210")
        assert res.reference_no == land_ref
        print("[PASS] [GET /api/land/9876543210] -> Phone lookup matched correctly")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [GET /api/land/phone]: {e}")
        failed += 1

    # 6. Land Lookup - Not Found (404)
    try:
        try:
            get_land("LAND-99999")
            print("[FAIL] [GET /api/land/404]: Expected 404")
            failed += 1
        except HTTPException as he:
            assert he.status_code == 404
            print("[PASS] [GET /api/land/nonexistent] -> Correctly returned 404")
            passed += 1
    except Exception as e:
        print(f"[FAIL] 404 test failed: {e}")
        failed += 1

    # 7. Worker Registration
    worker_ref = ""
    try:
        w_req = WorkerRegisterRequest(
            name="Ramesh Yadav",
            phone="9812345678",
            village="Bilaspur",
            skills=["Ploughing", "Tractor driving", "Harvesting"]
        )
        w_res = register_worker(w_req)
        assert w_res.reference_no.startswith("WORK-")
        assert len(w_res.reference_no) == 10
        assert w_res.status == "Registered"
        assert len(w_res.skills) == 3
        worker_ref = w_res.reference_no
        print(f"[PASS] [POST /api/workers/register] -> Created {worker_ref}, Status: '{w_res.status}'")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [POST /api/workers/register]: {e}")
        failed += 1

    # 8. Worker Lookup by Reference Number
    try:
        res = get_worker(worker_ref)
        assert res.reference_no == worker_ref
        assert "Tractor driving" in res.skills
        print(f"[PASS] [GET /api/workers/{worker_ref}] -> Reference lookup matched {res.name}")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [GET /api/workers/ref]: {e}")
        failed += 1

    # 9. Worker Lookup by Phone Number
    try:
        res = get_worker("9812345678")
        assert res.reference_no == worker_ref
        print("[PASS] [GET /api/workers/9812345678] -> Phone lookup matched correctly")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [GET /api/workers/phone]: {e}")
        failed += 1

    # 10. Worker Lookup - Not Found (404)
    try:
        try:
            get_worker("WORK-00000")
            print("[FAIL] [GET /api/workers/404]: Expected 404")
            failed += 1
        except HTTPException as he:
            assert he.status_code == 404
            print("[PASS] [GET /api/workers/nonexistent] -> Correctly returned 404")
            passed += 1
    except Exception as e:
        print(f"[FAIL] Worker 404 test failed: {e}")
        failed += 1

    # 11. Crop Advisor Recommendation across all 8 states and all 3 seasons
    states_to_test = [
        ("Uttar Pradesh", "Rabi (Winter: Nov - Apr)", "Alluvial Soil (जलोढ़ मिट्टी)", "Canal / Borewell (Assured High)"),
        ("Punjab", "Kharif (Monsoon: Jun - Oct)", "Clay (चिकनी मिट्टी)", "Canal / Borewell (Assured High)"),
        ("Haryana", "Rabi (Winter: Nov - Apr)", "Alluvial Soil", "Canal / Borewell (Assured High)"),
        ("Madhya Pradesh", "Kharif (Monsoon: Jun - Oct)", "Black Soil (काली मिट्टी)", "Medium / Tubewell"),
        ("Maharashtra", "Kharif (Monsoon: Jun - Oct)", "Black Soil", "Medium / Tubewell"),
        ("Rajasthan", "Rabi (Winter: Nov - Apr)", "Sandy Loam (बलुई दोमट)", "Low / Rainfed"),
        ("Bihar", "Zaid (Summer: Mar - Jun)", "Alluvial Soil", "Medium / Tubewell"),
        ("Gujarat", "Zaid (Summer: Mar - Jun)", "Sandy Loam", "Canal / Borewell (Assured High)")
    ]

    all_states_passed = True
    for st, se, so, wa in states_to_test:
        rec_req = CropAdvisorRequest(state=st, season=se, soil=so, water=wa)
        rec_res = recommend_crops(rec_req)
        if len(rec_res.crops) < 2 or not rec_res.summary or not rec_res.summary_hi:
            all_states_passed = False
            print(f"[FAIL] Advisor recommendation failed for {st} - {se}")
            break
        top_crop = rec_res.crops[0]
        if not top_crop.name_hi or not top_crop.key_advice_hi:
            all_states_passed = False
            print(f"[FAIL] Missing Hindi translation in crop recommendation for {st}")
            break

    if all_states_passed:
        print("[PASS] [POST /api/advisor/recommend] -> Successfully tested 8 states across Kharif, Rabi, Zaid")
        passed += 1
    else:
        failed += 1

    # 12. Crop Advisor Q&A
    test_questions = [
        "Best crop to plant after mustard?",
        "When should I do the first irrigation for wheat?",
        "Most profitable crop with low water requirement?",
        "What to do about aphid pests?",
        "General soil test questions"
    ]
    all_qa_passed = True
    for q in test_questions:
        ans = ask_advisor(AdvisorQueryRequest(question=q))
        if not ans.answer or not ans.answer_hi or len(ans.tags) == 0:
            all_qa_passed = False
            print(f"[FAIL] Advisor Q&A failed for query: {q}")
            break

    if all_qa_passed:
        print("[PASS] [POST /api/advisor/query] -> Successfully tested agronomy Q&A matches with bilingual output & tags")
        passed += 1
    else:
        failed += 1

    # 13. Admin Stats
    try:
        stats = get_stats()
        assert stats["total_lands"] >= 1
        assert stats["total_workers"] >= 1
        assert stats["total_acres_managed"] > 0
        print(f"[PASS] [GET /api/admin/stats] -> Lands: {stats['total_lands']}, Workers: {stats['total_workers']}, Acres: {stats['total_acres_managed']}")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [GET /api/admin/stats]: {e}")
        failed += 1

    # 14. Admin Lands
    try:
        lands = get_all_lands()
        assert len(lands) >= 1
        print(f"[PASS] [GET /api/admin/lands] -> Returned {len(lands)} registered plots")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [GET /api/admin/lands]: {e}")
        failed += 1

    # 15. Admin Workers
    try:
        workers = get_all_workers()
        assert len(workers) >= 1
        print(f"[PASS] [GET /api/admin/workers] -> Returned {len(workers)} registered workers")
        passed += 1
    except Exception as e:
        print(f"[FAIL] [GET /api/admin/workers]: {e}")
        failed += 1

    # 16. Verify Clean Database (Requirement 6: Do not seed any fake registrations in the database)
    # Reset DB so it has zero test/fake registrations for production use
    if os.path.exists(DB_PATH):
        try:
            os.remove(DB_PATH)
        except Exception:
            pass
    init_db()

    conn = get_connection()
    c = conn.cursor()
    c.execute("SELECT COUNT(*) FROM land_registrations")
    l_cnt = c.fetchone()[0]
    c.execute("SELECT COUNT(*) FROM worker_registrations")
    w_cnt = c.fetchone()[0]
    conn.close()

    assert l_cnt == 0
    assert w_cnt == 0
    print("[PASS] [Requirement 6 Verification] DB reset to clean empty state (0 land records, 0 worker records)")
    passed += 1

    print("=" * 60)
    print(f"TEST SUMMARY: {passed} PASSED, {failed} FAILED")
    print("=" * 60)

    if failed > 0:
        sys.exit(1)

if __name__ == "__main__":
    run_all_tests()

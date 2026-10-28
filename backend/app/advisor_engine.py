from typing import List, Dict, Any
from app.data.crops import CROPS_DATA
from app.data.qa_knowledge import QA_DATABASE, DEFAULT_QA_RESPONSE
from app.schemas import CropAdvisorResponse, CropRecommendation, AdvisorQueryResponse

def get_recommendations(state: str, season: str, soil: str, water: str) -> CropAdvisorResponse:
    # Normalize season name
    season_lower = season.lower()
    selected_season = "Rabi"
    if "kharif" in season_lower:
        selected_season = "Kharif"
    elif "zaid" in season_lower or "summer" in season_lower:
        selected_season = "Zaid"
    elif "rabi" in season_lower or "winter" in season_lower:
        selected_season = "Rabi"

    scored_crops = []
    
    for crop in CROPS_DATA:
        score = 0
        # Season matching (most critical)
        if selected_season in crop["seasons"]:
            score += 40
        else:
            continue  # Crop not suitable for this season
            
        # State matching
        state_matched = any(s.lower() in state.lower() or state.lower() in s.lower() for s in crop["states"])
        if state_matched:
            score += 25
            
        # Soil matching
        soil_matched = any(s.lower() in soil.lower() or soil.lower() in s.lower() for s in crop["soils"])
        if soil_matched:
            score += 20
        elif "alluvial" in soil.lower() or "loam" in soil.lower():
            score += 10
            
        # Water matching
        water_lower = water.lower()
        if "high" in water_lower or "assured" in water_lower:
            if "High" in crop["water_levels"]:
                score += 15
            elif "Medium" in crop["water_levels"]:
                score += 10
        elif "medium" in water_lower:
            if "Medium" in crop["water_levels"]:
                score += 15
            elif "Low" in crop["water_levels"]:
                score += 10
        elif "low" in water_lower or "rainfed" in water_lower:
            if "Low" in crop["water_levels"]:
                score += 20
            elif "Medium" in crop["water_levels"]:
                score += 5

        scored_crops.append((score, crop))

    # Sort descending by score
    scored_crops.sort(key=lambda x: x[0], reverse=True)
    
    # If fewer than 2 matched, fallback to crops in the season
    if len(scored_crops) < 2:
        for crop in CROPS_DATA:
            if selected_season in crop["seasons"] and not any(c["id"] == crop["id"] for _, c in scored_crops):
                scored_crops.append((10, crop))
                
    top_matches = scored_crops[:4]
    
    crop_recs: List[CropRecommendation] = []
    for idx, (score, c) in enumerate(top_matches):
        crop_recs.append(CropRecommendation(
            name=c["name"],
            name_hi=c["name_hi"],
            variety=c["variety"],
            category=c["category"],
            category_hi=c["category_hi"],
            season_window=c["season_window"],
            suitability=c["suitability"],
            duration=c["duration"],
            est_yield=c["est_yield"],
            est_profit=c["est_profit"],
            key_advice=c["key_advice"],
            key_advice_hi=c["key_advice_hi"],
            is_top_pick=(idx == 0)
        ))

    # Summary text
    top_crop_name = crop_recs[0].name.split("(")[0].strip() if crop_recs else "recommended crops"
    top_crop_name_hi = crop_recs[0].name_hi.split("(")[0].strip() if crop_recs else "फसल"
    
    summary = (
        f"Based on your {soil} in {state} with {water} during {selected_season}, "
        f"{top_crop_name} is the optimal choice offering exceptional net profit potential with minimal downside risk."
    )
    summary_hi = (
        f"{state} में {selected_season} सत्र, {soil} एवं {water} की स्थिति को देखते हुए, "
        f"{top_crop_name_hi} सबसे उपयुक्त विकल्प है जो न्यूनतम जोखिम में अधिकतम शुद्ध लाभ प्रदान करता है।"
    )

    best_practices = [
        "Conduct a certified soil pH and micronutrient test before field preparation.",
        "Use certified high-yield seeds with >90% tested germination rate.",
        "Construct robust field bunds (मेड़बंदी) to prevent runoff and retain moisture.",
        "Assign local skilled workers via the Agribridge tracker for timely sowing and weeding."
    ]

    best_practices_hi = [
        "खेत की तैयारी से पूर्व प्रमाणित प्रयोगशाला से मिट्टी का pH व सूक्ष्म पोषक तत्व परीक्षण कराएं।",
        "90% से अधिक अंकुरण क्षमता वाले प्रमाणित एवं उपचारित बीजों का ही उपयोग करें।",
        "खेत में नमी संचयन और वर्षा जल रोकने हेतु मजबूत मेड़बंदी (Field Bunds) बनाएं।",
        "समय पर बुवाई, निराई व सिंचाई सुनिश्चित करने हेतु खेतसेतु ट्रैकर से स्थानीय कुशल श्रमिक जोड़ें।"
    ]

    return CropAdvisorResponse(
        summary=summary,
        summary_hi=summary_hi,
        crops=crop_recs,
        best_practices=best_practices,
        best_practices_hi=best_practices_hi
    )

def query_advisor(question: str) -> AdvisorQueryResponse:
    q_lower = question.lower().strip()
    
    for item in QA_DATABASE:
        for kw in item["keywords"]:
            if kw.lower() in q_lower:
                return AdvisorQueryResponse(
                    title=item["title"],
                    verified_label=item["verified_label"],
                    answer=item["answer"],
                    answer_hi=item["answer_hi"],
                    tags=item["tags"]
                )
                
    return AdvisorQueryResponse(
        title=DEFAULT_QA_RESPONSE["title"],
        verified_label=DEFAULT_QA_RESPONSE["verified_label"],
        answer=DEFAULT_QA_RESPONSE["answer"],
        answer_hi=DEFAULT_QA_RESPONSE["answer_hi"],
        tags=DEFAULT_QA_RESPONSE["tags"]
    )

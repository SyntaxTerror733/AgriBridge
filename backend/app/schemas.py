from pydantic import BaseModel, Field, field_validator
import re
from typing import Optional, List, Dict, Any

def validate_phone_number(v: str) -> str:
    cleaned = re.sub(r"[^\d]", "", v)
    if len(cleaned) == 12 and cleaned.startswith("91"):
        cleaned = cleaned[2:]
    elif len(cleaned) == 11 and cleaned.startswith("0"):
        cleaned = cleaned[1:]
    if len(cleaned) != 10:
        raise ValueError("Mobile number must be a 10-digit number (e.g. 9876543210)")
    return cleaned

class LandRegisterRequest(BaseModel):
    name: str = Field(..., min_length=2, description="Landowner full name")
    phone: str = Field(..., description="10-digit mobile number")
    city: str = Field(..., min_length=2, description="City where landowner resides")
    state: str = Field(..., min_length=2, description="State where land is located")
    district: str = Field(..., min_length=2, description="District where land is located")
    village: str = Field(..., min_length=2, description="Village or nearest town")
    size: float = Field(..., gt=0, description="Land size number")
    unit: str = Field(default="Acre", description="Unit of measurement (Acre, Bigha, Guntha, Hectare)")
    water_source: str = Field(default="Borewell", description="Borewell, Canal, Rainfed, Tubewell, Pond/River")
    notes: Optional[str] = Field(default="", description="Optional additional information")

    @field_validator("phone")
    def check_phone(cls, v):
        return validate_phone_number(v)

class LandResponse(BaseModel):
    id: int
    reference_no: str
    name: str
    phone: str
    city: str
    state: str
    district: str
    village: str
    size: float
    unit: str
    water_source: str
    notes: Optional[str]
    status: str
    created_at: str

class WorkerRegisterRequest(BaseModel):
    name: str = Field(..., min_length=2, description="Worker full name")
    phone: str = Field(..., description="10-digit mobile number")
    village: str = Field(..., min_length=2, description="Village or Tehsil")
    skills: List[str] = Field(..., min_items=1, description="Selected skills (e.g. Ploughing, Sowing, etc.)")

    @field_validator("phone")
    def check_phone(cls, v):
        return validate_phone_number(v)

class WorkerResponse(BaseModel):
    id: int
    reference_no: str
    name: str
    phone: str
    village: str
    skills: List[str]
    status: str
    created_at: str

class CropAdvisorRequest(BaseModel):
    state: str
    season: str
    soil: str
    water: str

class CropRecommendation(BaseModel):
    name: str
    name_hi: str
    variety: str
    category: str
    category_hi: str
    season_window: str
    suitability: str
    duration: str
    est_yield: str
    est_profit: str
    key_advice: str
    key_advice_hi: str
    is_top_pick: bool = False

class CropAdvisorResponse(BaseModel):
    summary: str
    summary_hi: str
    crops: List[CropRecommendation]
    best_practices: List[str]
    best_practices_hi: List[str]

class AdvisorQueryRequest(BaseModel):
    question: str

class AdvisorQueryResponse(BaseModel):
    title: str
    verified_label: str
    answer: str
    answer_hi: str
    tags: List[str]

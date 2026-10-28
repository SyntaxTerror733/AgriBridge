"""
Agro Advisor Q&A knowledge base for keyword and semantic matching.
"""

QA_DATABASE = [
    {
        "keywords": ["after mustard", "mustard rotation", "सरसों के बाद", "crop after mustard"],
        "title": "Agronomy Engine Advisory",
        "verified_label": "Verified guidance",
        "answer": "After harvesting mustard in February-March, the field is vacated early. The best options are short-duration Zaid crops: 1) Summer Moong (Pusa Vishal, 60 days) to fix nitrogen for subsequent crops; 2) Hybrid Spring Maize or Sweet Corn for quick cash flow; or 3) Riverbed/Trellis Cucurbits (Watermelon / Cucumber) if assured irrigation is available.",
        "answer_hi": "फरवरी-मार्च में सरसों कटाई के बाद खेत जल्दी खाली हो जाता है। सर्वोत्तम विकल्प जायद फसलें हैं: 1) ग्रीष्मकालीन मूंग (पूसा विशाल, 60 दिन) जो मिट्टी में नाइट्रोजन बढ़ाती है; 2) बसंतकालीन संकर मक्का या स्वीट कॉर्न; या 3) यदि पर्याप्त पानी उपलब्ध है तो तरबूज / खीरा।",
        "tags": ["#CropRotation / फसल चक्र", "#Oilseeds / तिलहन", "#ZaidFarming / जायद", "#Agribridge Crop Guide"]
    },
    {
        "keywords": ["first irrigation", "wheat irrigation", "गेहूं की पहली सिंचाई", "irrigate wheat", "cri"],
        "title": "Agronomy Engine Advisory",
        "verified_label": "Verified guidance",
        "answer": "The first irrigation in wheat is the single most critical agronomic intervention. It must be provided at the Crown Root Initiation (CRI) stage, exactly 20 to 22 days after sowing in normal soils (18-20 days in light sandy soils). Delaying this irrigation permanently stunts root establishment and reduces tiller count by up to 25-30%.",
        "answer_hi": "गेहूं में पहली सिंचाई सबसे महत्वपूर्ण होती है। यह सामान्य मिट्टी में बुवाई के ठीक 20 से 22 दिन बाद (रेतीली मिट्टी में 18-20 दिन) क्राउन रूट (CRI) अवस्था में दी जानी चाहिए। इस सिंचाई में देरी से जड़ें कमजोर रह जाती हैं और कल्ले 25-30% तक कम हो जाते हैं।",
        "tags": ["#WheatAgronomy / गेहूं प्रबंधन", "#IrrigationSchedule / सिंचाई समय", "#YieldOptimization", "#Agribridge Crop Guide"]
    },
    {
        "keywords": ["low water", "profitable crop with low water", "कम पानी में", "drought", "dryland", "rainfed"],
        "title": "Agronomy Engine Advisory",
        "verified_label": "Verified guidance",
        "answer": "For low water availability, Mustard (Pusa Bold / Giriraj) in Rabi yields high net margins (₹32,000 - ₹46,000/Acre) with only 1-2 light irrigations. In Kharif, Pearl Millet (Bajra) or Cluster Bean (Guar) provide dependable returns with zero supplemental irrigation, while Chickpea (Desi Chana) thrives on residual soil moisture in deep soils.",
        "answer_hi": "कम पानी के लिए, रबी में सरसों (पूसा बोल्ड / गिरिराज) केवल 1-2 हल्की सिंचाइयों में बेहतरीन मुनाफा (₹32,000 - ₹46,000/एकड़) देती है। खरीफ में बाजरा या ग्वार बिना अतिरिक्त सिंचाई के बढ़िया पैदावार देते हैं, जबकि भारी मिट्टी में चना बची हुई नमी पर तैयार हो जाता है।",
        "tags": ["#DrylandFarming / बारानी खेती", "#LowWater / कम पानी", "#HighProfit / अधिक मुनाफा", "#Agribridge Crop Guide"]
    },
    {
        "keywords": ["pest", "aphid", "कीट", "माहू", "spray", "insecticide", "छिड़काव"],
        "title": "Agronomy Engine Advisory",
        "verified_label": "Verified guidance",
        "answer": "For mustard aphid (माहू) and sucking pests in winter crops, install yellow sticky cards (15-20 per acre) as early monitoring. If infestation crosses the 10-15% economic threshold level, spray Dimethoate 30% EC @ 1.5 ml/L or Neem oil 1500 ppm @ 3 ml/L during morning hours.",
        "answer_hi": "सर्दियों की फसलों में माहू (एफिड्स) और रस चूसक कीटों के लिए 15-20 पीले चिपचिपे कार्ड प्रति एकड़ लगाएं। यदि प्रकोप 10-15% से अधिक हो, तो सुबह के समय नीम का तेल (1500 ppm) 3 मिली/लीटर या डाइमेथोएट 30% ईसी 1.5 मिली/लीटर पानी में घोलकर छिड़कें।",
        "tags": ["#PlantProtection / कीट नियंत्रण", "#IPM / एकीकृत कीट प्रबंधन", "#Agribridge Crop Guide"]
    },
    {
        "keywords": ["fertilizer", "soil test", "urea", "dap", "खाद", "उर्वरक", "मिट्टी परीक्षण"],
        "title": "Agronomy Engine Advisory",
        "verified_label": "Verified guidance",
        "answer": "Always test soil electrical conductivity (EC), organic carbon, and pH before applying basal nutrients. Do not apply entire Nitrogen at sowing; apply Phosphorous and Potash (DAP/MOP) as basal dose, and split Urea into 2-3 top dressings synchronized with critical irrigation cycles.",
        "answer_hi": "बुवाई से पहले मिट्टी की जांच (pH, आर्गेनिक कार्बन) जरूर कराएं। पूरी नाइट्रोजन बुवाई के समय न डालें; डीएपी और पोटाश को बेसल खुराक के रूप में दें और यूरिया को 2-3 बार सिंचाई के साथ टॉप ड्रेसिंग के रूप में दें।",
        "tags": ["#SoilHealth / मृदा स्वास्थ्य", "#NutrientManagement / पोषण प्रबंधन", "#Agribridge Crop Guide"]
    }
]

DEFAULT_QA_RESPONSE = {
    "title": "Agronomy Engine Advisory",
    "verified_label": "Verified guidance",
    "answer": "For optimal agricultural output on this plot, ensure certified seed selection, strict crop rotation with leguminous pulses, and precision irrigation via drip or sprinkler methods. Coordinate with your local Agribridge field manager for tailored input schedules.",
    "answer_hi": "इस खेत से अधिकतम उपज के लिए, प्रमाणित बीजों का चयन करें, दलहनी फसलों के साथ चक्र अपनाएं और ड्रिप या फव्वारा विधि से सूक्ष्म सिंचाई करें। उचित खाद व दवा की जानकारी के लिए अपने स्थानीय खेतसेतु फील्ड मैनेजर से संपर्क करें।",
    "tags": ["#AgribridgeAdvisory / कृषि सलाह", "#PrecisionFarming / सटीक खेती", "#Agribridge Crop Guide"]
}

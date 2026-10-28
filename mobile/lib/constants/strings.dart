class AppStrings {
  static bool isHindi = false;

  static String tr(String en, String hi) => isHindi ? hi : en;

  // App Title
  static String get appName => tr("Agribridge", "खेतसेतु");
  static String get appTagline => tr("Remote farming made simple.", "घर बैठे खेती, अब हुई आसान।");
  static String get farmFromAnywhere => tr("Farm from anywhere", "कहीं से भी करें खेती");

  // Top Nav & Menu
  static String get menuHowItWorks => tr("How it works", "यह कैसे काम करता है");
  static String get menuServices => tr("Services", "सेवाएं");
  static String get menuCropAdvisor => tr("Crop Advisor", "फसल सलाहकार");
  static String get menuForWorkers => tr("For workers", "श्रमिकों के लिए");
  static String get menuTrackStatus => tr("Track Status", "स्थिति ट्रैक करें");
  static String get registerLandBtn => tr("Register land", "जमीन जोड़ें");

  // Hero Section
  static String get heroHeadline => tr("Own land in the village?\nWe'll farm it for you.", "गांव में जमीन है?\nखेती हम करेंगे आपके लिए।");
  static String get heroSubtext => tr(
    "Tell us where your land is and how big it is. Agribridge handles crops, inputs, local labour, irrigation and harvest, and you follow every step on your phone.",
    "हमें बताएं आपकी जमीन कहां है और कितनी बड़ी है। खेतसेतु फसल, बीज, स्थानीय मजदूर, सिंचाई और कटाई सब संभालता है, और आप हर कदम अपने फोन पर देख सकते हैं।"
  );
  static String get registerYourLandBtn => tr("Register your land", "अपनी जमीन पंजीकृत करें");
  static String get imAFarmWorkerBtn => tr("I'm a farm worker", "मैं कृषि श्रमिक हूँ");

  // 3 Hero Value Cards
  static String get heroCard1Title => tr("Your share", "आपकी उपज का हिस्सा");
  static String get heroCard1Desc => tr("Direct bank transfer or delivery of crop after harvest.", "कटाई के बाद सीधे बैंक खाते में भुगतान या फसल की डिलीवरी।");

  static String get heroCard2Title => tr("You see", "पारदर्शी निगरानी");
  static String get heroCard2Desc => tr("Photos, field notes and expense tracker in the app.", "ऐप में खेत की तस्वीरें, फील्ड नोट्स और खर्चों का पूरा हिसाब।");

  static String get heroCard3Title => tr("Villages gain", "गांव की समृद्धि");
  static String get heroCard3Desc => tr("Fair, guaranteed wages for skilled rural workforce.", "स्थानीय कुशल श्रमिकों को निष्पक्ष और समय पर पक्की मजदूरी।");

  // Process Section
  static String get processTitle => tr("From your first call to your first harvest", "पहली कॉल से पहली कटाई तक");
  static String get process1Title => tr("Share your plot", "खेत की जानकारी दें");
  static String get process1Desc => tr("Send land size, location and ownership papers through the app.", "ऐप के जरिए जमीन का आकार, स्थान और दस्तावेज साझा करें।");

  static String get process2Title => tr("We visit and plan", "निरीक्षण और योजना");
  static String get process2Desc => tr("Our team checks the land and recommends crops that suit the soil and water.", "हमारी टीम खेत का मुआयना कर मिट्टी और पानी के अनुसार फसल तय करती है।");

  static String get process3Title => tr("We farm, you watch", "हम खेती करेंगे, आप देखें");
  static String get process3Desc => tr("Local workers sow, irrigate and harvest. You get photos and an expense ledger.", "स्थानीय मजदूर बुवाई, सिंचाई और कटाई करेंगे। आपको तस्वीरें और खाता मिलेगा।");

  static String get process4Title => tr("Harvest and your share", "कटाई और आपका हिस्सा");
  static String get process4Desc => tr("Receive your share of the crop, after agreed costs and our service charge.", "तय लागत व सेवा शुल्क घटाकर अपनी उपज का हिस्सा प्राप्त करें।");

  // Services Section
  static String get servicesTitle => tr("Everything the land needs, handled", "जमीन की हर जरूरत, हमारी जिम्मेदारी");
  static String get servicesSubtitle => tr("One team, one account, one place to see what is happening on your plot.", "एक टीम, एक खाता, आपके खेत पर हो रहे हर काम की एक जगह निगरानी।");

  static String get service1Title => tr("Crop selection", "फसल चयन");
  static String get service1Desc => tr("Right seeds matched to your soil type and season.", "मिट्टी और मौसम के अनुसार सर्वोत्तम प्रमाणित बीज।");

  static String get service2Title => tr("Seeds and inputs", "बीज और खाद");
  static String get service2Desc => tr("Wholesale procurement of certified seeds & fertilizers.", "प्रमाणित बीज, जैविक खाद व उर्वरक थोक मूल्य पर।");

  static String get service3Title => tr("Labour", "कुशल श्रमिक");
  static String get service3Desc => tr("Verified village farm teams with fair wages.", "सत्यापित स्थानीय श्रमिक जिन्हें मिलता है उचित पारिश्रमिक।");

  static String get service4Title => tr("Irrigation", "सिंचाई प्रबंधन");
  static String get service4Desc => tr("Managed water schedule for optimal crop health.", "फसल की जरूरत अनुसार तय समय पर सही सिंचाई।");

  static String get service5Title => tr("Harvest", "कटाई और भंडारण");
  static String get service5Desc => tr("Mechanical harvesting, grading and packaging.", "आधुनिक मशीनों से कटाई, छंटाई और सुरक्षित पैकिंग।");

  static String get service6Title => tr("Updates", "डिजिटल अपडेट");
  static String get service6Desc => tr("Weekly photo reports and transparent ledgers.", "साप्ताहिक फोटो रिपोर्ट और पारदर्शी डिजिटल हिसाब।");

  // Crop Advisor
  static String get advisorTitle => tr("Smart Crop Advisor", "स्मार्ट फसल सलाहकार");
  static String get advisorSubtitle => tr("Tailored agronomic recommendations based on your soil type, season, and water access.", "आपकी मिट्टी, मौसम और पानी की उपलब्धता के आधार पर सटीक कृषि सलाह।");
  static String get configurePlot => tr("Configure Your Plot", "अपने खेत का विवरण चुनें");
  static String get stateRegion => tr("State / Region", "राज्य / क्षेत्र");
  static String get cultivationSeason => tr("Cultivation Season", "फसल का मौसम (सत्र)");
  static String get soilTexture => tr("Soil Texture", "मिट्टी का प्रकार");
  static String get waterAvailability => tr("Water Availability", "पानी की उपलब्धता");
  static String get getRecommendationsBtn => tr("Get Crop Recommendations", "फसल अनुशंसाएं प्राप्त करें");

  static String get advisorSummary => tr("Advisor Summary", "सलाहकार सारांश");
  static String get highSuitability => tr("✓ High Suitability", "✓ अति उपयुक्त");
  static String get duration => tr("Duration", "अवधि");
  static String get estYield => tr("Est. Yield", "अनुमानित उपज");
  static String get estProfit => tr("Est. Net Profit", "अनुमानित शुद्ध लाभ");
  static String get keyAdviceLabel => tr("Key Agricultural Advice:", "मुख्य कृषि परामर्श:");

  static String get bestPracticesTitle => tr("Recommended Best Practices for this Plot", "इस खेत के लिए अनुशंसित सर्वोत्तम कृषि पद्धतियां");

  static String get askAdvisorTitle => tr("Ask the Agro Advisor", "कृषि सलाहकार से पूछें");
  static String get askAdvisorHint => tr("Ask about crops, sowing dates, fertilizers, pests...", "फसल, बुवाई की तारीख, खाद या कीट नियंत्रण के बारे में पूछें...");
  static String get askQuestionBtn => tr("Ask Question", "प्रश्न पूछें");
  static String get engineAdvisoryTitle => tr("Agronomy Engine Advisory", "एग्रोनॉमी इंजन परामर्श");
  static String get verifiedGuidance => tr("Verified guidance", "सत्यापित मार्गदर्शन");

  // Worker Section
  static String get workerSectionTitle => tr("Farm workers: join our village teams", "कृषि श्रमिक: हमारी ग्रामीण टीम से जुड़ें");
  static String get workerCard1Title => tr("Work near home", "घर के पास काम");
  static String get workerCard1Desc => tr("Get farming jobs in your own or neighboring villages.", "अपने ही गांव या आसपास के खेतों में काम पाएं।");

  static String get workerCard2Title => tr("Clear wages", "समय पर पक्की मजदूरी");
  static String get workerCard2Desc => tr("Transparent weekly payouts directly in cash or bank.", "पारदर्शी साप्ताहिक भुगतान सीधे नकद या खाते में।");

  static String get workerCard3Title => tr("Your skills count", "हुनर की पहचान");
  static String get workerCard3Desc => tr("Tractor driving, spraying, sowing and harvesting valued.", "ट्रैक्टर ड्राइविंग, दवा छिड़काव, बुवाई व कटाई का सम्मान।");

  static String get registerAsWorkerBtn => tr("Register as a worker", "श्रमिक के रूप में जुड़ें");

  // Footer
  static String get footerTitle => tr("Agribridge: remote farming made simple.", "खेतसेतु: दूर बैठे खेती, अब हुई आसान।");
  static String get footerDesc => tr("Production-ready agricultural bridge connecting city owners with rural strength.", "शहर में रहने वाले जमीन मालिकों को गांव के कुशल श्रम से जोड़ने वाला डिजिटल सेतु।");

  // Land Registration Form
  static String get regLandTitle => tr("Register your land", "अपनी जमीन पंजीकृत करें");
  static String get regLandSubtitle => tr("Takes about two minutes. Our team calls you within 2 working days.", "सिर्फ दो मिनट लगेंगे। हमारी टीम 2 कार्य दिवसों में आपसे संपर्क करेगी।");
  static String get yourName => tr("Your name", "आपका पूरा नाम");
  static String get mobileNumber => tr("Mobile number", "मोबाइल नंबर");
  static String get mobilePlaceholder => tr("10-digit number (e.g. 9876543210)", "10 अंकों का नंबर (उदा. 9876543210)");
  static String get yourCity => tr("Your city (where you live)", "आपका शहर (जहां आप रहते हैं)");
  static String get stateWhereLandIs => tr("State (where land is)", "राज्य (जहां जमीन है)");
  static String get district => tr("District", "जिला");
  static String get villageOrTown => tr("Village or nearest town", "गांव या निकटतम कस्बा");
  static String get landSize => tr("Land size", "जमीन का आकार");
  static String get unit => tr("Unit", "इकाई");
  static String get waterSource => tr("Water source", "पानी का स्रोत");
  static String get optionalNotes => tr("Anything else we should know (optional)", "कोई अन्य जानकारी (वैकल्पिक)");
  static String get sendLandDetailsBtn => tr("Send my land details", "जमीन का विवरण भेजें");

  // Land Success Screen
  static String get requestReceived => tr("Request received", "अनुरोध प्राप्त हुआ");
  static String get keepRefNumber => tr("Keep this reference number to follow up with us anytime.", "भविष्य में स्थिति जानने के लिए यह संदर्भ संख्या संभाल कर रखें।");
  static String get step1Submitted => tr("Details submitted", "विवरण जमा किया गया");
  static String get step2Docs => tr("Documents verified", "दस्तावेज सत्यापित");
  static String get step3Visit => tr("Site visit scheduled", "खेत मुआयना निर्धारित");
  static String get step4Plan => tr("Plan and quote shared", "योजना और कोटेशन साझा");
  static String get closeBtn => tr("Close", "बंद करें");

  // Worker Portal Form
  static String get workerPortalPill => tr("Worker portal", "श्रमिक पोर्टल");
  static String get step1Title => tr("First, tell us about you", "पहले, अपने बारे में बताएं");
  static String get workerNamePlaceholder => tr("e.g. Ramesh Kumar / रमेश कुमार", "उदा. रमेश कुमार / Ramesh Kumar");
  static String get villagePlaceholder => tr("e.g. Bilaspur / बिलासपुर", "उदा. बिलासपुर / Bilaspur");
  static String get nextBtn => tr("Next", "आगे बढ़ें");

  static String get step2Title => tr("Tap the work you can do", "वह काम चुनें जो आप कर सकते हैं");
  static String get backBtn => tr("Back", "पीछे");

  // Skills
  static String get skillPloughing => tr("Ploughing", "जुताई");
  static String get skillSowing => tr("Sowing", "बुवाई");
  static String get skillIrrigation => tr("Irrigation", "सिंचाई");
  static String get skillHarvesting => tr("Harvesting", "कटाई");
  static String get skillTractorDriving => tr("Tractor driving", "ट्रैक्टर चलाना");
  static String get skillSpraying => tr("Spraying", "दवा छिड़काव");

  // Worker Success
  static String get youAreRegistered => tr("You're registered", "आपका पंजीकरण हो गया है");
  static String get workerCoordinatorCall => tr("Our field coordinator will call you to verify your details and share the first job.", "हमारे फील्ड समन्वयक विवरण सत्यापित करने और पहला काम देने के लिए आपसे संपर्क करेंगे।");

  // Track Status
  static String get trackStatusTitle => tr("Track Your Registration", "पंजीकरण की स्थिति जांचें");
  static String get trackStatusSubtitle => tr("Enter your 10-digit mobile number or Reference ID (LAND-XXXXX / WORK-XXXXX)", "अपना 10 अंकों का मोबाइल नंबर या संदर्भ संख्या (LAND-XXXXX / WORK-XXXXX) दर्ज करें");
  static String get searchBtn => tr("Track Now", "स्थिति देखें");
  static String get trackInputPlaceholder => tr("e.g. 9876543210 or LAND-FC6LM", "उदा. 9876543210 या LAND-FC6LM");

  // Error States & Validation
  static String get enterValidPhone => tr("Please enter a valid 10-digit mobile number", "कृपया 10 अंकों का मान्य मोबाइल नंबर दर्ज करें");
  static String get fillRequiredFields => tr("Please fill all required fields", "कृपया सभी आवश्यक जानकारी भरें");
  static String get selectAtLeastOneSkill => tr("Please select at least one skill", "कृपया कम से कम एक काम (हुनर) चुनें");
  static String get serverConnectionError => tr("Unable to connect to the Agribridge server. Please ensure the backend is running at http://10.0.2.2:8000.", "खेतसेतु सर्वर से संपर्क नहीं हो सका। कृपया जांचें कि बैकएंड http://10.0.2.2:8000 पर चालू है।");
  static String get retryBtn => tr("Retry", "पुनः प्रयास करें");
  static String get noRecordFound => tr("No registration found with this Reference ID or Phone number.", "इस संदर्भ संख्या या फोन नंबर से कोई पंजीकरण नहीं मिला।");
}

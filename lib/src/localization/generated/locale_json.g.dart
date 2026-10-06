// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "name": "Ayman Elslamony",
  "description": "Senior Flutter Developer",
  "subDescription": "18+ Apps Shipped · Clean Architecture · CI/CD",
  "contacts": [
    {
      "tooltip": "LinkedIn",
      "url": "https://www.linkedin.com/in/ayman-elslamony",
      "iconCodePoint": "0xf08c",
      "iconFontFamily": "FontAwesomeBrands",
      "iconFontPackage": "font_awesome_flutter"
    },
    {
      "tooltip": "Github",
      "url": "https://github.com/ayman-elslamony",
      "iconCodePoint": "0xf09b",
      "iconFontFamily": "FontAwesomeBrands",
      "iconFontPackage": "font_awesome_flutter"
    },
    {
      "tooltip": "aymanelslamony17@gmail.com",
      "url": "mailto:aymanelslamony17@gmail.com",
      "iconCodePoint": "0xf0e0",
      "iconFontFamily": "FontAwesomeSolid",
      "iconFontPackage": "font_awesome_flutter"
    },
    {
      "tooltip": "(+20) 155 284 4195",
      "url": "tel:+201552844195",
      "iconCodePoint": "0xf095",
      "iconFontFamily": "FontAwesomeSolid",
      "iconFontPackage": "font_awesome_flutter"
    },
    {
      "tooltip": "WhatsApp",
      "url": "https://wa.me/201552844195?text=Hi%20Ayman%2C%20I%20came%20across%20your%20portfolio%20and%20would%20like%20to%20talk%20about%20a%20Flutter%20role.",
      "iconCodePoint": "0xf232",
      "iconFontFamily": "FontAwesomeBrands",
      "iconFontPackage": "font_awesome_flutter"
    }
  ],
  "resumes": [
    {
      "languageCode": "en",
      "url": "cv/Ayman_Elslamony_Senior_Flutter_Developer_CV.pdf"
    }
  ],
  "aboutDescription": "Senior Flutter Developer with 5+ years of experience building Android and iOS apps — and the shared architecture, automated checks, and release pipelines the team's apps are built on.\n\nWhat makes my profile different:\n\n→ Designed the shared architecture two apps now run on — navigation, network and state code live in one versioned package instead of being copied into each app, so one fix reaches every app through a reviewed upgrade.\n\n→ Extended it into an internal developer toolchain — automated code-quality checks enforced before every commit, plus a checker that verifies what the app expects from the API against what the backend actually returns.\n\n→ Built a Figma-to-code design pipeline — colours, spacing, typography and icons are regenerated from the design file, so a design change reaches the app as generated code instead of values re-typed by hand.\n\n→ Created the team's AI engineering workflow — reusable AI skills, agent definitions and a plan-review-execute process, with the same automated checks holding every change, agent-written included, to the architecture rules.\n\n→ Built a multi-tenant White-Label SDK — one Flutter codebase serving multiple enterprise clients, each with their own branding, backend, and store listing. Zero code duplication.\n\n→ Published a native iOS/Android Flutter Plugin on Pub.dev (HyperPay payment bridge via Platform Channels).\n\n→ Architected a full CI/CD release pipeline (GitHub Actions + Azure Pipelines + Fastlane + Firebase App Distribution) — cut release cycles by 15%.\n\n→ Built an internal Network Inspector tool giving QA and backend teams real-time API visibility — eliminated false escalations between teams.\n\n→ Delivered 18+ production applications across e-commerce, healthcare, and logistics.",
  "experiences": [
    {
      "job": "Senior Flutter Developer",
      "company": "Excellent Protection",
      "description": "- Designed the shared architecture two apps now run on: navigation, network and state code in one versioned package instead of copied per app — one fix reaches every app through a reviewed upgrade.\n- Extended it into an internal developer toolchain: automated code-quality checks enforced before every commit, plus a checker that verifies what the app expects from the API against what the backend returns.\n- Built a Figma-to-code design pipeline — colours, spacing, typography and icons regenerated from the design file instead of re-typed by hand.\n- Introduced automated testing across the app and shared packages: unit, widget and cubit-state tests plus mock repositories.\n- Created the team's AI engineering workflow: reusable AI skills, agent definitions and a plan-review-execute process, with the same automated checks holding every change — agent-written included — to the architecture rules.\n- Designed and shipped a multi-tenant White-Label SDK: one Flutter codebase serving multiple enterprise clients with per-client branding, backend, and store listing — eliminated duplicate codebases.\n- Built an internal Network Inspector tool for real-time API debugging, reducing false escalations between mobile and backend teams.\n- Architected full CI/CD pipeline: GitHub Actions + Azure Pipelines + Fastlane + Firebase App Distribution with SDK caching — release cycles ↓ 15%.\n- Established coding standards and code-review discipline — blocking defects separated from suggestions on every pull request; post-release bugs ↓ 30%.\n- Mentored 2 junior developers.\n- Shipped customer-facing features across the company's booking and services apps — hourly and package-based booking, order tracking, payments, and a loyalty programme — including a payment-gateway migration (HyperPay → Paymob) that replaced three duplicated card-payment flows with one.",
      "isPresent": true,
      "startYear": 2023,
      "startMonth": 1,
      "technologies": [
        "Flutter",
        "Dart",
        "CI/CD",
        "GitHub Actions",
        "Azure DevOps",
        "Fastlane",
        "White-Label SDK",
        "Platform Channels",
        "SOLID",
        "Sentry",
        "Firebase Crashlytics",
        "Melos",
        "go_router",
        "Design Tokens",
        "Testing",
        "Biometric Auth",
        "Claude Code",
        "Paymob"
      ]
    },
    {
      "job": "Senior Flutter Developer (Contract)",
      "company": "Meta Shops",
      "description": "- Built and deployed 3+ Flutter apps for clients, gathering their requirements and turning them into features.\n- Refactored a legacy codebase using Clean Architecture, improving maintainability.\n- Engineered and delivered a key geo-fenced student attendance feature.",
      "startYear": 2025,
      "startMonth": 1,
      "endYear": 2025,
      "endMonth": 5,
      "technologies": [
        "Flutter",
        "Dart",
        "Clean Architecture",
        "Geofencing",
        "Google Maps API",
        "iOS Development"
      ]
    },
    {
      "job": "Mid-level Flutter Developer",
      "company": "Excellent Protection",
      "description": "- Developed and launched over 8 of the company's 11+ mobile applications.\n- Translated Figma prototypes into responsive, high-performance UIs.\n- Collaborated with backend teams to design and integrate critical RESTful APIs.",
      "startYear": 2022,
      "startMonth": 3,
      "endYear": 2022,
      "endMonth": 12,
      "technologies": [
        "Flutter",
        "Dart",
        "Bloc",
        "Provider",
        "GetX",
        "RESTful APIs",
        "Firebase Analytics"
      ]
    },
    {
      "job": "Flutter Developer (Freelancer)",
      "company": "Remote",
      "description": "- Managed end-to-end development for 6+ client apps with 95% on-time delivery.\n- Architected apps from scratch using modern state management (Bloc/Provider).",
      "startYear": 2020,
      "startMonth": 3,
      "endYear": 2020,
      "endMonth": 9,
      "technologies": [
        "Flutter",
        "Dart",
        "Firebase",
        "Google Maps",
        "RESTful APIs",
        "State Management"
      ]
    }
  ],
  "present": "Present",
  "projects": [
    {
      "name": "Shared Flutter Architecture & Internal Toolchain",
      "description": "A versioned core package and a copy-in scaffold two apps are built on, plus the toolchain around them: a Figma-to-code design pipeline and automated code-quality checks enforced before every commit.",
      "screenshotPath": "assets/images/shared_architecture.png",
      "technologies": [
        "Flutter",
        "Dart",
        "Melos",
        "Monorepo",
        "Design Tokens",
        "Code Review",
        "Testing",
        "CI/CD"
      ],
      "caseStudy": {
        "slug": "shared-architecture",
        "problem": "Each app carried its own copy of the same infrastructure: navigation, the network layer, error handling, the state base classes. The copies drifted apart. None of them was wrong, and no two were the same. A fix in one app reached no other app, and a developer who found a real bug had nowhere to put the fix except a local workaround.",
        "built": [
          {
            "title": "One versioned core package",
            "text": "The code every app needs and none should own a private copy of lives in one package: navigation, network, errors, state base classes, the responsive layer, the auth session and internationalisation. Each app pins it by release tag, so adopting a new version is a one-line edit that lands in a reviewed diff instead of arriving silently."
          },
          {
            "title": "A clear dividing rule",
            "text": "Pure, brand-free code is shared. Anything that touches an app's generated design tokens is not, because a package cannot import its consumer's generated code, so widgets stay owned by each app in a copy-in scaffold. Heavy native SDKs such as Firebase and biometrics get packages of their own, so an app that does not use them does not ship them."
          },
          {
            "title": "An internal developer toolchain",
            "text": "A command-line tool, pinned like any other dependency, groups the work into design, quality, backend and release commands. It runs 11 automated code-quality checks before every commit, and verifies what the app expects from the API against what the backend actually returns."
          },
          {
            "title": "A Figma-to-code design pipeline",
            "text": "Colours, spacing, typography and icons are regenerated from the design file, so a design change reaches the app as generated code instead of values re-typed by hand and drifting."
          }
        ],
        "result": "Two apps now run on the shared architecture. A fix is written once and reaches every app through a reviewed upgrade, and the architecture rules are checked at commit time instead of in review."
      }
    },
    {
      "name": "Network Inspector & Runtime Config Editor",
      "description": "A QA-facing debugging package: separates backend from frontend failures, exports cURL and session bundles into bug reports, and switches base URL, tenant, and payment mode at runtime.",
      "screenshotPath": "assets/images/network_inspector.png",
      "technologies": [
        "Flutter",
        "Dart",
        "Dio",
        "HTTP",
        "Debugging Tools",
        "QA Tooling",
        "Runtime Configuration"
      ]
    },
    {
      "name": "Belkhidmah (Flutter Application)",
      "description": "An app for booking domestic workers by the hour or by the month from licensed companies, with in-app payment.\nBuilt it end to end on the shared architecture, with Paymob payments and biometric sign-in.",
      "screenshotPath": "assets/images/belkhidmah.png",
      "technologies": [
        "Flutter",
        "Bloc",
        "Clean Architecture",
        "go_router",
        "Paymob",
        "Biometric Auth",
        "Google Maps",
        "Firebase",
        "Design Tokens"
      ]
    },
    {
      "name": "Educational Management Apps",
      "description": "A platform for school administration, academics, and parent-teacher communication.",
      "screenshotPath": "assets/images/educational_management.jpg",
      "technologies": [
        "Provider",
        "Bloc",
        "GetX",
        "Cloud Firestore",
        "RESTful APIs",
        "CI/CD"
      ]
    },
    {
      "name": "Awon (Flutter Application)",
      "description": "An app for booking domestic services by the hour or in packages.\nArchitected the booking engine behind hourly and package-based services, with HyperPay and Tabby payments.",
      "url": "https://play.google.com/store/apps/details?id=com.excprotection.ircmobile",
      "screenshotPath": "assets/images/awon.png",
      "technologies": [
        "Bloc",
        "GetX",
        "HyperPay SDK",
        "Tabby",
        "OneSignal SDK",
        "Firebase"
      ],
      "links": [
        {
          "url": "https://play.google.com/store/apps/details?id=com.excprotection.ircmobile",
          "display": "Google Play"
        },
        {
          "url": "https://apps.apple.com/us/app/awon/id1483782795",
          "display": "App Store"
        }
      ]
    },
    {
      "name": "Rafah (Flutter Application)",
      "description": "An app for booking and scheduling recurring household services like cleaning and laundry.",
      "url": "https://play.google.com/store/apps/details?id=com.hrbs.rafahapp",
      "screenshotPath": "assets/images/rafah_app.png",
      "technologies": [
        "Bloc",
        "HyperPay SDK",
        "Firebase"
      ],
      "links": [
        {
          "url": "https://play.google.com/store/apps/details?id=com.hrbs.rafahapp",
          "display": "Google Play"
        },
        {
          "url": "https://apps.apple.com/us/app/rafah/id6476551030",
          "display": "App Store"
        }
      ]
    },
    {
      "name": "HyperPay (Flutter Plugin)",
      "description": "An open-source plugin for the Flutter community.\nPublished on Pub.dev by bridging the native iOS and Android HyperPay SDKs through Platform Channels.",
      "url": "https://pub.dev/packages/hyperpay_plugin",
      "screenshotPath": "assets/images/hyper_pay.png",
      "technologies": [
        "Open Source",
        "Platform Channels",
        "Native Bridge",
        "Swift",
        "Kotlin"
      ],
      "links": [
        {
          "url": "https://pub.dev/packages/hyperpay_plugin",
          "display": "Pub.dev"
        }
      ]
    },
    {
      "name": "Sraco (Flutter Application)",
      "description": "A platform for booking cleaning professionals for corporate and residential clients.",
      "url": "https://play.google.com/store/apps/details?id=com.excprotection.sracohrapp",
      "screenshotPath": "assets/images/sraco.jpg",
      "technologies": [
        "Bloc",
        "HyperPay SDK",
        "OneSignal SDK",
        "Cloud Firestore"
      ],
      "links": [
        {
          "url": "https://play.google.com/store/apps/details?id=com.excprotection.sracohrapp",
          "display": "Google Play"
        },
        {
          "url": "https://apps.apple.com/us/app/sracohr/id6443454083",
          "display": "App Store"
        }
      ]
    },
    {
      "name": "REFD (Flutter Application)",
      "description": "A household services platform offering cleaning, cooking, and elderly care through package-based bookings.",
      "url": "https://apps.apple.com/us/app/refd/id1665842433",
      "screenshotPath": "assets/images/refd.png",
      "technologies": [
        "Bloc",
        "Google Maps",
        "Cloud Firestore",
        "HyperPay SDK",
        "OneSignal SDK"
      ],
      "links": [
        {
          "url": "https://apps.apple.com/us/app/refd/id1665842433",
          "display": "App Store"
        }
      ]
    },
    {
      "name": "Handaza (Flutter Application)",
      "description": "A content delivery platform providing engineering resources and course materials.",
      "screenshotPath": "assets/images/handaza.png",
      "technologies": [
        "Provider",
        "Video Player SDK"
      ]
    },
    {
      "name": "Driver Package (White-Label SDK)",
      "description": "A reusable White-Label SDK for driver apps — one codebase, multiple enterprise clients. Each client gets their own branding, backend, and store listing.\nEliminated duplicate codebases across clients and enabled real-time fleet tracking.",
      "url": "https://github.com/ayman-elslamony/driver_package",
      "screenshotPath": "assets/images/rafah.png",
      "technologies": [
        "White-Label SDK",
        "Real-time Tracking",
        "Geofencing",
        "Google Maps",
        "OneSignal SDK",
        "Bloc"
      ],
      "links": [
        {
          "url": "https://play.google.com/store/apps/details?id=com.excprotection.sraco_drivers",
          "display": "Sraco Driver"
        },
        {
          "url": "https://play.google.com/store/apps/details?id=com.excprotection.irc_drivers",
          "display": "Awon Driver"
        }
      ]
    },
    {
      "name": "Tadbeer (Flutter Application)",
      "description": "An app for booking household cleaning services and professionals.",
      "url": "https://play.google.com/store/apps/details?id=com.excprotection.tadbeermobile",
      "screenshotPath": "assets/images/tadbeer.jpg",
      "technologies": [
        "Bloc",
        "Google Maps",
        "Cloud Firestore",
        "HyperPay SDK",
        "OneSignal SDK"
      ],
      "links": [
        {
          "url": "https://play.google.com/store/apps/details?id=com.excprotection.tadbeermobile",
          "display": "Google Play"
        },
        {
          "url": "https://apps.apple.com/us/app/tadbeer/id1531299885",
          "display": "App Store"
        }
      ]
    },
    {
      "name": "Enaya (Flutter Application)",
      "description": "An app for booking cleaning professionals for residential clients.",
      "url": "https://apps.apple.com/us/app/enaya/id1491310421",
      "screenshotPath": "assets/images/enaya.jpg",
      "technologies": [
        "Bloc",
        "HyperPay SDK",
        "OneSignal SDK",
        "Cloud Firestore"
      ],
      "links": [
        {
          "url": "https://apps.apple.com/us/app/enaya/id1491310421",
          "display": "App Store"
        }
      ]
    },
    {
      "name": "Tanmya (Flutter Application)",
      "description": "A platform for booking baby care and home maintenance services.",
      "url": "https://apps.apple.com/uy/app/etanmia/id1599240880",
      "screenshotPath": "assets/images/tanmya.jpg",
      "technologies": [
        "HyperPay SDK",
        "OneSignal SDK",
        "Cloud Firestore",
        "Bloc"
      ],
      "links": [
        {
          "url": "https://apps.apple.com/uy/app/etanmia/id1599240880",
          "display": "App Store"
        }
      ]
    },
    {
      "name": "Eau de Milano (E-commerce UI)",
      "description": "An e-commerce store template for browsing products and managing a shopping cart.",
      "url": "https://github.com/ayman-elslamony/eaudemilano",
      "screenshotPath": "assets/images/eaudemilano.png",
      "technologies": [
        "Provider",
        "RESTful APIs",
        "UI/UX"
      ],
      "links": [
        {
          "url": "https://github.com/ayman-elslamony/eaudemilano",
          "display": "GitHub"
        }
      ]
    },
    {
      "name": "Coach Station (Fitness App Concept)",
      "description": "A sports app concept for finding trainers, building diet plans, and connecting with coaches.",
      "url": "https://github.com/ayman-elslamony/coachstation",
      "screenshotPath": "assets/images/coach_station.png",
      "technologies": [
        "Provider",
        "RESTful APIs",
        "Fitness"
      ],
      "links": [
        {
          "url": "https://github.com/ayman-elslamony/coachstation",
          "display": "GitHub"
        }
      ]
    },
    {
      "name": "Es3fni (Healthcare App)",
      "description": "An on-demand healthcare platform for coordinating and scheduling home-care services like nursing and physiotherapy.",
      "url": "https://github.com/ayman-elslamony/Es3fni",
      "screenshotPath": "assets/images/es3fni.png",
      "technologies": [
        "Provider",
        "Google Maps",
        "Cloud Firestore",
        "HealthTech"
      ],
      "links": [
        {
          "url": "https://github.com/ayman-elslamony/Es3fni",
          "display": "GitHub"
        }
      ]
    },
    {
      "name": "Health Book (Healthcare App)",
      "description": "A secure Personal Health Record (PHR) app enabling patients to manage medical data and conduct video consultations.",
      "url": "https://github.com/ayman-elslamony/HealthBookApp",
      "screenshotPath": "assets/images/health_book.png",
      "technologies": [
        "Provider",
        "Agora SDK",
        "Cloud Firestore",
        "PHR",
        "Telemedicine"
      ],
      "links": [
        {
          "url": "https://github.com/ayman-elslamony/HealthBookApp",
          "display": "GitHub"
        }
      ]
    },
    {
      "name": "Check And Chat (Social Commerce App)",
      "description": "A location-based social e-commerce application with user ratings, chat, and community features.",
      "url": "https://github.com/ayman-elslamony/checkAndChat",
      "screenshotPath": "assets/images/check_and_chat.png",
      "technologies": [
        "Provider",
        "Google Maps",
        "Google Places",
        "Cloud Firestore",
        "Social Commerce"
      ],
      "links": [
        {
          "url": "https://github.com/ayman-elslamony/checkAndChat",
          "display": "GitHub"
        }
      ]
    }
  ],
  "languages": [
    {
      "code": "en",
      "name": "English",
      "nativeName": "English"
    }
  ],
  "portfolio": "Portfolio",
  "homeSectionTitle": "Home",
  "aboutSectionTitle": "About",
  "aboutSectionTitleAlt": "About Me",
  "experienceSectionTitle": "Work Experience",
  "projectsSectionTitle": "Projects",
  "resume": "Resume",
  "downloadResume": "Download resume",
  "openUrlError": "Could not open the url",
  "unknownLanguageError": "Language unknown",
  "caseStudyProblem": "The problem",
  "caseStudyBuilt": "What I built",
  "caseStudyResult": "The result",
  "caseStudyNotFound": "This page does not exist.",
  "openToWork": "Open to Senior Flutter roles · Remote or relocation",
  "bookCallUrl": "",
  "bookCall": "Book a call",
  "testimonials": [
    {
      "quote": "I had the pleasure of directly managing Ayman Elslamony, and I can confidently say he is an exceptionally skilled Flutter developer with a remarkable dedication to quality and efficiency. Ayman consistently demonstrated a strong technical aptitude, a collaborative spirit, and an eagerness to tackle complex challenges head-on.",
      "name": "Ahmed Elkhyary",
      "role": "Mobile Engineer | Native Android | cross platform",
      "url": "https://www.linkedin.com/in/ayman-elslamony/details/recommendations/"
    }
  ],
  "testimonialsSectionTitle": "What people say",
  "skills": [
    {
      "title": "Mobile Development",
      "items": [
        {
          "name": "Flutter",
          "icon": "flutter"
        },
        {
          "name": "Android",
          "icon": "android"
        },
        {
          "name": "iOS",
          "icon": "apple"
        },
        {
          "name": "Bloc"
        },
        {
          "name": "Provider"
        },
        {
          "name": "GetX"
        },
        {
          "name": "Riverpod"
        },
        {
          "name": "go_router"
        },
        {
          "name": "get_it"
        },
        {
          "name": "Code Generation"
        }
      ]
    },
    {
      "title": "Architecture & Practices",
      "items": [
        {
          "name": "Clean Architecture"
        },
        {
          "name": "SOLID"
        },
        {
          "name": "MVVM / MVC"
        },
        {
          "name": "Feature-First Modularization"
        },
        {
          "name": "Architecture Decision Records"
        },
        {
          "name": "Code Review"
        },
        {
          "name": "Monorepo (Melos)"
        },
        {
          "name": "Agile / Scrum"
        }
      ]
    },
    {
      "title": "Testing",
      "items": [
        {
          "name": "Unit Testing"
        },
        {
          "name": "Widget Testing"
        },
        {
          "name": "Cubit/Bloc State Testing"
        },
        {
          "name": "Mock Repositories"
        }
      ]
    },
    {
      "title": "APIs & Integrations",
      "items": [
        {
          "name": "RESTful APIs"
        },
        {
          "name": "Firebase (Analytics, Firestore, Remote Config)",
          "icon": "firebase"
        },
        {
          "name": "Google Maps & Geofencing",
          "icon": "googlemaps"
        },
        {
          "name": "Sqflite",
          "icon": "sqlite"
        },
        {
          "name": "Shared Preferences"
        },
        {
          "name": "Push Notifications (FCM, OneSignal)"
        },
        {
          "name": "Agora"
        }
      ]
    },
    {
      "title": "Payments",
      "items": [
        {
          "name": "HyperPay (Plugin Author)"
        },
        {
          "name": "Paymob"
        },
        {
          "name": "Tabby"
        }
      ]
    },
    {
      "title": "Security",
      "items": [
        {
          "name": "Biometric Authentication"
        },
        {
          "name": "Secure Key & Token Storage"
        },
        {
          "name": "Session & Token Refresh"
        }
      ]
    },
    {
      "title": "CI/CD & Release",
      "items": [
        {
          "name": "GitHub Actions",
          "icon": "githubactions"
        },
        {
          "name": "Azure Pipelines"
        },
        {
          "name": "Fastlane",
          "icon": "fastlane"
        },
        {
          "name": "Firebase App Distribution",
          "icon": "firebase"
        },
        {
          "name": "App Store",
          "icon": "appstore"
        },
        {
          "name": "Google Play",
          "icon": "googleplay"
        }
      ]
    },
    {
      "title": "Design Systems",
      "items": [
        {
          "name": "Design Tokens"
        },
        {
          "name": "Theming (Light & Dark)"
        },
        {
          "name": "Responsive Scaling"
        },
        {
          "name": "Figma-to-Code Pipeline",
          "icon": "figma"
        }
      ]
    },
    {
      "title": "AI-Assisted Engineering",
      "items": [
        {
          "name": "Claude Code",
          "icon": "claude"
        },
        {
          "name": "Cursor",
          "icon": "cursor"
        },
        {
          "name": "ChatGPT"
        },
        {
          "name": "Gemini",
          "icon": "googlegemini"
        }
      ]
    },
    {
      "title": "Programming Languages",
      "items": [
        {
          "name": "Dart",
          "icon": "dart"
        },
        {
          "name": "Swift",
          "icon": "swift"
        },
        {
          "name": "Python",
          "icon": "python"
        }
      ]
    }
  ],
  "skillsSectionTitle": "Skills",
  "filterAll": "All",
  "welcomeCompany": "Hi {} team — thanks for taking a look.",
  "caseStudyLabel": "Case study",
  "caseStudyCopyLink": "Copy link",
  "caseStudyLinkCopied": "Link copied",
  "backToTop": "Back to top",
  "testimonialReadFull": "Read the full recommendation on LinkedIn"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en};
}

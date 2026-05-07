# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | Flowboard |
| **Git URL** | git@github.com:asunnyboy861/Flowboard.git |
| **Repo URL** | https://github.com/asunnyboy861/Flowboard |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ENABLED (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/Flowboard/ | Active |
| Support | https://asunnyboy861.github.io/Flowboard/support.html | Active |
| Privacy Policy | https://asunnyboy861.github.io/Flowboard/privacy.html | Active |
| Terms of Use | https://asunnyboy861.github.io/Flowboard/terms.html | Active |

Note: Terms of Use required for IAP subscription apps.

## Repository Structure

```
Flowboard/
├── Flowboard/                        # iOS App Source Code
│   ├── Flowboard.xcodeproj/          # Xcode Project
│   ├── Flowboard/                    # Swift Source Files
│   │   ├── App/
│   │   ├── Assets.xcassets/
│   │   ├── Components/
│   │   ├── Core/
│   │   │   ├── Models/
│   │   │   ├── Persistence/
│   │   │   ├── Repositories/
│   │   │   └── Services/
│   │   ├── Extensions/
│   │   ├── Features/
│   │   │   ├── Board/
│   │   │   ├── BoardList/
│   │   │   ├── Calendar/
│   │   │   ├── Card/
│   │   │   ├── Onboarding/
│   │   │   ├── Paywall/
│   │   │   ├── Settings/
│   │   │   └── Today/
│   │   ├── ContentView.swift
│   │   └── FlowboardApp.swift
│   ├── FlowboardTests/
│   └── FlowboardUITests/
├── docs/                             # Policy Pages (GitHub Pages source)
│   ├── landing.html                  # Landing Page
│   ├── support.html                  # Support Page
│   ├── privacy.html                  # Privacy Policy
│   └── terms.html                    # Terms of Use
├── .github/workflows/
│   └── deploy.yml                    # GitHub Pages deployment
├── us.md                             # English Development Guide
├── keytext.md                        # App Store Metadata
├── capabilities.md                   # Capabilities Configuration
├── icon.md                           # App Icon Details
├── price.md                          # Pricing Configuration
└── nowgit.md                         # This File
```

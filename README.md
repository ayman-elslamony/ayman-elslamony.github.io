# ayman-elslamony.github.io

The source of my portfolio site — **https://ayman-elslamony.github.io**.

Senior Flutter Developer · 18+ Apps Shipped · Clean Architecture · CI/CD.

A Flutter **web** app (Riverpod, freezed, easy_localization). Every push to `main` builds the site
and publishes it to GitHub Pages — there is no build output in this repository.

---

## 1. One-time setup

| What | Value | Why |
|---|---|---|
| Flutter | **3.38.5**, channel stable | The version the workflow pins (`.github/workflows/deploy.yml`). With fvm: `fvm install 3.38.5`, then prefix every command below with `fvm` |
| GitHub → Settings → Pages → **Source** | **GitHub Actions** | Without it the workflow builds but cannot publish |
| GitHub → Settings → Actions → General | Actions allowed (the default) | The deploy runs as an Action |

## 2. Run it locally

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs --force-jit
flutter build web --release --no-tree-shake-icons
python3 -m http.server -d build/web 8080      # open http://localhost:8080
```

For live reload while editing code: `flutter run -d chrome` (after the first two commands).

**Why each flag is there — none of them is optional:**

- **`build_runner`** — every `*.g.dart` and `*.freezed.dart` file is git-ignored, so a fresh clone
  does not compile until they are generated.
- **`--force-jit`** — the default (AOT) compile of the build script fails on `objective_c`, a
  transitive package with build hooks: *"'dart compile' does not support build hooks"*.
- **`--no-tree-shake-icons`** — the contact icons are built at runtime from stored code points;
  tree-shaking cannot see them and drops their glyphs, so the icons render blank.
- There is no `--web-renderer` flag in this SDK.

## 3. Change the content

All text lives in **`assets/translations/en.json`** — the intro, about, experience, projects,
contacts and the resume link.

**The lists on the page (experience, projects, contacts, resumes, languages) are NOT read from the
JSON at runtime** — they come from the generated `lib/src/localization/generated/locale_json.g.dart`.
After any edit to `en.json`, regenerate both files, or nothing changes on screen:

```bash
dart run easy_localization:generate -S assets/translations -f json -O lib/src/localization/generated -o locale_json.g.dart
dart run easy_localization:generate -S assets/translations -f keys -O lib/src/localization/generated -o locale_keys.g.dart
```

These two generated files **are** committed (the `.gitignore` re-includes them), because the
workflow does not run this step. Check the regeneration worked: grep `locale_json.g.dart` for the
text you changed. When running with `flutter run`, do a full restart, not a hot reload.

| To change | Edit |
|---|---|
| Page title, description, link-preview text | `web/index.html` (`<title>`, `description`, `og:*`, `twitter:*`) |
| Colours | `lib/src/constants/themes.dart` — then the three places no Dart theme reaches, below |
| Project screenshots | `assets/images/` + the project's `screenshotPath` in `en.json` |
| Analytics / Search Console | `web/index.html` — the `gtag` block and the `google-site-verification` tag |
| The CV (PDF) | **Not by hand.** `web/cv/` is written by the vault's `career_facts.py sync` — see below |

**The CV link.** `https://ayman-elslamony.github.io/cv` is the link to send, and it never changes.
`web/cv/index.html` redirects it to `web/cv/<file>.pdf`, and the Resume button downloads the same
file (`lib/src/utils/file_download.dart`). The PDF is built in the vault; `career_facts.py sync`
copies it here, rewrites `index.html` and the button's URL in `en.json`, and regenerates the
localization. A renamed file is added beside the old one, which is kept so a direct link sent
earlier still opens. The service worker caches the PDF, so a returning visitor may get the
previous version once after an update; a first-time visitor always gets the current one.

**Colours that do not follow the Dart theme**, because they render before Flutter starts or are
images:

- `web/styles.css` — the pre-boot loader and page background (its own light/dark variables).
- `web/manifest.json` — `background_color`, `theme_color` (browser chrome, install splash).
- Three generated images — `assets/images/shared_architecture.png`,
  `assets/images/network_inspector.png`, `web/og-image.png`. Regenerate them with
  `python3 tools/make_banners.py` (needs Pillow); its colour constants are copied from
  `themes.dart` and must be changed with it.

**Analytics on the CV.** Two GA4 signals, both read in Reports → Acquisition → Traffic
acquisition → *Session campaign*:
- `/cv` counts its own visit. `web/cv/index.html` sends one `page_view` and redirects on GA's
  callback, or after 1 s at most; a 2 s meta refresh is the fallback when JS or GA is blocked.
- The portfolio links inside the PDF carry `utm_source=cv&utm_medium=pdf&utm_campaign=<tag>`
  (`public` for the published PDF). `web/index.html` passes the full URL to GA as
  `page_location`, then removes any `utm_` query from the address bar with
  `history.replaceState`, so a reader never sees the tag. The site reads no query parameter of
  its own; if it ever does, that line must keep it.

**Clicks.** The site is drawn on a canvas, so GA4's own click tracking never sees a link. Every
click is sent from Dart instead (`lib/src/utils/analytics.dart`, through the `gtag` that
`web/index.html` defines): outbound links as `click_whatsapp`, `click_email`, `click_phone`,
`click_linkedin`, `click_github`, `click_google_play`, `click_app_store`, `click_pub_dev` or
`click_other_link` with `link_url`; the CV download as `file_download`; the section buttons as
`nav_click`; `theme_toggle` and `language_change`. Read them in Reports → Engagement → Events.

**WhatsApp** appears twice: in the contact row and in the app bar (`whatsapp_button.dart` —
labelled on desktop, icon only beside the drawer button on narrower widths). Both read the one
`contacts` entry whose link is `wa.me`, so the number and the ready message are edited there only.
A new link needs no code: `LaunchUrlHelper.launchURL` reports every URL it opens.

GA shows when, roughly where, the device and the source — never who.

**Case studies.** A project with a `caseStudy` in `en.json` (`slug`, `problem`, `built[]`,
`result`) gets its own page at `/projects/<slug>/`, a Flutter route (`CaseStudyPage`), opened from
the project's card. Adding one to another project is data only. A direct visit opens
`[portfolio, case study]`, so Back stays on the site. GitHub Pages serves files, so the deploy runs
`tools/case_study_pages.py` after the build: it copies `build/web/index.html` into
`build/web/projects/<slug>/`, which makes the link answer 200 (a 404 can stop LinkedIn and WhatsApp
from showing a preview). The copies are outside the service-worker manifest, so they are never
served stale. Opening one sends `open_case_study`, and GA4 also counts the route change as a
`page_view` of `/projects/<slug>`.

**Tests.** `test/data_test.dart` guards `en.json`: link schemes, every icon code point bundled in
`IconHelper`, and complete case studies. `test/features/case_study_test.dart` covers the route, the
page at phone and desktop width, and the address bar. `test/utils/analytics_test.dart` runs with
`--platform chrome`.

**The link-preview image (`web/og-image.png`)** is what LinkedIn and WhatsApp show under a pasted
link, on the home page and on `/cv`. They cache it **by URL**, so after redrawing it, change the
`?v=` date on its URL in `web/index.html` (the `og:image` and `twitter:image` tags) and in the
vault's `career_facts.py` (`CV_INDEX`, which writes `web/cv/index.html`). Even then LinkedIn may
keep its own copy for some days; its Post Inspector shows what it currently has.

## 4. Publish

1. Run it locally (section 2) and check it.
2. Commit and push to `main`.
3. GitHub → **Actions** → *Deploy site* — wait for it to go green, then open
   the site. A hard refresh may be needed: the service worker caches the previous build.

To redeploy without a change: Actions → *Deploy site* → **Run workflow**.

## 5. When the deploy fails

| The log says | Fix |
|---|---|
| `Error when reading '….g.dart'` / `….freezed.dart` | The `build_runner` step did not run or failed — run it locally and read its error |
| `'dart compile' does not support build hooks` | `--force-jit` is missing from the `build_runner` command |
| `Get Pages site failed` / 404 on deploy | Settings → Pages → Source is not **GitHub Actions** |
| A dependency / SDK constraint error | The Flutter version in the workflow no longer satisfies `pubspec.yaml`'s `sdk:` — raise `flutter-version` in `deploy.yml` and test the same version locally |

## License

See [LICENSE.md](LICENSE.md).

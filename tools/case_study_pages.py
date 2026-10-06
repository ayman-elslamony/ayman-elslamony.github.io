#!/usr/bin/env python3
"""Give every case study a real folder in the built site, so its link answers 200.

GitHub Pages serves files, and /projects/<slug>/ is a route inside the Flutter app, not a
file. Without this, a direct visit gets 404 - and LinkedIn and WhatsApp may refuse a link
preview for a 404. Each folder holds a copy of the app's own build/web/index.html; the app
reads the path and opens the case study.

The copies are made after `flutter build web`, so they are outside the service worker's
manifest and the browser always fetches them fresh.

Run from the repo root, after the build:  python3 tools/case_study_pages.py
Standard library only.
"""
import json
import os
import re
import shutil
import sys

BUILD = 'build/web'
SLUG = re.compile(r'^[a-z0-9-]+$')


def slugs(path='assets/translations/en.json'):
    with open(path, encoding='utf-8') as fh:
        data = json.load(fh)
    found = []
    for project in data.get('projects', []):
        slug = (project.get('caseStudy') or {}).get('slug')
        if slug is None:
            continue
        if not SLUG.match(slug):
            sys.exit('bad case-study slug %r in %s' % (slug, path))
        found.append(slug)
    return found


def main():
    index = os.path.join(BUILD, 'index.html')
    if not os.path.exists(index):
        sys.exit('no %s - run flutter build web first' % index)
    for slug in slugs():
        folder = os.path.join(BUILD, 'projects', slug)
        os.makedirs(folder, exist_ok=True)
        shutil.copyfile(index, os.path.join(folder, 'index.html'))
        print('wrote %s/index.html' % folder)


if __name__ == '__main__':
    main()

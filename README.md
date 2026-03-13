# 📄 Modern ATS-Friendly CV — LaTeX Template

A clean, professional, and **ATS-optimized** CV/resume template built with [moderncv](https://github.com/moderncv/moderncv) (v2.4.1) using the **contemporary** style. Designed for software engineers, but easily adaptable to any profession.

![LaTeX](https://img.shields.io/badge/LaTeX-008080?logo=latex&logoColor=white)
![License](https://img.shields.io/badge/license-LPPL--1.3c-blue)

## ✨ Features

- **ATS-Friendly** — Clean text extraction, embedded fonts, rich PDF metadata keywords
- **Contemporary Style** — Gradient header with circular photo, vertical timeline for experience
- **Two PDF outputs** — HD quality for sharing + compressed version (<1MB) for upload portals
- **Privacy-safe** — Personal data (`phone`, `email`, `photo`) lives in a git-ignored file
- **Professional spacing** — Tuned margins, bullet spacing, and section gaps
- **Cerulean color scheme** — Professional blue-teal palette (easily changeable)
- **HTTPS links** — All URLs use HTTPS
- **Microtype** — Enhanced character protrusion and font expansion for beautiful text

## 🚀 Quick Start

### Prerequisites

Install a LaTeX distribution with the required packages:

```bash
# Ubuntu / Debian
sudo apt-get install texlive-latex-extra texlive-fonts-extra texlive-fonts-recommended latexmk ghostscript

# macOS (via Homebrew)
brew install --cask mactex
brew install ghostscript

# Arch Linux
sudo pacman -S texlive-most latexmk ghostscript

# Or use the full TeX Live installer: https://tug.org/texlive/
```

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/saqibroy/modern-cv-template.git
cd modern-cv-template

# 2. Create your personal data file
cp personal-data.tex.example personal-data.tex

# 3. Edit personal-data.tex with your details
#    (this file is git-ignored — your info stays private)

# 4. Add your photo (optional)
#    Place your photo file in the root and reference it in personal-data.tex:
#    \photo[64pt][2pt]{your-photo-filename}
```

### Build

```bash
# Build HD quality PDF
make

# Build compressed PDF (<1MB, for job portals)
make compressed

# Build both versions at once
make both

# Auto-rebuild on file changes
make watch

# Clean all build artifacts
make clean
```

Or build manually without Make:

```bash
# Compile with latexmk
latexmk -pdf template.tex

# Compress with Ghostscript
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH \
   -dPDFSETTINGS=/ebook -dEmbedAllFonts=true -dSubsetFonts=true \
   -sOutputFile=cv_compressed.pdf template.pdf
```

## 📁 Project Structure

```
├── template.tex                  # Main CV document (edit your content here)
├── personal-data.tex             # Your private details (git-ignored)
├── personal-data.tex.example     # Template for personal-data.tex
├── Makefile                      # Build automation (make, make compressed, etc.)
├── .gitignore                    # Ignores build artifacts + personal files
├── moderncv.cls                  # moderncv document class (v2.4.1)
├── moderncvstylecontemporary.sty # Contemporary style definition
├── moderncvcolorcerulean.sty     # Cerulean color scheme
├── moderncvheadvii.sty           # Header variant 7 (gradient + circular photo)
├── moderncvbodyvi.sty            # Body variant 6 (vertical timeline)
├── moderncvverticaltimeline.sty  # Timeline implementation
├── moderncviconsawesome.sty      # FontAwesome5 icons
├── picture.jpg                   # Sample photo placeholder
├── publications.bib              # BibTeX references (if needed)
├── manual/                       # moderncv user guide
│   ├── moderncv_userguide.tex
│   └── moderncv_userguide.pdf
└── README.md
```

## 🎨 Customization

### Change Color Scheme

In `template.tex`, change the color line:

```latex
\moderncvcolor{cerulean}   % Current: blue-teal
% Available: blue, black, burgundy, green, grey, orange, purple, red, cerulean
```

### Change Style

```latex
\moderncvstyle[noqr]{contemporary}  % Current
% Available: classic, casual, banking, oldstyle, fancy, contemporary, empty
```

### Adjust Margins

```latex
\usepackage[hmargin=0.55in,top=0.3in,bottom=0.4in]{geometry}
```

### Add/Remove Photo

In your `personal-data.tex`:

```latex
\photo[64pt][2pt]{your-photo}   % With photo
% Comment out the line above to remove the photo
```

### Add QR Code

The QR code (linking to your homepage) is disabled by default for ATS compatibility. To enable:

```latex
\moderncvstyle{contemporary}        % With QR (default)
\moderncvstyle[noqr]{contemporary}  % Without QR (current)
```

## 🤖 ATS Optimization Notes

This template follows ATS best practices:

| Feature | Status |
|---------|--------|
| Embedded fonts (T1 + Latin Modern) | ✅ |
| PDF metadata (author, title, keywords) | ✅ |
| Selectable text (no text-as-images) | ✅ |
| Standard section headings | ✅ |
| No tables for layout (uses moderncv's native layout) | ✅ |
| HTTPS hyperlinks | ✅ |
| Consistent date format (MM/YYYY) | ✅ |
| Clean bullet points | ✅ |
| No headers/footers with critical info | ✅ |

> **Tip:** Some ATS systems struggle with multi-column layouts and TikZ overlays.
> If you need maximum ATS compatibility, consider switching to the `classic` or `banking` style.

## 📦 Output Files

| File | Quality | Typical Size | Use Case |
|------|---------|-------------|----------|
| `saqib_sohail_cv.pdf` | HD (full quality) | 2–5 MB | Email, direct sharing |
| `saqib_sohail_cv_compressed.pdf` | Good (150 DPI) | < 1 MB | Job portals, LinkedIn |

## 🔒 Privacy

Personal details are separated into `personal-data.tex` which is **git-ignored**:

- ✅ `personal-data.tex.example` — committed (template with placeholder values)
- 🔒 `personal-data.tex` — git-ignored (your real phone, email, photo)
- 🔒 `saqib.png`, `signature.png` — git-ignored (personal images)

This way you can push your CV template to GitHub while keeping your private information local.

## 📜 License

- **CV template & customizations:** Free to use and modify
- **moderncv package:** Licensed under [LPPL-1.3c](https://spdx.org/licenses/LPPL-1.3c.html)
- **Original moderncv author:** Xavier Danaux
- **moderncv maintainers:** [github.com/moderncv/moderncv](https://github.com/moderncv/moderncv)

## 🙏 Acknowledgments

- [moderncv](https://github.com/moderncv/moderncv) — The LaTeX document class this template is built on
- [FontAwesome5](https://ctan.org/pkg/fontawesome5) — Icons used in the header
- [LaTeX Project](https://www.latex-project.org/) — The typesetting system

---

**If this template helped you land a job, consider giving it a ⭐!**

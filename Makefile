# ============================================================================
# Resume Build System
# ============================================================================
# Usage:
#   make              - Build HD quality PDF (default: full-stack)
#   make hd           - Build HD quality full-stack PDF
#   make compressed   - Build compressed full-stack PDF
#   make both         - Build both HD and compressed full-stack versions
#   make frontend     - Build HD + compressed front-end variant
#   make all-variants - Build all variants (full-stack + front-end)
#   make clean        - Remove all build artifacts
#   make watch        - Auto-rebuild on file changes (requires inotifywait)
# ============================================================================

# Full-stack variant (default)
TEX      = template
OUT_HD   = saqib_sohail_cv.pdf
OUT_COMP = saqib_sohail_cv_compressed.pdf

# Front-end variant
TEX_FE      = template-frontend
OUT_FE_HD   = saqib_sohail_cv_frontend.pdf
OUT_FE_COMP = saqib_sohail_cv_frontend_compressed.pdf

# Plain one-column ATS variants
TEX_ATS     = ats_resume
TEX_ATS_FE  = ats_resume_frontend
OUT_ATS     = saqib_sohail_cv_ats.pdf
OUT_ATS_FE  = saqib_sohail_cv_frontend_ats.pdf
OUT_ATS_DOCX = ats_resume.docx

# LaTeX engine & flags
LATEXMK  = latexmk
LMKFLAGS = -pdf -interaction=nonstopmode -halt-on-error

# Ghostscript compression settings
GS       = gs
# /screen = 72dpi, /ebook = 150dpi, /printer = 300dpi, /prepress = 300dpi+preserve
GS_QUALITY = /printer
GS_FLAGS = -sDEVICE=pdfwrite \
           -dCompatibilityLevel=1.5 \
           -dNOPAUSE -dQUIET -dBATCH \
           -dPDFSETTINGS=$(GS_QUALITY) \
           -dEmbedAllFonts=true \
           -dSubsetFonts=true \
           -dCompressFonts=true \
           -dAutoRotatePages=/None \
           -dDownsampleColorImages=false \
           -dDownsampleGrayImages=false \
           -dDownsampleMonoImages=false

.PHONY: all hd compressed both frontend frontend-hd frontend-compressed ats all-variants clean watch help

all: hd

help:
	@echo "Available targets:"
	@echo "  make              - Build HD quality full-stack PDF"
	@echo "  make hd           - Build HD quality full-stack PDF"
	@echo "  make compressed   - Build compressed full-stack PDF"
	@echo "  make both         - Build both full-stack versions"
	@echo "  make frontend     - Build HD + compressed front-end variant"
	@echo "  make ats          - Build plain one-column ATS PDFs and DOCX"
	@echo "  make all-variants - Build all variants"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make watch        - Auto-rebuild on changes"

hd: $(OUT_HD)

$(OUT_HD): $(TEX).tex
	$(LATEXMK) $(LMKFLAGS) $(TEX).tex
	@cp $(TEX).pdf $(OUT_HD)
	@echo ""
	@echo "✅ HD PDF generated: $(OUT_HD)"
	@ls -lh $(OUT_HD) | awk '{print "   Size: " $$5}'

compressed: $(OUT_HD)
	$(GS) $(GS_FLAGS) -sOutputFile=$(OUT_COMP) $(OUT_HD)
	@echo ""
	@echo "✅ Compressed PDF generated: $(OUT_COMP)"
	@ls -lh $(OUT_COMP) | awk '{print "   Size: " $$5}'

both: hd compressed
	@echo ""
	@echo "📋 Summary:"
	@ls -lh $(OUT_HD) $(OUT_COMP) | awk '{print "   " $$9 ": " $$5}'

# --- Front-end variant ---
frontend-hd: $(OUT_FE_HD)

$(OUT_FE_HD): $(TEX_FE).tex
	$(LATEXMK) $(LMKFLAGS) $(TEX_FE).tex
	@cp $(TEX_FE).pdf $(OUT_FE_HD)
	@echo ""
	@echo "✅ Front-end HD PDF generated: $(OUT_FE_HD)"
	@ls -lh $(OUT_FE_HD) | awk '{print "   Size: " $$5}'

frontend-compressed: $(OUT_FE_HD)
	$(GS) $(GS_FLAGS) -sOutputFile=$(OUT_FE_COMP) $(OUT_FE_HD)
	@echo ""
	@echo "✅ Front-end Compressed PDF generated: $(OUT_FE_COMP)"
	@ls -lh $(OUT_FE_COMP) | awk '{print "   Size: " $$5}'

frontend: frontend-hd frontend-compressed
	@echo ""
	@echo "📋 Front-end Summary:"
	@ls -lh $(OUT_FE_HD) $(OUT_FE_COMP) | awk '{print "   " $$9 ": " $$5}'

ats: $(OUT_ATS) $(OUT_ATS_FE) $(OUT_ATS_DOCX)
	@echo ""
	@echo "📋 ATS Summary:"
	@ls -lh $(OUT_ATS) $(OUT_ATS_FE) $(OUT_ATS_DOCX) | awk '{print "   " $$9 ": " $$5}'

$(OUT_ATS): $(TEX_ATS).tex
	$(LATEXMK) $(LMKFLAGS) $(TEX_ATS).tex
	@cp $(TEX_ATS).pdf $(OUT_ATS)

$(OUT_ATS_FE): $(TEX_ATS_FE).tex $(TEX_ATS).tex
	$(LATEXMK) $(LMKFLAGS) $(TEX_ATS_FE).tex
	@cp $(TEX_ATS_FE).pdf $(OUT_ATS_FE)

$(OUT_ATS_DOCX): ats_resume.md scripts/md2docx.py
	python3 scripts/md2docx.py ats_resume.md $(OUT_ATS_DOCX)

all-variants: both frontend ats
	@echo ""
	@echo "📋 All Variants:"
	@ls -lh $(OUT_HD) $(OUT_COMP) $(OUT_FE_HD) $(OUT_FE_COMP) $(OUT_ATS) $(OUT_ATS_FE) $(OUT_ATS_DOCX) | awk '{print "   " $$9 ": " $$5}'

clean:
	$(LATEXMK) -C $(TEX).tex
	$(LATEXMK) -C $(TEX_FE).tex 2>/dev/null || true
	$(LATEXMK) -C $(TEX_ATS).tex 2>/dev/null || true
	$(LATEXMK) -C $(TEX_ATS_FE).tex 2>/dev/null || true
	@rm -f $(OUT_HD) $(OUT_COMP) $(OUT_FE_HD) $(OUT_FE_COMP) $(OUT_ATS) $(OUT_ATS_FE)
	@rm -f $(TEX).pdf $(TEX_FE).pdf
	@rm -f *.aux *.log *.out *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg *.bcf *.run.xml
	@echo "🧹 Cleaned all build artifacts."

watch:
	@echo "👀 Watching for changes... (Ctrl+C to stop)"
	@while true; do \
		inotifywait -q -e modify $(TEX).tex 2>/dev/null || (echo "Install inotify-tools: sudo apt install inotify-tools" && exit 1); \
		echo "🔄 Change detected, rebuilding..."; \
		$(MAKE) hd; \
	done

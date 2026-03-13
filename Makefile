# ============================================================================
# Resume Build System
# ============================================================================
# Usage:
#   make              - Build HD quality PDF (default)
#   make hd           - Build HD quality PDF (~full quality, larger file)
#   make compressed   - Build compressed PDF (<1MB, safe for upload portals)
#   make both         - Build both HD and compressed versions
#   make clean        - Remove all build artifacts
#   make watch        - Auto-rebuild on file changes (requires inotifywait)
# ============================================================================

TEX      = template
OUT_HD   = saqib_sohail_cv.pdf
OUT_COMP = saqib_sohail_cv_compressed.pdf

# LaTeX engine & flags
LATEXMK  = latexmk
LMKFLAGS = -pdf -interaction=nonstopmode -halt-on-error

# Ghostscript compression settings
GS       = gs
# /screen = 72dpi, /ebook = 150dpi, /printer = 300dpi, /prepress = 300dpi+preserve
GS_QUALITY = /ebook
GS_FLAGS = -sDEVICE=pdfwrite \
           -dCompatibilityLevel=1.5 \
           -dNOPAUSE -dQUIET -dBATCH \
           -dPDFSETTINGS=$(GS_QUALITY) \
           -dEmbedAllFonts=true \
           -dSubsetFonts=true \
           -dCompressFonts=true \
           -dAutoRotatePages=/None

.PHONY: all hd compressed both clean watch help

all: hd

help:
	@echo "Available targets:"
	@echo "  make          - Build HD quality PDF"
	@echo "  make hd       - Build HD quality PDF"
	@echo "  make compressed - Build compressed PDF (<1MB)"
	@echo "  make both     - Build both versions"
	@echo "  make clean    - Remove build artifacts"
	@echo "  make watch    - Auto-rebuild on changes"

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

clean:
	$(LATEXMK) -C $(TEX).tex
	@rm -f $(OUT_HD) $(OUT_COMP)
	@rm -f $(TEX).pdf
	@rm -f *.aux *.log *.out *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg *.bcf *.run.xml
	@echo "🧹 Cleaned all build artifacts."

watch:
	@echo "👀 Watching for changes... (Ctrl+C to stop)"
	@while true; do \
		inotifywait -q -e modify $(TEX).tex 2>/dev/null || (echo "Install inotify-tools: sudo apt install inotify-tools" && exit 1); \
		echo "🔄 Change detected, rebuilding..."; \
		$(MAKE) hd; \
	done

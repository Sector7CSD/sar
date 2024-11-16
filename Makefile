SUBDIRS := $(wildcard s7-*/)
REPONAME = "sar"

.PHONY: all $(SUBDIRS)

all: $(SUBDIRS)

# Regel für jedes Verzeichnis
$(SUBDIRS):
	$(MAKE) -C $@ -j

# Optional: "clean"-Ziel für alle Unterverzeichnisse
.PHONY: clean
clean:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

.PHONY: copy2repo
copy2repo:
	cd "${REPONAME}"; \
	pwd; \
	find .. -type f -name "*.pkg.tar.zst" -not -path "../${REPONAME}/*" -exec cp {} . \;

.PHONY: repo
repo: all copy2repo
	cd "${REPONAME}"; \
	pwd; \
	repo-add "${REPONAME}.db.tar.zst" s7-*.pkg.tar.zst ; \
	mv sar.db.tar.zst sar.db ; \
	mv sar.files.tar.zst sar.files ; \

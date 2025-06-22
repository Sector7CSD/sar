SUBDIRS := $(wildcard ../pkgbuild/s7-*/)
REPONAME = "sar"

.PHONY: all
all: repo

.PHONY: packages $(SUBDIRS)
packages: $(SUBDIRS)

# Regel für jedes Verzeichnis
$(SUBDIRS):
	$(MAKE) -C $@ -j

.PHONY: clean
clean:
	rm -rf "${REPONAME}/";

.PHONY: cleanall
cleanall: clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done

.PHONY: copy2repo
copy2repo:
	pwd; \
	mkdir -p "${REPONAME}"; \
	find ../pkgbuild -type f -name "*.pkg.tar.zst" -exec cp {} "${REPONAME}" \;

.PHONY: repo
repo: packages copy2repo
	cd "${REPONAME}"; \
	pwd; \
	repo-add "${REPONAME}.db.tar.zst" s7-*.pkg.tar.zst ; \
	mv sar.db.tar.zst sar.db ; \
	mv sar.files.tar.zst sar.files ; \

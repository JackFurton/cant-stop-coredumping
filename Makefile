CFLAGS  ?= -g -O0 -fno-omit-frame-pointer -Wall -Wextra

EXHIBITS := $(patsubst exhibits/%/,%,$(sort $(dir $(wildcard exhibits/*/*.c))))
BINS     := $(foreach e,$(EXHIBITS),build/$(e)/$(firstword $(basename $(notdir $(wildcard exhibits/$(e)/*.c)))))

.PHONY: all gallery check clean $(EXHIBITS)

all: $(BINS)

build/%:
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) exhibits/$(patsubst build/%/,%,$(dir $@))/*.c -o $@

# make 01-hexspeak: build it, crash it, admire it
$(EXHIBITS): %: all
	@scripts/crash.sh exhibits/$* build/$*/$(basename $(notdir $(wildcard exhibits/$*/*.c)))

gallery: all
	@for e in $(EXHIBITS); do echo "== $$e =="; $(MAKE) -s $$e; echo; done

# the core is the test output: every exhibit must still look exactly as approved
check: all
	@fail=0; for e in $(EXHIBITS); do \
		$(MAKE) -s $$e >/dev/null 2>&1; \
		if diff -u exhibits/$$e/expected.txt build/$$e/gallery.txt; then echo "ok   $$e"; \
		else echo "FAIL $$e"; fail=1; fi; \
	done; exit $$fail

clean:
	rm -rf build

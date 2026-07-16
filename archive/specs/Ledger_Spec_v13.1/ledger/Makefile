# GHC harness for the reference implementation and its property suite.
# GHC 9.10 lives under ~/.ghcup/bin; the module needs only base + containers
# (boot libraries), so no network or dependency resolution is required.

GHC   := $(shell command -v ghc || echo $(HOME)/.ghcup/bin/ghc)
BUILD := build

.PHONY: props typecheck clean

# Type-check the reference, warnings as errors (-Wall must be clean).
typecheck:
	$(GHC) -fno-code -Wall -Werror -outputdir $(BUILD) reference/Ledger.hs

# Build and run the property suite (P24..P31, P-DET..P-PARTITION, F8, P26a-d).
props:
	@mkdir -p $(BUILD)
	$(GHC) -O0 -Wall -ireference -outputdir $(BUILD) test/RunProps.hs -o $(BUILD)/runprops
	$(BUILD)/runprops

clean:
	rm -rf $(BUILD)

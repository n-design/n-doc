# List of directories for documents
# Add new documents here

# Each directory contains the source data for creating
# a single artefact, such as a PDF file or the DB file

ARC_DIR := adv_arc
ST_DIR  := ase
TDS_DIR := adv_tds
FSP_DIR := adv_fsp
ALC_DIR := alc
REF_DIR := reflist
ATE_DIR := ate_cov
DB_DIR   := common/db
DB_FILE  := mauvecorp_vpn_client.db
MWE_TDS_DIR  := mwe_tds
MWE_FSP_DIR  := mwe_fsp
MWE_ARC_DIR  := mwe_arc
MWE_ATE_DIR  := mwe_ate
MWE_ST_DIR   := mwe_st
README       := common/README.md
LUA_DIR  := lua

# Directories with production PDF files
PDF_DIRS := $(ATE_DIR) $(TDS_DIR) $(ST_DIR) $(FSP_DIR) $(ALC_DIR) $(ARC_DIR) $(REF_DIR)

# Directories with minimal working examples / test documents (PDF)
MWE_DIRS := $(MWE_TDS_DIR) $(MWE_FSP_DIR) $(MWE_ARC_DIR) $(MWE_ST_DIR) $(MWE_ATE_DIR)

# Names of the PDF documents within their respective directories
DELIVERABLES = $(foreach dir,$(PDF_DIRS),$(dir)/$(dir).pdf)

# All directories with artefacts relevant for delivery
ALL_DIRS = $(LUA_DIR) $(PDF_DIRS) $(DB_DIR)

# Directory containing the deliverables: PDFs, DB-File
# Ship the content of this directory to the evaluator
DELIVERY_DIR = deliverables

# Command for creating the artefacts
MAKE_CMD = $(MAKE) -C $@

# Required git Hooks and metadata
HOOKS = post-commit post-checkout post-merge
GIT_HOOK_DIR = .git/hooks/
GIT_HOOKS = $(addprefix $(GIT_HOOK_DIR), $(HOOKS))
GIT_INFO = .git/gitHeadInfo.gin

# Convenience goals to be called at the prompt
.PHONY: st fsp tds agd clean all delivery subdirs db mwe cleanmwe wsdpdf hooks info $(MWE_DIRS) $(ALL_DIRS)

# Make them all
all: $(ALL_DIRS)

#alc: $(ALC_DIR) # no need for this

arc: $(ARC_DIR)

st: $(ST_DIR)

fsp: $(FSP_DIR)

tds: $(TDS_DIR)

ref: $(REF_DIR)

ate: $(ATE_DIR)

db: $(DB_DIR)

mwe: $(MWE_DIRS)

delivery: $(DELIVERABLES)
	rm -rf $(DELIVERY_DIR)
	mkdir -p $(DELIVERY_DIR)
	cp $+ $(DELIVERY_DIR)
	cp $(DB_DIR)/$(DB_FILE) $(DELIVERY_DIR)
	./scripts/renamereleases.sh $(DELIVERY_DIR)

$(DELIVERABLES): $(ALL_DIRS) $(DB_DIR)

$(ALL_DIRS): hooks
	$(MAKE_CMD)

$(MWE_DIRS):
	./scripts/prepare_mwe.sh $@
	$(MAKE_CMD)

cleanmwe: 
	./scripts/cleanup.sh $(MWE_DIRS)

hooks: $(GIT_HOOKS) $(GIT_INFO)

.git/hooks/post-merge:
	cp config/hooks/post-merge $(GIT_HOOK_DIR)

.git/hooks/post-checkout:
	cp config/hooks/post-checkout $(GIT_HOOK_DIR)

.git/hooks/post-commit:
	cp config/hooks/post-commit $(GIT_HOOK_DIR)

$(GIT_INFO):
	git checkout

clean:
	rm -rf $(DELIVERY_DIR)
	./scripts/cleanup.sh $(ALL_DIRS)
	./scripts/cleanup.sh $(MWE_DIRS)

info:
	$(info $$GIT_HOOKS is [${GIT_HOOKS}])


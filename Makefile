# Liste der Verzeichnisse für Dokumente
# Neue Dokumente nur hier hinzufügen

ARC_DIR := adv_arc
ST_DIR  := ase
TDS_DIR := adv_tds
FSP_DIR := adv_fsp
ALC_DIR := alc
REF_DIR := refliste
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

PDF_DIRS := $(ATE_DIR) $(TDS_DIR) $(ST_DIR) $(FSP_DIR) $(ALC_DIR) $(ARC_DIR) $(REF_DIR)
MWE_DIRS := $(MWE_TDS_DIR) $(MWE_FSP_DIR) $(MWE_ARC_DIR) $(MWE_ST_DIR) $(MWE_ATE_DIR)

# Verzeichnis, in dem die ausgelieferten PDFs liegen
DELIVERY_DIR = deliverables

# Namen der erzeugten PDF-Dokumente in ihren Verzeichnissen
DELIVERABLES = $(foreach dir,$(PDF_DIRS),$(dir)/$(dir).pdf)

ALL_DIRS = $(LUA_DIR) $(PDF_DIRS) $(DB_DIR)

# Kommando zum Erstellen der PDFs
MAKE_CMD = $(MAKE) -C $@

# Notwendige git Hooks und Metadaten
HOOKS = post-commit post-checkout post-merge
GIT_HOOK_DIR = .git/hooks/
GIT_HOOKS = $(addprefix $(GIT_HOOK_DIR), $(HOOKS))
GIT_INFO = .git/gitHeadInfo.gin

.PHONY: st fsp tds agd clean all delivery subdirs db mwe cleanmwe wsdpdf hooks info $(MWE_DIRS) $(ALL_DIRS)

all: $(ALL_DIRS)

alc: $(ALC_DIR)

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


OUTPUT_DIR = ./output
SEQ = SRR12717711.fastq
REF = GCF_000005845.2_ASM584v2_genomic.fna
REF_INDEX = $(OUTPUT_DIR)/ref_index.mmi
MINIMAP2 = ../minimap2-2.28_x64-linux/minimap2
SAM_FILE = $(OUTPUT_DIR)/mapped_sam.sam
BAM_FILE = $(OUTPUT_DIR)/mapped_bam.bam
SORTED_BAM = $(OUTPUT_DIR)/sorted_mapped_bam.bam
FREEBAYES_RES = $(OUTPUT_DIR)/freebayes_output.vcf
FLAGSTAT_RES = $(OUTPUT_DIR)/flagstat_result
VISUALIZE_FILE_DOT = $(OUTPUT_DIR)/pipeline.dot
VISUALIZE_FILE_PNG = $(OUTPUT_DIR)/pipeline.png

quality_score: $(FLAGSTAT_RES)
	@echo "💥  Let's get the quality score..."
	@VAR=$$(grep "+ 0 mapped" $(FLAGSTAT_RES) | grep -oP '\d+\.\d+'); \
	echo "💥  Result is - $$VAR%"; \
	if [ -z "$$VAR" ]; then \
		echo "❌  Quality score not found!"; \
	elif [ "$$(echo "$$VAR > 90" | bc -l)" -eq 1 ]; then \
		echo "✅  OK!"; \
	else \
		echo "❌  not OK..."; \
	fi

# Хотим получить оценку с помощью samtools flagstat
$(FLAGSTAT_RES): $(BAM_FILE)
	@echo "💥  Samtools flagstat is starting to work..."
	samtools flagstat $(BAM_FILE) > $(FLAGSTAT_RES)

# Для этого мы выполняем следующее:

# Индексируем референсный геном с помощью инструмента minimap2
$(REF_INDEX): $(REF)
	@mkdir -p $(OUTPUT_DIR)
	@echo "💥  Get index of ref with minimap2..."
	$(MINIMAP2) -d $(REF_INDEX) $(REF)

# Картирование с помощью инструмента minimap2
$(SAM_FILE): $(REF_INDEX)
	@echo "💥  Get SAM file with minimap2..."
	$(MINIMAP2) -a $(REF_INDEX) $(SEQ) > $(SAM_FILE)

# Конвертируем файл в формате SAM в BAM с помощью samtools view
$(BAM_FILE): $(SAM_FILE)
	@echo "💥  Convert SAM file into BAM file..."
	samtools view -S -b $(SAM_FILE) > $(BAM_FILE)

# Для freebayes
$(SORTED_BAM): $(BAM_FILE) $(REF)
	@echo "💥  Samtools sorting..."
	samtools sort $(BAM_FILE) -o $(SORTED_BAM)
	@echo "💥  Indexing ref..."
	samtools faidx $(REF)

index_sorted: $(SORTED_BAM)
	@echo "💥  Indexing sorted_mapped..."
	samtools index $(SORTED_BAM)

freebayes: index_sorted $(SORTED_BAM) $(REF)
	@echo "💥  Freebayes is starting to work..."
	freebayes -f $(REF) $(SORTED_BAM) > $(FREEBAYES_RES)




# Чистим все файлы, полученные после выполнения скрипта в предыдущие разы
.PHONY: clean
clean:
	rm -r $(OUTPUT_DIR)

# Визуализация
.PHONY: visualize

# Цель визуализации
visualize: $(VISUALIZE_FILE_DOT)
	dot -Tpng -o $(VISUALIZE_FILE_PNG) $(VISUALIZE_FILE_DOT)

# Генерация .dot файла из Makefile
$(VISUALIZE_FILE_DOT): Makefile
	echo "digraph G {" > $(VISUALIZE_FILE_DOT)
	awk '/^[^#][^ \t]*:/ {print "\"" $$1 "\" -> \"" $$2 "\";"}' $(MAKEFILE_LIST) >> $(VISUALIZE_FILE_DOT)
	echo "}" >> $(VISUALIZE_FILE_DOT)

#!/bin/bash

# Отсортируем выравнивания по координатам и сохраним результат в sorted_mapped.bam.
echo "samtools sorting..."
samtools sort mapped_after_samtools.bam -o sorted_mapped.bam

# Создаем индекс для референсного генома в формате FASTA.
# Индексный файл (GCF_000005845.2_ASM584v2_genomic.fna.fai) позволит более эффективно работать с данными.
echo "indexing ref..."
samtools faidx GCF_000005845.2_ASM584v2_genomic.fna

# Создаем индекс для BAM-файла (sorted_mapped.bam), который понадобится для корректной работы с ним в FreeBayes.
echo "indexing sorted_mapped..."
samtools index sorted_mapped.bam

# Коллинг генетических вариантов с помощью FreeBayes
# Результат сохраняется в freebayes_output.vcf.
echo "freebayes is starting to work..."
freebayes -f GCF_000005845.2_ASM584v2_genomic.fna sorted_mapped.bam > freebayes_output.vcf

#!/bin/bash

# Выполняем выравнивание ридов из файла SRR12717711.fastq к индексированному геному ecoli-pb.mmi
# с использованием minimap2. Опция -a указывает формат вывода SAM.
# Результат сохраняется в mapped.sam.

/home/admin/minimap2-2.28_x64-linux/minimap2 -a ecoli-pb.mmi SRR12717711.fastq > mapped.sam

# Преобразуем формат файла mapped.sam в формат BAM (бинарный формат, сжатый аналог SAM)
# с помощью команды samtools view.
# Опция -S указывает, что входной файл в формате SAM, а -b указывает на необходимость вывода в BAM.
# Результат сохраняется в mapped_after_samtools.bam.

samtools view -S -b mapped.sam > mapped_after_samtools.bam

# Считаем статистику выравнивания для файла mapped_after_samtools.bam с помощью samtools flagstat.
# Эта команда выводит подробную информацию, например, общее количество ридов, 
# процент картированных ридов и др.
# Результат сохраняется в flagstat.

samtools flagstat mapped_after_samtools.bam > flagstat

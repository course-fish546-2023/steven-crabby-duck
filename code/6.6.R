bash_script <- '
cd /home/shared/8TB_HDD_01/sr320/github/steven-crabby-duck/code

/home/shared/gatk-4.2.5.0/gatk CreateSequenceDictionary \
-R ../data/cgigas_uk_roslin_v1_genomic-mito.fa

/home/shared/samtools-1.12/samtools faidx \
../data/cgigas_uk_roslin_v1_genomic-mito.fa

/home/shared/gatk-4.2.5.0/gatk --java-options "-Xmx40G" HaplotypeCaller \
-R ../data/cgigas_uk_roslin_v1_genomic-mito.fa \
-I ../output/F143_cgigas_sorted.bam \
-O ../output/F143_variants.vcf

/home/shared/samtools-1.12/samtools mpileup --no-BAQ \
--fasta-ref ../data/cgigas_uk_roslin_v1_genomic-mito.fa \
../output/F143_cgigas_sorted.bam

/home/shared/samtools-1.12/samtools mpileup -v --no-BAQ \
--fasta-ref ../data/cgigas_uk_roslin_v1_genomic-mito.fa \
../output/F143_cgigas_sorted.bam \
> ../output/F143_mpile.vcf.gz

zgrep "^##" -v ../output/F143_mpile.vcf.gz | \
awk \'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5,$6,a[1],$9,$10}\'

/home/shared/bcftools-1.14/bcftools call \
-v -m ../output/F143_mpile.vcf.gz \
> ../output/F143_mpile_calls.vcf.gz

zgrep "^##" -v ../output/F143_mpile_calls.vcf.gz | \
awk \'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5,$6,a[1],$9,$10}\'
'

# Execute the bash script
system(bash_script)

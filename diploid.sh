#!/bin/bash -l
#SBATCH -p gibbon
#SBATCH -n 8
#SBATCH -t 5-00:00:00
#SBATCH -J diploid
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

bam=$1 ##AKT16_merged.hs37d5.cons.90perc.down_chr

sample="$( cut -d "_" -f1 <<< "${bam}" )"; samplename=${sample##*/}; echo "$samplename"
filebase=$(basename $bam .trimBAM.bam)

bcftools=/usr/local/sw/bcftools-1.18/bcftools

for chr in {1..22}
do
        BAM=/mnt/NEOGENE1/toTransfer/workshopfiles/imputation/${samplename}/${samplename}_bam/${filebase}_chr${chr}.bam
        REFGEN=/mnt/NEOGENE3/share/ref/genomes/hsa/chr/hs37d5.chr${chr}.fa
        VCF=/mnt/NEOGENE3/share/dna/hsa/genotypes/1000G_20130502/reference_panel/1000GP.chr${chr}.sites.vcf.gz
        TSV=/mnt/NEOGENE3/share/dna/hsa/genotypes/1000G_20130502/reference_panel/1000GP.chr${chr}.sites.tsv.gz
        OUT=${samplename}/${samplename}_vcf/${filebase}_chr${chr}.vcf.gz

        ${bcftools} mpileup -f ${REFGEN} -I -E -a 'FORMAT/DP' -T ${VCF} -r ${chr} -q 30 -Q 30 --threads 8 ${BAM} -Ou | ${bcftools} call -Aim -C alleles -T ${TSV} -Oz -o ${OUT}
        ${bcftools} index -f ${OUT}
done

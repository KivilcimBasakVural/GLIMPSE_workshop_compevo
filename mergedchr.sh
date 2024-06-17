#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 1
#SBATCH -t 5-00:00:00
#SBATCH -J concat
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

bam=$1
outdir=$2

sample="$( cut -d "_" -f1 <<< "${bam}" )"; samplename=${sample##*/}; echo "$samplename"
filebase=$(basename $bam .trimBAM.bam)

bcftools=/usr/local/sw/bcftools-1.18/bcftools
${bcftools} concat ${samplename}/${samplename}_ligate/${filebase}_chr{1..22}.imputed.merged.bcf -Oz -o ${outdir}/${filebase}.all.merged.imputed.vcf.gz
${bcftools} index -f ${outdir}/${filebase}.all.merged.imputed.vcf.gz

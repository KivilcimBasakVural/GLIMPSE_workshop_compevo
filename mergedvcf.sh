#!/bin/bash -l
#SBATCH -p bonobo
#SBATCH -n 4
#SBATCH -t 5-00:00:00
#SBATCH -J filter
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

#####ls *.vcf>list
bcftools=/usr/local/sw/bcftools-1.18/bcftools
list=$1
datasetname=$2

${bcftools} merge -l ${list} -Oz -o ${datasetname}.all.vcf.gz
${bcftools} index -f ${datasetname}.all.vcf.gz

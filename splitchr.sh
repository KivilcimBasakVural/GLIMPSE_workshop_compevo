#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 1
#SBATCH -t 3-00:00:00
#SBATCH -J chr
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

bam=$1 ##prefix
dir=$2

sample="$( cut -d "_" -f1 <<< "${bam}" )"; samplename=${sample##*/}; echo "$samplename"
filebase=$(basename $bam .trimBAM.bam)

for file in ${dir}/${bam}; do filename=${filebase}; for chrom in `seq 1 22` X Y MT; do samtools view -bh $file ${chrom} > ${samplename}/${samplename}_bam/${filename}_chr${chrom}.bam; done; done

for file in ${samplename}/${samplename}_bam/*.bam; do samtools index $file; done

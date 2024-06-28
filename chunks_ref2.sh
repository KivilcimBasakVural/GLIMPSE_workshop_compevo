#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 1
#SBATCH -t 5-00:00:00
#SBATCH -J chunk
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

chunk=/usr/local/sw/GLIMPSE/tutorial/bin/GLIMPSE2_chunk
chr=$1
outdir=$2
indir=/mnt/NEOGENE3/share/dna/hsa/genotypes/1000G_20130502/reference_panel
mapdir=/usr/local/sw/GLIMPSE/maps/genetic_maps.b37

${chunk} --input ${indir}/1000GP.chr${chr}.sites.vcf.gz --region ${chr} --sequential --output ${outdir}/chunks.chr${chr}.txt --map ${mapdir}/chr${chr}.b37.gmap.gz

#!/bin/bash -l
#SBATCH -p gibbon
#SBATCH -n 8
#SBATCH -t 5-00:00:00
#SBATCH -J imput
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

bam=$1
chr=$2
GLIMPSE=/usr/local/sw/GLIMPSE/tutorial/bin/GLIMPSE2_phase

sample="$( cut -d "_" -f1 <<< "${bam}" )"; samplename=${sample##*/}; echo "$samplename"
filebase=$(basename $bam .trimBAM.bam)

dir=/mnt/NEOGENE3/share/dna/hsa/genotypes/1000G_20130502

REF=${dir}/reference_panel/split/1000GP.chr${chr}
VCF=${samplename}/${samplename}_vcf/${filebase}_chr${chr}.vcf.gz
while IFS="" read -r LINE || [ -n "$LINE" ];
do
        printf -v ID "%02d" $(echo $LINE | cut -d" " -f1)
        IRG=$(echo $LINE | cut -d" " -f3)
        ORG=$(echo $LINE | cut -d" " -f4)
        CHR=$(echo ${LINE} | cut -d" " -f2)
        REGS=$(echo ${IRG} | cut -d":" -f 2 | cut -d"-" -f1)
        REGE=$(echo ${IRG} | cut -d":" -f 2 | cut -d"-" -f2)
        OUT=${samplename}/${samplename}_impute/${filebase}_chr${chr}_${CHR}_${REGS}_${REGE}.bcf
        /usr/local/sw/GLIMPSE/tutorial/bin/GLIMPSE2_phase --input-gl ${VCF} --reference ${REF}_${CHR}_${REGS}_${REGE}.bin --threads 8 --output ${OUT}
done < chunks.chr${chr}.txt

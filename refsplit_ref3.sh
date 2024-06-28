#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 1
#SBATCH -t 5-00:00:00
#SBATCH -J split
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

chr=$1
dir=$2
GLIMPSE2=/usr/local/sw/GLIMPSE/tutorial/bin/GLIMPSE2_split_reference
REF=${dir}/reference_panel/1000GP.chr${chr}.bcf
MAP=/usr/local/sw/GLIMPSE/maps/genetic_maps.b37/chr${chr}.b37.gmap.gz

while IFS="" read -r LINE || [ -n "$LINE" ]; 
do
        printf -v ID "%02d" $(echo $LINE | cut -d" " -f1)
        IRG=$(echo $LINE | cut -d" " -f3)
        ORG=$(echo $LINE | cut -d" " -f4)
        ${GLIMPSE2} --reference ${REF} --map ${MAP} --input-region ${IRG} --output-region ${ORG} --output ${dir}/reference_panel/split/1000GP.chr${chr}
done < chunks.chr${chr}.txt

#SBATCH -p gibbon
#SBATCH -n 1
#SBATCH -t 5-00:00:00
#SBATCH -J ligate
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

bcftools=/usr/local/sw/bcftools-1.18/bcftools
ligate=/usr/local/sw/GLIMPSE/tutorial/bin/GLIMPSE2_ligate

bam=$1
chr=$2

sample="$( cut -d "_" -f1 <<< "${bam}" )"; samplename=${sample##*/}; echo "$samplename"
filebase=$(basename $bam .trimBAM.bam)

LST=${samplename}/${samplename}_ligate/list.chr${chr}.txt
ls -1v ${samplename}/${samplename}_impute/${filebase}_chr${chr}_*.*bcf >${LST}
OUT=${samplename}/${samplename}_ligate/${filebase}_chr${chr}.imputed.merged.bcf
${ligate} --input ${LST} --output ${OUT}
${bcftools} index -f ${OUT}

#SBATCH -p chimp
#SBATCH -n 1
#SBATCH -t 3-00:00:00
#SBATCH -J rg
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

picard=/usr/local/sw/picard/build/libs/picard.jar

bamfile=$1
indir=$2
outdir=$3

sample="$( cut -d "_" -f1 <<< "${bamfile}" )"; samplename=${sample##*/}; echo "$samplename"
filebase=$(basename $bamfile .bam)

###Add read group to bam
java -jar ${picard} AddOrReplaceReadGroups I=${indir}/${filebase}.bam O=${outdir}/${filebase}.bam SORT_ORDER=coordinate RGID=foo RGLB=bar RGPU=foo RGPL=illumina RGSM=${samplename} CREATE_INDEX=True

samtools index ${outdir}/${filebase}.bam

#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l s_vmem=16G

SEQ1=$1
SEQ2=$2
OUTPUT_PREFIX=$3
DATE_A=$4

if [ ! -d ../results/${DATE_A} ]
then
    mkdir -p ../results/${DATE_A}
fi

module use /usr/local/package/modulefiles/
module load bwa samtools python

export PATH=../bin/minipileup:$PATH
bwa mem ../data/references/hg38/Homo_sapiens_assembly38.fasta ../data/"$SEQ1" ../data/"$SEQ2" > ${DATE_A}.aln-pe-temp.sam
samtools view -bh ${DATE_A}.aln-pe-temp.sam > ${DATE_A}.aln-pe-temp.bam
samtools sort -o ${DATE_A}.aln-pe-sorted-temp.bam ${DATE_A}.aln-pe-temp.bam
samtools index -o ${DATE_A}.aln-pe-sorted-temp.bam.bai  ${DATE_A}.aln-pe-sorted-temp.bam
minipileup -f ../data/references/hg38/Homo_sapiens_assembly38.fasta ${DATE_A}.aln-pe-sorted-temp.bam > ${DATE_A}.inputfile.vcf



python ./subscript/filter_vcf.py ${DATE_A}.inputfile.vcf ${OUTPUT_PREFIX}.vcf

rm ${DATE_A}.aln-pe-temp.sam ${DATE_A}.aln-pe-temp.bam ${DATE_A}.aln-pe-sorted-temp.bam ${DATE_A}.aln-pe-sorted-temp.bam.bai ${DATE_A}.inputfile.vcf
mv ${OUTPUT_PREFIX}.vcf ../results/${DATE_A}

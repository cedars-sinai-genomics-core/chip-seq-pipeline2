#!/bin/bash -l
#$ -terse
#$ -j y
#$ -o ./logs/
#$ -V
#$ -cwd
#$ -N ChIP
#$ -l h_rt=120:00:00
#$ -l s_rt=120:00:00
#$ -l h_vmem=4G
#$ -l s_vmem=4G
#$ -pe smp 10
#$ -q all.q

module load java anaconda3 
source activate encode-chip-seq-pipeline

START=$PWD
JSON=$1   # JSON=example_input_json/AGCT_Example.json
OUTDIR=$2

mkdir -p $START/$OUTDIR
cd $START/$OUTDIR

caper run \
	/common/genomics-core/apps/chip-seq-pipeline2/chip.wdl \
	-c /common/genomics-core/apps/chip-seq-pipeline2/.caper/default.conf \
	-i $START/$JSON

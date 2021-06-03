#!/bin/bash
#$ -S /bin/sh
#$ -terse
#$ -j y
#$ -o ./logs/
#$ -V
#$ -cwd
#$ -N ChIP_Control
#$ -l h_rt=120:00:00
#$ -l s_rt=120:00:00
#$ -l h_vmem=4G
#$ -l s_vmem=4G
#$ -pe smp 10
#$ -q all.q

module load java anaconda3 
source activate encode-chip-seq-pipeline

caper run \
	/common/genomics-core/apps/chip-seq-pipeline2/chip.wdl \
	-c /common/genomics-core/apps/chip-seq-pipeline2/.caper/default.conf \
        -i example_input_json/AGCT_Example.json 


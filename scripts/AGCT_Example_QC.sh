#!/bin/bash -l
#$ -j y
#$ -o ./logs/
#$ -V
#$ -cwd
#$ -N ChIP_QC
#$ -q all.q
#$ -pe smp 10

# This script will need to be heavily modified to point to the correct files for you ENTIRE experiment, but it does 3 major things
# 1. Runs Croo to organize the outputs of hte pipeline. It makes copies, so you can delete the original pipeline output
# 2. Creates a QC table with pared down information about the samples
# 3. Makes Fingerprint plots for each experiment. This requires creating BAM indicies, which may be useful for deliver to the researcher if they ask for BAM files


module load java anaconda3 
source activate encode-chip-seq-pipeline

# Run Croo
croo Cnt_ac/chip/77b72baa-cfb3-43b3-bf72-0c55e712ebfa/metadata.json \
	--out-dir Cnt_ac/Croo_Summary \
	--method copy
croo Cnt_me2/chip/c126ac38-94f9-43a9-96ba-90450e108aca/metadata.json \
        --out-dir Cnt_me2/Croo_Summary \
        --method copy
croo D2HG_ac/chip/072964d3-85a9-49c1-93d8-02ec572f5f9e/metadata.json \
        --out-dir D2HG_ac/Croo_Summary \
        --method copy
croo D2HG_me2/chip/dcb629c4-1a48-47a1-a60a-73d48f242ef0/metadata.json \
        --out-dir D2HG_me3/Croo_Summary \
        --method copy

# Run qc2tsv
qc2tsv \
	Cnt_ac/Croo_Summary/qc/qc.json \
	Cnt_me2/Croo_Summary/qc/qc.json \
        D2HG_ac/Croo_Summary/qc/qc.json \
        D2HG_me3/Croo_Summary/qc/qc.json  > QC_Summary.tsv

# Make Fingerprint
## Index BAM
for f in **/Croo_Summary/align/**/*.nodup.bam; do 
	samtools index \
		-@10 \
		$f 
done

## Make Plot
plotFingerprint \
	-b Cnt_ac/Croo_Summary/align/**/*.nodup.bam \
	--labels Input1 Input2 Input3 Rep1 Rep2 Rep3  \
	--minMappingQuality 30 \
	--skipZeros  \
	-T "Fingerprints of Cnt H3K9ac Samples" \
	-p 10 \
	--plotFile Cnt_ac/Fingerprint_Cnt_H3K9ac.png \
	--outRawCounts Cnt_ac/Fingerprint_Cnt_H3K9ac.tab

plotFingerprint \
        -b Cnt_me2/Croo_Summary/align/**/*.nodup.bam \
        --labels Input1 Input2 Input3 Rep1 Rep2 Rep3  \
        --minMappingQuality 30 \
        --skipZeros  \
        -T "Fingerprints of Cnt H3K9me2 Samples" \
        -p 10 \
        --plotFile Cnt_me2/Fingerprint_Cnt_H3K9me2.png \
        --outRawCounts Cnt_me2/Fingerprint_Cnt_H3K9me2.tab

plotFingerprint \
        -b D2HG_ac/Croo_Summary/align/**/*.nodup.bam \
        --labels Input1 Input2 Input3 Rep1 Rep2 Rep3  \
        --minMappingQuality 30 \
        --skipZeros  \
        -T "Fingerprints of D2HG H3K9ac Samples" \
        -p 10 \
        --plotFile D2HG_ac/Fingerprint_D2HG_H3K9ac.png \
        --outRawCounts D2HG_ac/Fingerprint_D2HG_H3K9ac.tab

plotFingerprint \
        -b D2HG_me2/Croo_Summary/align/**/*.nodup.bam \
        --labels Input1 Input2 Input3 Rep1 Rep2 Rep3  \
        --minMappingQuality 30 \
        --skipZeros  \
        -T "Fingerprints of D2HG H3K9me2 Samples" \
        -p 10 \
        --plotFile D2HG_me2/Fingerprint_D2HG_H3K9me2.png \
        --outRawCounts D2HG_me2/Fingerprint_D2HG_H3K9me2.tab


version 1.0
import '../../../chip.wdl' as chip
import 'compare_md5sum.wdl' as compare_md5sum

workflow test_reproducibility {
    input {
        String se_overlap_peak_rep1_vs_rep2
        String se_overlap_peak_rep1_pr
        String se_overlap_peak_rep2_pr
        String se_overlap_peak_ppr
        String se_chrsz

        String ref_se_reproducibility_qc
    }

    call chip.reproducibility as se_reproducibility { input :
        prefix = 'overlap',
        peaks = [se_overlap_peak_rep1_vs_rep2],
        peaks_pr = [se_overlap_peak_rep1_pr, se_overlap_peak_rep2_pr],
        peak_ppr = se_overlap_peak_ppr,
        peak_type = 'regionPeak',        
        chrsz = se_chrsz,        
    }

    call compare_md5sum.compare_md5sum { input :
        labels = [
            'se_reproducibility',
        ],
        files = [
            se_reproducibility.reproducibility_qc,
        ],
        ref_files = [
            ref_se_reproducibility_qc,
        ],
    }
}

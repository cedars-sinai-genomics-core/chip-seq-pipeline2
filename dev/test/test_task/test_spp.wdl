version 1.0
import '../../../chip.wdl' as chip
import 'compare_md5sum.wdl' as compare_md5sum

workflow test_spp {
    input {
        Int cap_num_peak

        Int fraglen
        # test spp for SE set only
        String se_ta
        String se_ctl_ta

        String ref_se_spp_rpeak # raw narrow-peak
        String ref_se_spp_bfilt_rpeak # blacklist filtered narrow-peak
        String ref_se_spp_frip_qc

        String se_blacklist
        String se_chrsz
    }

    String regex_bfilt_peak_chr_name = 'chr[\\dXY]+'

    Int spp_cpu = 1
    Float spp_mem_factor = 0.0
    Int spp_time_hr = 72
    Float spp_disk_factor = 5.0

    call chip.call_peak as se_spp { input :
        peak_caller = 'spp',
        peak_type = 'regionPeak',
        gensz = se_chrsz,
        pval_thresh = 0.0,
        tas = [se_ta, se_ctl_ta],
        chrsz = se_chrsz,
        fraglen = fraglen,
        cap_num_peak = cap_num_peak,
        blacklist = se_blacklist,
        regex_bfilt_peak_chr_name = regex_bfilt_peak_chr_name,

        cpu = spp_cpu,
        mem_factor = spp_mem_factor,
        time_hr = spp_time_hr,
        disk_factor = spp_disk_factor,
    }

    call compare_md5sum.compare_md5sum { input :
        labels = [
            'se_spp_rpeak',
            'se_spp_bfilt_rpeak',
            'se_spp_frip_qc',
        ],
        files = [
            se_spp.peak,
            se_spp.bfilt_peak,
            se_spp.frip_qc,
        ],
        ref_files = [
            ref_se_spp_rpeak,
            ref_se_spp_bfilt_rpeak,
            ref_se_spp_frip_qc,
        ],
    }
}

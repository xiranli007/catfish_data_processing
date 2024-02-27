CONTIGS, = glob_wildcards("amr_detection/arg_contigs/{contig}.fa")
rule all:
    input:expand('amr_detection/arg_contigs_annot/ncbi/{contig}.tab', contig=CONTIGS)
rule abricate:
    input: "amr_detection/arg_contigs/{contig}.fa"
    output:"amr_detection/arg_contigs_annot/ncbi/{contig}.tab"
    threads: 10
    params:
        db="ncbi"
    shell:
        "abricate --db {params.db} --threads {threads} --quiet {input} > {output}" 
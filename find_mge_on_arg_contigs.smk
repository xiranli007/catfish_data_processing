CONTIGS, = glob_wildcards("amr_detection/arg_contigs/{contig}.fa")
rule all:
    input:expand("amr_detection/mge_in_arg_contigs/results/{contig}.lgt.tsv", contig=CONTIGS)

rule waafle_search:
    input:"amr_detection/arg_contigs/{contig}.fa"
    output:"amr_detection/mge_in_arg_contigs/{contig}.blastout"
    params:
        outdir="amr_detection/mge_in_arg_contigs",
        db="waafle/waafle_db/waafled "
    shell:
        "waafle_search {input} --out {params.outdir} {params.db}"

rule gene_caller:
    input: "amr_detection/mge_in_arg_contigs/{contig}.blastout"
    output:"amr_detection/mge_in_arg_contigs/{contig}.gff"
    shell:
        "waafle_genecaller {input}"
rule waafle_orgscorer:
    input:
        contig="amr_detection/arg_contigs/{contig}.fa",
        blastout="amr_detection/mge_in_arg_contigs/{contig}.blastout",
        gff="amr_detection/mge_in_arg_contigs/{contig}.gff"
    params:
        tax="waafle/waafle_db/waafledb_taxonomy.tsv",
        outdir="amr_detection/mge_in_arg_contigs/results"
    output:
        "amr_detection/mge_in_arg_contigs/results/{contig}.lgt.tsv"
    shell:
        "waafle_orgscorer {input.contig} {input.blastout} {input.gff} {params.tax} --outdir {params.outdir}"




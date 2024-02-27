SAMPLES, = glob_wildcards("assembly_per_sample/long_contigs/{sample}-1000.contigs.fa")
rule all:
    input:expand('assembly_per_sample/long_contigs/arg_annot_long_contigs/megares/{sample}-1000-arg-annot.tab', sample=SAMPLES)
rule abricate:
    input: "assembly_per_sample/long_contigs/{sample}-1000.contigs.fa"
    output:"assembly_per_sample/long_contigs/arg_annot_long_contigs/megares/{sample}-1000-arg-annot.tab"
    threads: 15
    params:
        db="megares"
    shell:
        "abricate --db {params.db} --threads {threads} --quiet {input} > {output}" 
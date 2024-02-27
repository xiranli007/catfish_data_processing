SAMPLES, = glob_wildcards("assembly_per_sample/long_contigs/{sample}-1000.contigs.fa")
rule all:
    input:expand("integron_finder/Results_Integron_Finder_{sample}-1000.contigs", sample=SAMPLES)
rule integron_finder:
    input:"assembly_per_sample/long_contigs/{sample}-1000.contigs.fa"
    output:directory("integron_finder/Results_Integron_Finder_{sample}-1000.contigs")
    shell:
        "integron_finder --local-max --func-annot --outdir {output} --pdf --gbk -q {input}"

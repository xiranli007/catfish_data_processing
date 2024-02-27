(SAMPLES,) = glob_wildcards("assembly_per_sample/{sample}_assembly")
rule all:
    input: expand("assembly_per_sample/long_contigs/{sample}-1000.contigs.fa", sample = SAMPLES)

rule gather_contigs:
    input: "assembly_per_sample/{sample}_assembly/final.contigs.fa"
    output:"assembly_per_sample/contigs/{sample}.contigs.fa"
    shell:"""
        mv {input} {output}
    """

rule extract_long_contigs:
    input: "assembly_per_sample/contigs/{sample}.contigs.fa"
    output:"assembly_per_sample/long_contigs/{sample}-1000.contigs.fa"
    shell:"""
        bioawk -c fastx '{{if(length($seq) > 1000) {{print ">"$name; print $seq }}}}' {input} > {output}
    """
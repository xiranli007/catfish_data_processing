(SAMPLES,) = glob_wildcards("host_rm_reads/splited_reads/SE/{sample,[^/]+}.host_rm_R1.fq")
rule all: 
    input:expand("assembly_per_sample/{sample}_assembly", sample = SAMPLES)

rule assembly:
    input: "host_rm_reads/splited_reads/SE/{sample}.host_rm_R1.fq",
    output: directory ("assembly_per_sample/{sample}_assembly")
    threads: 8
    shell:"""
        megahit -r {input} -o {output} -t {threads}
    """
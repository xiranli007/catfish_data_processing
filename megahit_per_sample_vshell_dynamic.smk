(SAMPLES,) = glob_wildcards("host_rm_reads/splited_reads/temp4/{sample,[^/]+}.host_rm_R1.fq")
rule all: 
    input:expand("assembly_per_sample/{sample}_assembly", sample = SAMPLES)

rule assembly:
    input: 
            r1 = "host_rm_reads/splited_reads/temp4/{sample}.host_rm_R1.fq",
            r2 = "host_rm_reads/splited_reads/temp4/{sample}.host_rm_R2.fq",
    #params:
        # the minimum length for contigs (smaller contigs will be discarded)
        #min_contig_len = 1000
    #output:"assembly_per_sample/{sample}_assembly/final.contigs.fa"
    output: directory ("assembly_per_sample/{sample}_assembly")
    threads: 24
    shell:"""
        megahit -1 {input.r1} -2 {input.r2} -o {output} -t {threads}
    """

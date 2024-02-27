SAMPLES, = glob_wildcards("raw_data/single_end/{sample}_R1.fastq.gz")
rule all:
    input:expand("host_rm_reads/splited_reads/SE/{sample}.host_rm_R1.fq",sample=SAMPLES)
rule quality_trim:
    message:"Trims given paired-end reads with given parameters"
    input: 
        data="raw_data/single_end/{sample}_R1.fastq.gz",
        adapters = "/home/xiran007/miniforge3/pkgs/trimmomatic-0.39-hdfd78af_2/share/trimmomatic-0.39-2/adapters/TruSeq3-SE.fa", 
    output: "trimmed/SE/{sample}_R1.trimmed.fastq.gz",
    shell:
        """
        trimmomatic SE -phred33 {input.data} {output} ILLUMINACLIP:{input.adapters}:2:30:10:2:true LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36   
        """
rule remove_host:
    message: "map the trimmed reads to host genome for further host removal,indexing the host genome can speed up the mapping process"
    input:
        R1 = "trimmed/SE/{sample}_R1.trimmed.fastq.gz",
        ref = "host/catfish_genome.fna"
    output: 
        sam = "host_rm_reads/sam/SE/{sample}.x.catfish_genome.sam",
        bam = "host_rm_reads/bam/SE/{sample}.x.catfish_genome.bam",
    shell: """
        minimap2 -d catfishgenome.mmi {input.ref}
        minimap2 -ax sr {input.ref} {input.R1} > {output.sam}
        samtools view -bS {output.sam} > {output.bam}
    """
rule sam_to_bam:
    message:"convert sam to bam to extract host genome"
    input:"host_rm_reads/bam/SE/{sample}.x.catfish_genome.bam"
    output:
        unmapped_bam= "host_rm_reads/unmapped_bam/SE/{sample}.x.catfish_genome_unmapped.bam",
        sorted_bam = "host_rm_reads/sorted_filtered_bam/SE/{sample}.x.catfish_genome_unmapped.bam.sorted"
    shell: """
        samtools view -f 4 -F 256 {input} > {output.unmapped_bam}
        samtools sort {output.unmapped_bam} > {output.sorted_bam}
    """
rule bam_to_fastq:
    message: "convert sorted bam file to fastq file"
    input: "host_rm_reads/sorted_filtered_bam/SE/{sample}.x.catfish_genome_unmapped.bam.sorted"
    output:"host_rm_reads/splited_reads/SE/{sample}.host_rm_R1.fq",
    shell: """
        samtools fastq {input} > {output}
    """
        
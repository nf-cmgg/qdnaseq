process CREATE_ANNOTATIONS {
    tag "$bin_size"
    label 'process_single'

    container "quay.io/cmgg/qdnaseq:0.0.1"

    input:
    val(bin_size)
    tuple val(meta), path(bams, stageAs:"bams/*"), path(bais, stageAs:"bams/*")
    tuple val(meta2), path(bigwig)
    tuple val(meta3), path(blacklist)

    output:
    tuple val(meta), path("*.rda"), emit: annotation
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    template "create_annotations.R"

    stub:
    def prefix = task.ext.prefix ?: "${params.genome}.${bin_size}kbp"

    """
    touch ${prefix}.rda

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bioconductor-qdnaseq: 1.34.0
        bioconductor-biobase: 2.58.0
        ucsc-bigwigaverageoverbed: 377
    END_VERSIONS
    """
}
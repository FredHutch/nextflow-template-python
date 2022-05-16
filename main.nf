#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// The container used to run the script
params.container = "quay.io/hdc-workflows/python-pandas:v1.2.1_latest"

// The default values for all parameters
params.output = false
params.input_csv = false
params.string_to_append = "PREFIX-"

// Define the process which will be used to run the script
process run_script {
    container "${params.container}"
    publishDir "${params.output}", mode: "copy", overwrite: true

    input:
    path input_csv

    output:
    path "*"

    script:
    template "script.py"
}

workflow {

    // Raise an error if the expected parameters were not found
    if (!params.output){error "Must provide parameter 'output'"}
    if (!params.input_csv){error "Must provide parameter 'input_csv'"}

    // Raise an error if the input file can't be found
    input_csv = file("${params.input_csv}", checkIfExists: true)

    // Run the process on that file
    run_script(input_csv)

}
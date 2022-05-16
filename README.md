# Nextflow Template – Python
Template repository for running a Python script in Nextflow

## Structure

The workflow in this repository will take in a single file as an input, run a Python script, and publish any file saved by the script.

The Python script itself is saved in `templates/script.py` as native Python code, with one added nuance.
The input file and parameters are referenced in the script with the syntax `${}`.
The path to the file specified with the `input_csv` parameter is referenced in the script at `"${input_csv}"`
Any files or parameters specified with that syntax will be replaced by Nextflow with the appropriate value immediately prior to running the script.
This allows you to run the script on any file, without having to hard-code the filename in the script.

## Parameters

The parameters used to run the template workflow are:

 - `input_csv`: The path to the file which is read by the script
 - `output`: The folder in which all output files will be saved
 - `string_to_append`: A user-provided string which will be appended to every value in the input CSV

## Modifying the workflow

Here is a simple guide to the most basic modifications which can be made to this workflow.

### Dependencies

The dependencies used by `script.py` are provided using a [Docker](docker.io) container in which all needed libraries are installed.
The template script uses the [`pandas` library](https://pandas.pydata.org/), which is installed in the Docker image [`quay.io/hdc-workflows/python-pandas:v1.2.1_latest` available on Quay](https://quay.io/repository/hdc-workflows/python-pandas?tab=builds).

To use a different Docker image, simply modify the contents of `params.container = ""` in `main.nf`.

### Parameters

To add any additional parameters to the workflow, simply reference those parameters in the script as `${params.param_name}` where `param_name` is the name of the parameter which you have added.
Those parameters do not need to be pre-defined in any other location, although it is probably a good idea to document them.

### Files

To extend this template to use multiple input files, simply choose a parameter name to use for the second file and add code for it which follows the pattern used for the first input file.

To add a second input file with the parameter name `second_input_csv`, modify `main.nf` with:

```
// Raise an error if the second input CSV wasn't specified by the user
second_input_csv = file("${params.second_input_csv}", checkIfExists: true)

// Run the process on both files
run_script(input_csv, second_input_csv)
```

And then modify the `run_script` process to take two file inputs:

```
process run_script {
    container "${params.container}"
    publishDir "${params.output}", mode: "copy", overwrite: true

    input:
    path input_csv
    path second_input_csv
```

## Contact Us

For any questions on the example shown in this workflow, please be in touch [by email](mailto:hutchdatacore@fredhutch.org).

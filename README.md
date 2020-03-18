# FixDiscrep

Perl script to streamline the process of correction discrepancies in mulitple prokaryotic genomes

## Warnings

This is done for me using specific command line/options along with the errors I encountered during this process.

## Prerequisites

* [prokka](https://github.com/tseemann/prokka) annotations made with the "--compliant and --centre XXX" options.
* a [template](https://www.ncbi.nlm.nih.gov/WebSub/template.cgi) file for each genome with the .sbt extension
* [BLAST+](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/)

## Softwares

* [prokka](https://github.com/tseemann/prokka)
* [tbl2asn](https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/)
* [asndisc](https://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/asndisc/)
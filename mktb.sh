#! /bin/sh

#####################################################
# Name: mktb.sh
#
# Creates the skeleton of a Verilog testbench
#
# Usage: mktb.sh <name of the module to test>
#
# Date of Creation: 2019-08-30
#
# Author: Till Mahlburg
# License: GPLv3
######################################################

# Functions

usage () {
cat <<- EOF
usage: $(basename $0) <name of the module> [-h]

Creates the skeleton of a Verilog testbench.

OPTIONS:
    -h shows this help
EOF
}

tb () {
cat << EOF
/*
 * $1_tb.v: Test bench for $1.v
 * author: Till Mahlburg
 * year: $(date +%Y)
 * license: ISC
 *
 */

\`timescale 1 ns / 1 ps

module $1_tb ();
	reg reset;

	integer pass;
	integer fail;

	/* adjust according to the number of test cases */
	localparam tests = ;

	$1 dut(
	);

	initial begin
		\$dumpfile("$1_tb.vcd");
		\$dumpvars(0, $1_tb);

		reset = 0;

		pass = 0;
		fail = 0;

		#10;
		reset = 1;
		#10;

		/* TEST CASES */

		if ((pass + fail) == tests) begin
			\$display("PASSED: number of test cases");
			pass = pass + 1;
		end else begin
			\$display("FAILED: number of test cases");
			fail = fail + 1;
		end

		\$display("%0d/%0d PASSED", pass, (tests + 1));
		\$finish;
	end
endmodule
EOF
}

# Main functionality. Evaluates the given arguments.

main () {
    while getopts "h" opt; do
        case $opt in
            h )     usage
            		exit ;;
            \? )    usage
                    exit 1 ;;
            esac
    done
    shift $((OPTIND - 1))

    tb "$@"

}
main "$@"

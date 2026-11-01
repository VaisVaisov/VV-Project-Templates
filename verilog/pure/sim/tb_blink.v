// Testbench for the blink module.
// Run: task "Sim: iverilog (build + run)" (produces build/dump.vcd)
`timescale 1ns/1ps
`default_nettype none

module tb_blink;
    // Small clock frequency for a fast simulation
    localparam integer CLK_HZ  = 100;
    localparam integer BLINK_HZ = 10;

    reg  clk = 1'b0;
    reg  rst_n = 1'b0;
    wire led;

    blink #(
        .CLK_HZ  (CLK_HZ),
        .BLINK_HZ(BLINK_HZ)
    ) dut (
        .clk  (clk),
        .rst_n(rst_n),
        .led  (led)
    );

    // 10 ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/dump.vcd");
        $dumpvars(0, tb_blink);

        #20 rst_n = 1'b1;

        // Run long enough to see several toggles, then finish
        #2000;
        $display("tb_blink: done, led=%0b", led);
        $finish;
    end
endmodule

`default_nettype wire

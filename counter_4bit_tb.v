`timescale 1ns/1ps

module counter_4bit_tb;
    reg clk;
    reg rst;
    wire [3:0]count;

    counter_4bit dut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("counter_4bit.vcd");
        $dumpvars(0, counter_4bit_tb);
    end
    
    initial begin
        rst = 1'b1;

        #12 rst = 0;
        #20 rst = 1;
        #5 rst = 0;

    #200 $finish;

    end
    initial begin
        $monitor ("time=%0t reset=%b clk=%b count=%b", $time, rst, clk, count);
    end

endmodule
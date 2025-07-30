module tb_PulseTracer;

    logic clk = 0;             // Clock
    logic rst_n;               // Reset
    logic noisy_in;            // Test signal input
    logic pulse_out;           // Output from DUT

    // Instantiate the PulseTracer module
    PulseTracer dut (
        .clk(clk),
        .rst_n(rst_n),
        .noisy_in(noisy_in),
        .pulse_out(pulse_out)
    );

    // Clock generator: 10ns period
    always #5 clk = ~clk;

    initial begin
       $dumpfile("dump.vcd");           // Enable waveform dump
    $dumpvars(0, tb_PulseTracer);    // Dump all variables from testbench
        rst_n = 0; noisy_in = 0; // Initial conditions
        #10 rst_n = 1;           // Deassert reset

        #10 noisy_in = 1;        // Clean high
        #10 noisy_in = 0;        // Back low

        #5  noisy_in = 1;        // Short glitch
        #2  noisy_in = 0;        // Back low quickly

        #20 $finish;             // End simulation
    end

    // Display monitored signals
    always @(posedge clk)
        $display("Time: %t | noisy_in: %b | pulse_out: %b", $time, noisy_in, pulse_out);

endmodule

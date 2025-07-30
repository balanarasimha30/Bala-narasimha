module PulseTracer (
    input  logic clk,          // Clock input
    input  logic rst_n,        // Active-low asynchronous reset
    input  logic noisy_in,     // Noisy input signal (can glitch)
    output logic pulse_out     // Clean one-cycle pulse on rising edge
);

    logic sync_0, sync_1;      // Two flip-flops for input synchronization

    // Synchronizer stage 1 and 2 to remove glitches
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_0 <= 1'b0;     // Reset first stage
            sync_1 <= 1'b0;     // Reset second stage
        end else begin
            sync_0 <= noisy_in; // Capture noisy input in stage 1
            sync_1 <= sync_0;   // Stage 2 receives filtered signal
        end
    end

    // Pulse generation logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pulse_out <= 1'b0;  // Reset pulse output
        else
            pulse_out <= (sync_0 & ~sync_1); // Output high for 1 cycle on rising edge
    end

endmodule

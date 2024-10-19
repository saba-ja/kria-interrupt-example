module debouncer_tb();

// Parameters
parameter STABLE_COUNT = 16;

// Signals for testing
logic clk;
logic rst_n;
logic btn;
logic btn_pls_out;

// Instantiate the debouncer module
debouncer #(.STABLE_COUNT(STABLE_COUNT)) uut (
    .clk(clk),
    .rst_n(rst_n),
    .btn(btn),
    .btn_pls_out(btn_pls_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz clock
end

// Test sequence
initial begin
    // Initialize signals
    rst_n = 0;
    btn = 0;

    // Apply reset
    #20 rst_n = 1;

    // Case 1: Button pressed for less than STABLE_COUNT cycles (no stable pulse)
    btn = 1;
    #40;  // Button press for less than STABLE_COUNT
    btn = 0;
    #20;  // Wait and check

    // Case 2: Button pressed for exactly STABLE_COUNT cycles (stable pulse should occur)
    btn = 1;
    #((STABLE_COUNT + 2) * 10); // Button press for more than STABLE_COUNT
    btn = 0;
    #40; // Wait and check

    // Case 3: Button pressed again after stable pulse (another stable pulse should occur)
    #50 btn = 1;
    #((STABLE_COUNT + 2) * 10); // Button press again for more than STABLE_COUNT
    btn = 0;
    #50;

    // Case 4: Button debounced multiple times before becomming stable
    repeat(4) begin
        #((STABLE_COUNT + 2) * 2); 
        btn = 0;
        #((STABLE_COUNT + 2) * 2); 
        btn = 1;
    end
    #((STABLE_COUNT + 2) * 10); // Button press again for more than STABLE_COUNT
    btn = 0;

    #1000; // Wait for a long time and try again
    // Case 5: repeate of case 4 after a long wait
    repeat(4) begin
        #((STABLE_COUNT + 2) * 2); 
        btn = 0;
        #((STABLE_COUNT + 2) * 2); 
        btn = 1;
    end
    #((STABLE_COUNT + 2) * 10); // Button press again for more than STABLE_COUNT
    btn = 0;
    #1000; // Wait for a long time and try again
    // End simulation
    $finish;
end

// Monitor signals
initial begin
    $monitor("Time: %0t | clk: %b | rst_n: %b | btn: %b | btn_pls_out: %b", 
             $time, clk, rst_n, btn, btn_pls_out);
end

endmodule


module top_module(
    input        btn,
    output [3:0] leds
);

// -----------------------------------------------------------------------------
// Local parameters
// -----------------------------------------------------------------------------
    localparam integer DEBOUNCE_WAIT = 2_500_000; // 25 mSec in 100 MHz clk

// -----------------------------------------------------------------------------
// Local variables
// -----------------------------------------------------------------------------
    logic clk_100mhz;
    logic rst_n;
    logic btn_pls;

// -----------------------------------------------------------------------------
// Module instantiations
// -----------------------------------------------------------------------------
    debouncer #(
        .DEBOUNCE_WAIT(DEBOUNCE_WAIT)
    ) debouncer_i (
        .clk(clk_100mhz),
        .rst_n(rst_n),
        .btn(btn),
        .btn_pls_out(btn_pls)  // Single pulse when button press is stable
    );

    system system_i (
        .clk_100mhz(clk_100mhz),
        .rst_n(rst_n),
        .leds(leds),
        .btn(btn_pls)        
    );

endmodule

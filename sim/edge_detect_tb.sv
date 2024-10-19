module edge_detect_tb;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic sig;
    logic r_edge;
    logic f_edge;

    // Instantiate the edge_detect module
    edge_detect uut (
        .clk    (clk),
        .rst_n  (rst_n),
        .sig    (sig),
        .r_edge (r_edge),
        .f_edge (f_edge)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Testbench tasks
    task reset();
        begin
            rst_n = 0;
            #10;
            rst_n = 1;
            #10;
        end
    endtask

    task check_edges(input logic expected_r_edge, input logic expected_f_edge);
        begin
            // Assert the expected r_edge and f_edge values
            assert (r_edge == expected_r_edge) 
                else $error("Rising edge error: expected = %b, actual = %b", expected_r_edge, r_edge);
            assert (f_edge == expected_f_edge) 
                else $error("Falling edge error: expected = %b, actual = %b", expected_f_edge, f_edge);
        end
    endtask

    // Stimulus
    initial begin
        // Initialize signals
        sig = 0;
        // Apply reset
        reset();
        #10;
        // Test case 1: No edge, sig remains 0
        sig = 0;
        #10;
        check_edges(0, 0);

        // Test case 2: Rising edge, sig changes from 0 to 1
        sig = 1;
        #10;
        check_edges(1, 0);

        // Test case 3: No edge, sig remains 1
        #10;
        check_edges(0, 0);

        // Test case 4: Falling edge, sig changes from 1 to 0
        sig = 0;
        #10;
        check_edges(0, 1);

        // Test case 5: Rising edge again
        sig = 1;
        #10;
        check_edges(1, 0);

        // Test case 6: Falling edge again
        sig = 0;
        #10;
        check_edges(0, 1);

        // Finish the simulation
        #20;
        $finish;
    end
endmodule


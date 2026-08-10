`timescale 1ns/1ns
module fifo_sync_tb;
    parameter FIFO_DEPTH = 8, DATA_WIDTH = 32;
    reg clk, cs, rst_n, wr_en, rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    reg [DATA_WIDTH-1:0] expected_queue [0:255];
    wire [DATA_WIDTH-1:0] data_out;
    wire empty, full;
    integer i, error_count = 0, wr_idx = 0, rd_idx = 0;
    fifo_sync #(.FIFO_DEPTH(FIFO_DEPTH), .DATA_WIDTH(DATA_WIDTH)) 
    dut (
        .clk(clk),
        .cs(cs),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full));
    always #5 clk = ~clk;
    task write_data(input [DATA_WIDTH-1:0] d_in);
    begin
        @(posedge clk);
        if (!full)
        begin
            cs = 1; wr_en = 1; rd_en = 0; data_in = d_in;
            expected_queue[wr_idx] = d_in;
            wr_idx = wr_idx + 1;
            $display("[%0t ns] WRITE: %0d | Full=%b Empty=%b", $time, d_in, full, empty);
            @(posedge clk);
            wr_en = 0;
        end else
            $display("[%0t ns] WRITE BLOCKED (FULL): %0d", $time, d_in);
    end
    endtask
    task read_data();
        reg [DATA_WIDTH-1:0] exp_val;
    begin
        @(posedge clk);
        if (!empty)
        begin
            cs = 1; rd_en = 1; wr_en = 0;
            exp_val = expected_queue[rd_idx];
            rd_idx = rd_idx + 1;
            @(posedge clk);
            rd_en = 0;
            #1;
            if (data_out === exp_val)
                $display("[%0t ns] READ OK: %0d | Full=%b Empty=%b", $time, data_out, full, empty);
            else
                begin
                $display("[%0t ns] ERROR: Exp %0d, Got %0d", $time, exp_val, data_out);
                error_count = error_count + 1;
                end
        end else
            $display("[%0t ns] READ BLOCKED (EMPTY)", $time);
    end
    endtask
    task write_and_read(input [DATA_WIDTH-1:0] d_in);
        reg [DATA_WIDTH-1:0] exp_val;
    begin
        @(posedge clk);
        cs = 1; wr_en = 1; rd_en = 1; data_in = d_in;
        if (!full || !empty)
        begin
            expected_queue[wr_idx] = d_in;
            wr_idx = wr_idx + 1;
        end
        if (!empty)
        begin
            exp_val = expected_queue[rd_idx];
            rd_idx = rd_idx + 1;
        end
        $display("[%0t ns] SIMULTANEOUS W/R: wr=%0d", $time, d_in);
        @(posedge clk);
        wr_en = 0; rd_en = 0;
        #1;
        if (!empty)
        begin
            if (data_out === exp_val)
                $display("[%0t ns] SIM-READ OK: %0d", $time, data_out);
            else
                begin
                $display("[%0t ns] ERROR Sim-Read: Exp %0d, Got %0d", $time, exp_val, data_out);
                error_count = error_count + 1;
                end
        end
    end
    endtask
    initial
     begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_sync_tb);
        clk = 0; cs = 0; rst_n = 0; wr_en = 0; rd_en = 0; data_in = 0;
        #20 rst_n = 1; #10;
        write_data(101); read_data();
        write_data(102); read_data();
        write_data(201); write_data(202); write_data(203);

        read_data();
        write_data(204); write_data(205); write_data(206);
        read_data(); read_data(); read_data();

        for (i = 1; i <= 9; i = i + 1) write_data(900 + i);
        while (!empty) read_data();

        for (i = 1; i <= 5; i = i + 1) write_data(300 + i);
        for (i = 1; i <= 5; i = i + 1) read_data();
        for (i = 6; i <= 10; i = i + 1) write_data(300 + i);
        while (!empty) read_data();

        write_data(401); write_data(402);
        write_and_read(403);
        while (!empty) read_data();
        #20;
        if (error_count == 0) $display("SUCCESS: ALL TESTS PASSED");
        else $display("FAILURE: %0d ERRORS FOUND", error_count);
        $finish;
     end
endmodule
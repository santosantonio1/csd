module top (
    input  logic clk,
    input  logic rst,
    
    input  logic start_i,
    input  logic stop_i,
    input  logic split_i,
    
    output logic[7:0] dec_cat,
    output logic[7:0] an
);

    logic start_c, stop_c, split_c;
    logic en_timer, carry, update, display_en250ms, display_en;
    logic[3:0]  CSEG0, CSEG1, SEG0, SEG1, MIN0, MIN1, HOUR0, HOUR1;
    logic[3:0]  CSEG0_D, CSEG1_D, SEG0_D, SEG1_D, 
                MIN0_D, MIN1_D, HOUR0_D, HOUR1_D;

    logic   clk_100hz, clk_250ms, clk_split;

    assign display_en = (update) ? 1'b1 : display_en250ms;

    debouncer DEB_START (
        .clk    (clk),
        .rst    (rst),
        .noisy  (start_i),
        .clean  (start_c)
    ); 

    debouncer DEB_STOP (
        .clk    (clk),
        .rst    (rst),
        .noisy  (stop_i),
        .clean  (stop_c)
    ); 

    debouncer DEB_SPLIT (
        .clk    (clk),
        .rst    (rst),
        .noisy  (split_i),
        .clean  (split_c)
    ); 

    fsm MAIN_FSM (
        .clk        (clk),
        .rst        (rst),
        .start_i    (start_c),
        .stop_i     (stop_c),
        .split_i    (split_c),
        .en_o       (en_timer),
        .update_o   (update)
    );

    clk_gen #(
        .TIME_V     (32'd50_000)
    ) CLOCK100HZ (
        .clk        (clk),
        .rst        (rst),
        .clk_o      (clk_100hz)
    );
    
    clk_gen #(
        //.TIME_V     (32'd2_500_000)
        .TIME_V     (32'd12_500_000)
    ) CLOCK250MS (
        .clk        (clk),
        .rst        (rst),
        .clk_o      (clk_250ms)
    );

    counter TIMER (
        .clk        (clk_100hz),
        //.clk        (clk),
        .rst        (rst),
        .en_i       (en_timer),
        .carry_o    (carry)
    );
    
    display_counter DISPLAY_COUNTER (
        .clk            (clk_100hz),
        //.clk            (clk),
        .rst            (rst),
        .carry_i        (carry),
        .CSEG0_o        (CSEG0),
        .CSEG1_o        (CSEG1),
        .SEG0_o         (SEG0),
        .SEG1_o         (SEG1),
        .MIN0_o         (MIN0),
        .MIN1_o         (MIN1),
        .HOUR0_o        (HOUR0),
        .HOUR1_o        (HOUR1) 
    );

    display_manager DISPLAY_MANAGER (
        .clk_1          (clk_100hz),
        .clk_2          (clk_250ms),
        .rst            (rst), 
        .update_i       (update),
        .CSEG0_i        (CSEG0),
        .CSEG1_i        (CSEG1),
        .SEG0_i         (SEG0),
        .SEG1_i         (SEG1),
        .MIN0_i         (MIN0),
        .MIN1_i         (MIN1),
        .HOUR0_i        (HOUR0),
        .HOUR1_i        (HOUR1),
        .display_en_o   (display_en250ms),
        .CSEG0_o        (CSEG0_D),
        .CSEG1_o        (CSEG1_D),
        .SEG0_o         (SEG0_D),
        .SEG1_o         (SEG1_D),
        .MIN0_o         (MIN0_D),
        .MIN1_o         (MIN1_D),
        .HOUR0_o        (HOUR0_D),
        .HOUR1_o        (HOUR1_D)         
    );

    display DISPLAY_7_SEG (
        .clock      (clk),
        .reset      (rst),
        .d1         ({display_en, HOUR1_D,  1'b0}),
        .d2         ({display_en, HOUR0_D,  display_en}),
        .d3         ({display_en, MIN1_D,   1'b0}),
        .d4         ({display_en, MIN0_D,   display_en}),
        .d5         ({display_en, SEG1_D,   1'b0}),
        .d6         ({display_en, SEG0_D,   display_en}),
        .d7         ({display_en, CSEG1_D,  1'b0}),
        .d8         ({display_en, CSEG0_D,  1'b0}),
        .dec_cat    (dec_cat),
        .an         (an)
    );

    ila_0 ILA0 (
        .clk        (clk),
        .probe0     (CSEG0),
        .probe1     (SEG0),
        .probe2     (start_c),
        .probe3     (split_c),
        .probe4     (en_timer)
    );

endmodule

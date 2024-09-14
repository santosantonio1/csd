module display_counter (
    input logic       clk,
    input logic       rst,
    input logic       carry_i,
 
    output logic[3:0] CSEG0_o,
    output logic[3:0] CSEG1_o,
    output logic[3:0] SEG0_o,
    output logic[3:0] SEG1_o,
    output logic[3:0] MIN0_o,
    output logic[3:0] MIN1_o,
    output logic[3:0] HOUR0_o,
    output logic[3:0] HOUR1_o
);

    logic[3:0] CSEG0, CSEG1, SEG0, SEG1, MIN0, MIN1, HOUR0, HOUR1;

    logic   en0, en1, en2, en3, en4, en5, en6, en7;

    assign  en0 = carry_i;
    assign  en1 = (en0 && CSEG0 == 4'd9);
    assign  en2 = (en1 && CSEG1 == 4'd9);
    assign  en3 = (en2 && SEG0  == 4'd9);
    assign  en4 = (en3 && SEG1  == 4'd5);
    assign  en5 = (en4 && MIN0  == 4'd9);
    assign  en6 = (en5 && MIN1  == 4'd5);
    assign  en7 = (en6 && HOUR0    == 4'd9);

    always_ff @(posedge clk or posedge rst) begin
        
        if(rst) begin

            CSEG0       <= '0;
            CSEG1       <= '0;
            SEG0        <= '0;
            SEG1        <= '0;
            MIN0        <= '0;
            MIN1        <= '0;
            HOUR0       <= '0;
            HOUR1       <= '0;

        end
        else begin

            if(en0) begin
                if(CSEG0 == 4'd9)
                    CSEG0 <= '0;
                else
                    CSEG0 <= CSEG0 + 4'd3;
                    // CSEG0 <= CSEG0 + 4'd1;
            end
        
            if(en1) begin
                if(CSEG1 == 4'd9)
                    CSEG1 <= '0;
                else
                    CSEG1 <= CSEG1 + 4'd1;
            end
        
            if(en2) begin
                if(SEG0 == 4'd9)
                    SEG0 <= '0;
                else
                    // SEG0 <= SEG0 + 4'd1;
                    SEG0 <= SEG0 + 4'd3;
            end
        
            if(en3) begin
                if(SEG1 == 4'd5)
                    SEG1 <= '0;
                else
                    SEG1 <= SEG1 + 4'd1;
            end
        
            if(en4) begin
                if(MIN0 == 4'd9)
                    MIN0 <= '0;
                else
                    MIN0 <= MIN0 + 4'd1;
            end
        
            if(en5) begin
                if(MIN1 == 4'd5)
                    MIN1 <= '0;
                else
                    MIN1 <= MIN1 + 4'd1;
            end
        
            if(en6) begin
                if(HOUR0 == 4'd9)
                    HOUR0 <= '0;
                else
                    HOUR0 <= HOUR0 + 4'd1;
            end
        
            if(en7) begin
                if(HOUR1 == 4'd9)
                    HOUR1 <= '0;
                else
                    HOUR1 <= HOUR1 + 4'd1;
            end
        
        end

    end

    assign CSEG0_o      = CSEG0;
    assign CSEG1_o      = CSEG1;
    assign SEG0_o       = SEG0;
    assign SEG1_o       = SEG1;
    assign MIN0_o       = MIN0;
    assign MIN1_o       = MIN1;
    assign HOUR0_o      = HOUR0;
    assign HOUR1_o      = HOUR1;

endmodule

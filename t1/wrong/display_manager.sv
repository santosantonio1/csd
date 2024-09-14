module display_manager (
    input  logic       clk_1,
    input  logic       clk_2,
    input  logic       rst,

    input  logic      update_i,

    input  logic[3:0] CSEG0_i,
    input  logic[3:0] CSEG1_i,
    input  logic[3:0] SEG0_i,
    input  logic[3:0] SEG1_i,
    input  logic[3:0] MIN0_i,
    input  logic[3:0] MIN1_i,
    input  logic[3:0] HOUR0_i,
    input  logic[3:0] HOUR1_i,

    output logic        display_en_o,

    output logic[3:0] CSEG0_o,
    output logic[3:0] CSEG1_o,
    output logic[3:0] SEG0_o,
    output logic[3:0] SEG1_o,
    output logic[3:0] MIN0_o,
    output logic[3:0] MIN1_o,
    output logic[3:0] HOUR0_o,
    output logic[3:0] HOUR1_o
);

    logic[3:0] CSEG0;
    logic[3:0] CSEG1;
    logic[3:0] SEG0;
    logic[3:0] SEG1;
    logic[3:0] MIN0;
    logic[3:0] MIN1;
    logic[3:0] HOUR0;
    logic[3:0] HOUR1;

    logic display_en;

    always_ff @(posedge clk_2 or posedge rst) begin
        
        if(rst)
            display_en <= 1'b0;
        else 
            display_en <= !display_en; 
    
    end

    assign display_en_o = display_en;

    always_ff @(posedge clk_1 or posedge rst) begin

        if(rst) begin
        
            CSEG0   <= '0;
            CSEG1   <= '0;
            SEG0    <= '0;
            SEG1    <= '0;
            MIN0    <= '0;
            MIN1    <= '0;
            HOUR0   <= '0;
            HOUR1   <= '0;            
        
        end
        else begin
        
            if(update_i) begin
                CSEG0   <= CSEG0_i;
                CSEG1   <= CSEG1_i;
                SEG0    <= SEG0_i;
                SEG1    <= SEG1_i;
                MIN0    <= MIN0_i;
                MIN1    <= MIN1_i;
                HOUR0   <= HOUR0_i;
                HOUR1   <= HOUR1_i; 
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
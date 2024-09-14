//----------------------------------------
//
//              COUNTER
//      
//  counts time based on clk period
//
//----------------------------------------

module counter (
    input  logic clk,
    input  logic rst,
    input  logic en_i,
    output logic carry_o
);

    // high when finished counting
    logic       carry_reg;

    // time value
    logic[4:0]  time_reg;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
        
            carry_reg <= 1'b0;
            time_reg  <= 4'd0;

        end 
        else begin
            
            // counting routine

            if(en_i) begin
                if(time_reg < 4'd9) begin
                    
                    time_reg  <= time_reg + 4'd1;
                    carry_reg <= 1'b0;
                
                end else begin
                
                    time_reg  <= 4'd0;
                    carry_reg <= 1'b1;
                
                end
            end
        end
    end

    assign carry_o = carry_reg;

endmodule

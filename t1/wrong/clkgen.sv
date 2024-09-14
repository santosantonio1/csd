module clk_gen #(
    parameter logic[31:0] TIME_V = 32'd50_000
)
(
    input  logic clk,
    input  logic rst,
    output logic clk_o
);

    logic[31:0] clk_counter;
    logic       clk_reg;

    always_ff @(posedge clk or posedge rst) begin
        
        if(rst) begin

            clk_counter <= '0;
            clk_reg <= 1'b0;
        
        end
        else begin
            if(clk_counter != TIME_V)
        
                clk_counter <= clk_counter + 32'd1;
        
            else begin
       
                clk_reg <= !clk_reg;
                clk_counter <= '0;
       
            end
        end

    end

    assign clk_o = clk_reg;

endmodule
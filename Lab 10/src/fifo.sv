
module fifo #(parameter WIDTH = 32, parameter DEPTH = 8)
(
    input  logic clk, rst,

    input  logic wr_en,
    input  logic [WIDTH-1:0] din,
    output logic full,

    input  logic rd_en,
    output logic [WIDTH-1:0] dout,
    output logic empty

);

logic [$clog2(DEPTH)-1:0] read, write;
logic [$clog2(DEPTH):0] count;

sync_ram #(.dwidth(WIDTH),.depth(DEPTH))
memory(
    .clk(clk),
    .w_en(wr_en && !full),
    .r_en(rd_en && !empty),
    .data_in(din),
    .addr_read(read),
    .addr_write(write),
    .data_out(dout)
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        read  <= 0;
        write <= 0;
        count <= 0;
    end
    else begin
        if (wr_en && !full) begin
            write <= write + 1;
        end
        if (rd_en && !empty) begin
            read <= read + 1;
        end

        if ((rd_en && !empty) && (wr_en && !full))
            count <= count;
        else if (rd_en && !empty)
            count <= count - 1;
        else if (wr_en && !full)
            count <= count + 1;
                
    end
end

assign full = (count == DEPTH);
assign empty = (count == 0);




endmodule
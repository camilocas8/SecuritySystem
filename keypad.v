module Keypad (
    input wire [3:0] row,
    input wire [3:0] col,
    output reg [3:0] key_output,
    output reg key_valid
);

reg [3:0] key_last;

always @(posedge row or posedge col)
begin
    // Determinar la tecla presionada
    key_output = 4'b1111;
    key_valid = 1'b0;

    case ({row, col})
        8'b0111_0111:
            key_output = 4'b0000; // Tecla 1
        8'b1011_0111:
            key_output = 4'b0001; // Tecla 2
        8'b1101_0111:
            key_output = 4'b0010; // Tecla 3
        8'b1110_0111:
            key_output = 4'b0011; // Tecla A
        8'b0111_1011:
            key_output = 4'b0100; // Tecla 4
        8'b1011_1011:
            key_output = 4'b0101; // Tecla 5
        8'b1101_1011:
            key_output = 4'b0110; // Tecla 6
        8'b1110_1011:
            key_output = 4'b0111; // Tecla B
        8'b0111_1101:
            key_output = 4'b1000; // Tecla 7
        8'b1011_1101:
            key_output = 4'b1001; // Tecla 8
        8'b1101_1101:
            key_output = 4'b1010; // Tecla 9
        8'b1110_1101:
            key_output = 4'b1011; // Tecla C
        8'b0111_1110:
            key_output = 4'b1100; // Tecla *
        8'b1011_1110:
            key_output = 4'b1101; // Tecla 0
        8'b1101_1110:
            key_output = 4'b1110; // Tecla #
        8'b1110_1110:
            key_output = 4'b1111; // Tecla D
    endcase

    // Actualizar el valor de la tecla solo en flanco de bajada
    if ({row, col} != key_last)
    begin
        key_last = {row, col};
        key_valid = 1'b1;
    end
end

endmodule
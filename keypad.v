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

    case (row)
      4'b1110:
        key_output = 4'b0000;
      4'b1101:
        key_output = 4'b0001;
      4'b1011:
        key_output = 4'b0010;
      4'b0111:
        key_output = 4'b0011;
    endcase

    // Actualizar el valor de la tecla solo en flanco de bajada
    if (row != key_last)
    begin
      key_last = row;
      key_valid = 1'b1;
    end
  end

endmodule

module Sistema_Seguridad (
    input wire clk,
    input wire reset,
    input wire pir_sensor,
    input wire [3:0] keypad_row,
    input wire [3:0] keypad_col,
    output reg alerta_pin,
    output reg bocina_pin
);

reg [3:0] clave_correcta_A = 4'b0011; // Representa "A"
reg [3:0] clave_correcta_B = 4'b0111; // Representa "B"
reg [3:0] clave_correcta_8 = 4'b1001; // Representa "8"
reg [3:0] clave_correcta_9 = 4'b1010; // Representa "9"
reg [3:0] clave_ingresada;
reg [15:0] contador_temporizador;
reg detectado_movimiento;
reg [15:0] contador_bocina;

// Instancia del módulo del teclado matricial
Keypad keypad (
    .row(keypad_row),
    .col(keypad_col),
    .key_output(clave_ingresada),
    .key_valid()
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        clave_ingresada <= 4'b0000;
        contador_temporizador <= 16'b0;
        detectado_movimiento <= 1'b0;
        alerta_pin <= 1'b0;
        bocina_pin <= 1'b0;
        contador_bocina <= 16'b0;
    end else begin
        // Lógica de detección de movimiento
        if (pir_sensor == 1'b0) begin
            detectado_movimiento <= 1'b1;
            contador_temporizador <= 16'b0;
        end

        // Lógica de temporizador después de la detección de movimiento
        if (detectado_movimiento == 1'b1) begin
            contador_temporizador <= contador_temporizador + 1;
            if (contador_temporizador == 16'd50000) begin
                detectado_movimiento <= 1'b0;
                alerta_pin <= 1'b1;
            end
        end

        // Lógica de ingreso de clave con el teclado matricial
        if (detectado_movimiento == 1'b1) begin
            // Lógica de comparación de clave
            if (keypad.key_valid &&
                (clave_ingresada == clave_correcta_A || clave_ingresada == clave_correcta_B ||
                 clave_ingresada == clave_correcta_8 || clave_ingresada == clave_correcta_9)) begin
                // Lógica adicional si la clave es correcta
                contador_temporizador <= 16'b0; // Reiniciar contador si la clave es correcta
            end else begin
                // Lógica adicional si la clave es incorrecta
                bocina_pin <= 1'b1; // Activar bocina si la clave es incorrecta
                contador_bocina <= contador_bocina + 1;
                // Generar una señal de sonido simulada (frecuencia aproximada)
                if (contador_bocina == 16'd25000) begin
                    bocina_pin <= 1'b0;
                    contador_bocina <= 16'b0;
                end
            end
        end
    end
end

endmodule

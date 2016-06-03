/* Clock and reset unit (CRU) */

module cru
  (input  wire reset_in, // power-on reset
   output wire rst240m,  // 240 MHz clock domain
   output wire rst12m,   //  12 MHz clock domain
   output wire rst960k,  // 960 kHz clock domain
   output wire rst32k,   //  32 kHz clock domain

   input  wire clk240m,  // 240 MHz clock
   output wire clk12m,   //  12 MHz clock
   output wire clk2m,    //   2 MHz clock
   output wire clk960k,  // 960 kHz clock
   output wire clk32k);  //  32 kHz clock

   wire rst240m_n;
   wire rst12m_n;
   wire rst960k_n;
   wire rst32k_n;

   synchronizer inst_rst240m
     (.reset(reset_in),
      .clk  (clk240m),
      .in   (1'b1),
      .out  (rst240m_n));

   synchronizer inst_rst12m
     (.reset(reset_in),
      .clk  (clk12m),
      .in   (1'b1),
      .out  (rst12m_n));

   synchronizer inst_rst960k
     (.reset(reset_in),
      .clk  (clk960k),
      .in   (1'b1),
      .out  (rst960k_n));
 
   synchronizer inst_rst32k
     (.reset(reset_in),
      .clk  (clk32k),
      .in   (1'b1),
      .out  (rst32k_n));
 
   assign rst240m = ~rst240m_n;
   assign rst12m  = ~rst12m_n;
   assign rst960k = ~rst960k_n;
   assign rst32k  = ~rst32k_n;
 
   /* base-band clock */
   clock_divider
     #(.M(250))
   inst_clk960k
     (.reset(rst240m),
      .clk  (clk240m),
      .clk_o(clk960k));

   /* MCLK for DAC */
   clock_divider
     #(.M(20))
   inst_clk12m
     (.reset(rst240m),
      .clk  (clk240m),
      .clk_o(clk12m));

   /* BCLK for DAC */
   clock_divider
     #(.M(6))
   inst_clk2m
     (.reset(rst12m),
      .clk  (clk12m),
      .clk_o(clk2m));

   /* audio clock */
   clock_divider
     #(.M(30))
   inst_clk32k
     (.reset(rst960k),
      .clk  (clk960k),
      .clk_o(clk32k));
endmodule
//`define ENABLE_HPS
//`define MISTER_SDRAM_64M

module DE10_NANO_MISTER_SDRAM(

      ///////// ADC /////////
      output             ADC_CONVST       ,
      output             ADC_SCK          ,
      output             ADC_SDI          ,
      input              ADC_SDO          ,

      ///////// ARDUINO /////////
      inout       [15:0] ARDUINO_IO       ,
      inout              ARDUINO_RESET_N  ,

      ///////// FPGA /////////
      input              FPGA_CLK1_50     ,
      input              FPGA_CLK2_50     ,
      input              FPGA_CLK3_50     ,

      ///////// GPIO /////////
    //  inout       [35:0] GPIO_1         ,

		//////// MiSTer SDRAM ///
      output             SDRAM_CLK        ,
      output             SDRAM_CKE        ,
      output      [12:0] SDRAM_A          ,
      output       [1:0] SDRAM_BA         ,
      inout       [15:0] SDRAM_DQ         ,
      output             SDRAM_DQML       ,
      output             SDRAM_DQMH       ,
      output             SDRAM_nCS        ,
      output             SDRAM_nCAS       ,
      output             SDRAM_nRAS       ,
      output             SDRAM_nWE        ,

      ///////// HDMI /////////
      inout              HDMI_I2C_SCL     ,
      inout              HDMI_I2C_SDA     ,
      inout              HDMI_I2S         ,
      inout              HDMI_LRCLK       ,
      inout              HDMI_MCLK        ,
      inout              HDMI_SCLK        ,
      output             HDMI_TX_CLK      ,
      output      [23:0] HDMI_TX_D        ,
      output             HDMI_TX_DE       ,
      output             HDMI_TX_HS       ,
      input              HDMI_TX_INT      ,
      output             HDMI_TX_VS       ,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      inout              HPS_CONV_USB_N   ,
      output      [14:0] HPS_DDR3_ADDR    ,
      output      [2:0]  HPS_DDR3_BA      ,
      output             HPS_DDR3_CAS_N   ,
      output             HPS_DDR3_CKE     ,
      output             HPS_DDR3_CK_N    ,
      output             HPS_DDR3_CK_P    ,
      output             HPS_DDR3_CS_N    ,
      output      [3:0]  HPS_DDR3_DM      ,
      inout       [31:0] HPS_DDR3_DQ      ,
      inout       [3:0]  HPS_DDR3_DQS_N   ,
      inout       [3:0]  HPS_DDR3_DQS_P   ,
      output             HPS_DDR3_ODT     ,
      output             HPS_DDR3_RAS_N   ,
      output             HPS_DDR3_RESET_N ,
      input              HPS_DDR3_RZQ     ,
      output             HPS_DDR3_WE_N    ,
      output             HPS_ENET_GTX_CLK ,
      inout              HPS_ENET_INT_N   ,
      output             HPS_ENET_MDC     ,
      inout              HPS_ENET_MDIO    ,
      input              HPS_ENET_RX_CLK  ,
      input       [3:0]  HPS_ENET_RX_DATA ,
      input              HPS_ENET_RX_DV   ,
      output      [3:0]  HPS_ENET_TX_DATA ,
      output             HPS_ENET_TX_EN   ,
      inout              HPS_GSENSOR_INT  ,
      inout              HPS_I2C0_SCLK    ,
      inout              HPS_I2C0_SDAT    ,
      inout              HPS_I2C1_SCLK    ,
      inout              HPS_I2C1_SDAT    ,
      inout              HPS_KEY          ,
      inout              HPS_LED          ,
      inout              HPS_LTC_GPIO     ,
      output             HPS_SD_CLK       ,
      inout              HPS_SD_CMD       ,
      inout       [3:0]  HPS_SD_DATA      ,
      output             HPS_SPIM_CLK     ,
      input              HPS_SPIM_MISO    ,
      output             HPS_SPIM_MOSI    ,
      inout              HPS_SPIM_SS      ,
      input              HPS_UART_RX      ,
      output             HPS_UART_TX      ,
      input              HPS_USB_CLKOUT   ,
      inout       [7:0]  HPS_USB_DATA     ,
      input              HPS_USB_DIR      ,
      input              HPS_USB_NXT      ,
      output             HPS_USB_STP      ,
`endif /*ENABLE_HPS*/

      ///////// KEY /////////
      input       [1:0]  KEY              ,

      ///////// LED /////////
      output      [7:0]  LED              ,

      ///////// SW /////////
      input       [3:0]  SW
);


//=======================================================
//  REG/WIRE declarations
//=======================================================





//=======================================================
//  Structural coding
//=======================================================

    wire nios_clk;
    
    nios_pll nios_pll_inst(
    		.refclk  ( FPGA_CLK1_50 ),   //  refclk.clk
    		.rst     ( 1'b0         ),      //   reset.reset
    		.outclk_0( nios_clk     ), // outclk0.clk
    		.locked  (              )  //  locked.export
    	);


	
    altddio_out
    #(
    	.extend_oe_disable      ( "OFF"          ),
    	.intended_device_family ( "Cyclone V"    ),
    	.invert_output          ( "OFF"          ),
    	.lpm_hint               ( "UNUSED"       ),
    	.lpm_type               ( "altddio_out"  ),
    	.oe_reg                 ( "UNREGISTERED" ),
    	.power_up_high          ( "OFF"          ),
    	.width                  ( 1              )
    ) sdramclk_ddr (
    	.datain_h   ( 1'b0      ),
    	.datain_l   ( 1'b1      ),
    	.outclock   ( nios_clk  ),
    	.dataout    ( SDRAM_CLK ),
    	.aclr       ( 1'b0      ),
    	.aset       ( 1'b0      ),
    	.oe         ( 1'b1      ),
    	.outclocken ( 1'b1      ),
    	.sclr       ( 1'b0      ),
    	.sset       ( 1'b0      )
    );

	nios_mcu u0 (
		.clk_clk                                 (nios_clk  ),  //                         clk.clk
		.reset_reset_n                           (KEY[0]    ),  //                       reset.reset_n
`ifndef MISTER_SDRAM_64M
		.mister_sdram32m_conduit_end_sdram_addr  (SDRAM_A   ),  // mister_sdram32m_conduit_end.sdram_addr
		.mister_sdram32m_conduit_end_sdram_ba    (SDRAM_BA  ),  //                            .sdram_ba
		.mister_sdram32m_conduit_end_sdram_cas_n (SDRAM_nCAS),  //                            .sdram_cas_n
		.mister_sdram32m_conduit_end_sdram_cke   (          ),  //                            .sdram_cke
		.mister_sdram32m_conduit_end_sdram_cs_n  (SDRAM_nCS ),  //                            .sdram_cs_n
		.mister_sdram32m_conduit_end_sdram_dq    (SDRAM_DQ  ),  //                            .sdram_dq
		.mister_sdram32m_conduit_end_sdram_dqm   (          ),  //                            .sdram_dqm
		.mister_sdram32m_conduit_end_sdram_ras_n (SDRAM_nRAS),  //                            .sdram_ras_n
		.mister_sdram32m_conduit_end_sdram_we_n  (SDRAM_nWE ),  //                            .sdram_we_n
`else
		.mister_sdram64m_conduit_end_sdram_addr  (SDRAM_A   ),  // mister_sdram64m_conduit_end.sdram_addr
		.mister_sdram64m_conduit_end_sdram_ba    (SDRAM_BA  ),  //                            .sdram_ba
		.mister_sdram64m_conduit_end_sdram_cas_n (SDRAM_nCAS),  //                            .sdram_cas_n
		.mister_sdram64m_conduit_end_sdram_cke   (          ),  //                            .sdram_cke
		.mister_sdram64m_conduit_end_sdram_cs_n  (SDRAM_nCS ),  //                            .sdram_cs_n
		.mister_sdram64m_conduit_end_sdram_dq    (SDRAM_DQ  ),  //                            .sdram_dq
		.mister_sdram64m_conduit_end_sdram_dqm   (          ),  //                            .sdram_dqm
		.mister_sdram64m_conduit_end_sdram_ras_n (SDRAM_nRAS),  //                            .sdram_ras_n
		.mister_sdram64m_conduit_end_sdram_we_n  (SDRAM_nWE ),  //                            .sdram_we_n
`endif
        .pio_led_external_connection_export      (LED       )   // pio_led_external_connection.export
	);

endmodule

BASE = ../../../
FCMAKE = C:/Program Files/FITkit/bin/fcmake.exe
FKFLASH = C:/Program Files/FITkit/bin/fkflash.exe
FKTERM = C:/Program Files/FITkit/bin/fkterm.exe
FKTEST = C:/Program Files/FITkit/bin/fktest.exe
PROJECT = project.xml
OUTPUTPREFIX = ivh_proj
FPGACHIP = xc3s50
FPGASPEEDGRADE = 4
FPGAPACKAGE = pq208

all: dependencycheck build/ivh_proj_f1xx.hex build/ivh_proj_f2xx.hex build/ivh_proj.bin

#MCU part
#=====================================================================
HEXFILE_F1XX = build/ivh_proj_f1xx.hex
HEXFILE_F2XX = build/ivh_proj_f2xx.hex

build/mcu/main_f1xx.o: mcu/main.c
	$(comp_tpl_f1xx)

build/mcu/main_f2xx.o: mcu/main.c
	$(comp_tpl_f2xx)

OBJFILES_F1XX = build/mcu/main_f1xx.o
OBJFILES_F2XX = build/mcu/main_f2xx.o

#FPGA part
#=====================================================================
BINFILE = build/ivh_proj.bin
HDLFILES  = ../../../fpga/units/clkgen/clkgen_config.vhd
HDLFILES += ../../../fpga/units/clkgen/clkgen.vhd
HDLFILES += ../../../fpga/units/math/math_pack.vhd
HDLFILES += ../../../fpga/ctrls/spi/spi_adc_entity.vhd
HDLFILES += ../../../fpga/ctrls/spi/spi_adc.vhd
HDLFILES += ../../../fpga/ctrls/spi/spi_adc_autoincr.vhd
HDLFILES += ../../../fpga/ctrls/spi/spi_reg.vhd
HDLFILES += ../../../fpga/ctrls/spi/spi_ctrl.vhd
HDLFILES += ../../../fpga/chips/fpga_xc3s50.vhd
HDLFILES += ../../../fpga/chips/architecture_gp/arch_gp_ifc.vhd
HDLFILES += ../../../fpga/chips/architecture_gp/tlv_gp_ifc.vhd
HDLFILES += fpga/lumin_board.vhd
HDLFILES += fpga/display.vhd
HDLFILES += fpga/cell.vhd
HDLFILES += fpga/counter.vhd
HDLFILES += fpga/matrix_pack.vhd
HDLFILES += fpga/lumin_board_fsm.vhd

build/ivh_proj.bin: build/fpga/ivh_proj.par.ncd build/fpga/ivh_proj.pcf

PKGS_LIST = ../../../fpga/units/clkgen/package.xml
PKGS_LIST += ../../../fpga/units/math/package.xml
PKGS_LIST += ../../../fpga/ctrls/spi/package.xml
PKGS_LIST += ../../../fpga/chips/architecture_gp/package.xml

include $(BASE)/base/Makefile.inc

TOP = tdes_top
MDIR = obj_dir

all: verilator compile run

verilator:
	@verilator --cc --exe \
		-Irtl \
		$(TOP).sv \
		tb.cpp \
		-Wno-LITENDIAN \
		--trace --trace-max-array 256

compile:
	@make -j -C $(MDIR) -f V$(TOP).mk V$(TOP)

run:
	@$(MDIR)/V$(TOP)

clean:
	@rm -rf $(MDIR)
	@rm -f $(TOP).vcd

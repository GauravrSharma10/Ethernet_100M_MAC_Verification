
INCL = +incdir+../ENV/ +incdir+../ENV/agents/ +incdir+../ENV/agents/miim_agent/ +incdir+../ENV/agents/rx_phy_agent/ +incdir+../ENV/agents/tx_phy_agent/ +incdir+../ENV/agents/wishbone_master_agent/ +incdir+../ENV/agents/wishbone_slave_agent/ +incdir+../RTL/ +incdir+../TEST/ +incdir+../TOP/ +incdir+../ENV/RAL

BASE_PKG = ../TEST/ethernet_mac_test_pkg.sv
RAL_PKG = ../TEST/ethernet_reg_pkg.sv

TEST_NAME ?= ethernet_mac_base_test
RTL = ../RTL/ethmac.v ../TOP/top.sv
SEED ?= 0
UVM_VERBO ?= UVM_LOW 
COVERAGE_ENABLE ?= 0

#Default TIMEOUT
TIMEOUT    = 750000

# Default Iteration 
ITERATIONS = 1

#UVM Command line switches
UVM_CLI_SWITCH = +ntb_random_seed=$(SEED) +UVM_TESTNAME=$(TEST_NAME) +UVM_TIMEOUT=$(TIMEOUT) +UVM_TR_RECORD +UVM_LOG_RECORD +UVM_VERBOSITY=$(UVM_VERBO) 

#Synopsis VCS OPTIONS 
VCS_RUN_OPTS = -l $(TEST_NAME)/$(TEST_NAME)_$(SEED).log
VCS_COMP_OPTS = -lca -sverilog -l compile.log -debug_access+all -ntb_opts uvm-1.2 $(INCL) $(BASE_PKG)
VCS_COVERAGE = -cm line+cond+fsm+tgl+branch

#Mentor QUESTA OPTIONS
QUESTA_RUN_OPTS = -voptargs=+acc -work work top -c -l $(TEST_NAME)/$(TEST_NAME)_$(SEED).log -do "do wave.do; run -all"
QUESTA_COMP_OPTS = +acc $(INCL) $(BASE_PKG)
QUESTA_COVERAGE = -coveropt 3 +cover

#TOOL
TOOL ?=VCS

#Checks which TOOL is selected from CLI
ifeq ($(TOOL) ,QUESTA)

  RUN_CMD = vsim $(QUESTA_RUN_OPTS)
  COMPILE_CMD = vlog $(QUESTA_COMP_OPTS)
  
  #Checks for COVERAGE_ENABLE 
ifeq ($(COVERAGE_ENABLE) ,1) 
  RUN_CMD = vsim -coverage $(QUESTA_RUN_OPTS)  
  COMPILE_CMD = vlog $(QUESTA_COVERAGE) $(QUESTA_COMP_OPTS)
endif

else 
  RUN_CMD = ./simv $(VCS_RUN_OPTS) 
  COMPILE_CMD = vcs $(VCS_COMP_OPTS)
  
ifeq ($(COVERAGE_ENABLE) ,1)
  RUN_CMD = ./simv $(VCS_COVERAGE) $(VCS_RUN_OPTS) 
  COMPILE_CMD = vcs $(VCS_COMP_OPTS) $(VCS_COVERAGE)
endif 
endif 

#Checking the VCS version
VCS_VERSION = $(shell vcs -id > vcs_version ; grep "Compiler version" vcs_version | awk -F " " '{print $$5}')

#This variable contains all the UVM-1.0 supported VCS tool versions.
UVM10_SUPP_VCS_VERSNS = E-2011.03 

# VCS and UVM checking
ifdef VCS_HOME
 ifneq ($(VCS_VERSION),$(filter $(VCS_VERSION),$(UVM10_SUPP_VCS_VERSNS)))
  VCS_VERS_WARNING = 1
 endif  
 ifndef UVM_HOME
  UVM = -ntb_opts uvm 
 else
  UVM = -debug_pp +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv ${UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS 
 endif
else
 ERR_STATUS = 1
endif

all default: check clean comp run

check:
ifdef VCS_VERS_WARNING
	@echo ""
	@echo "VCS version is ${VCS_VERSION}"
	@echo "WARNING: VCS version should be atleast E-2011.03 or greater"
	@echo ""
endif
ifdef ERR_STATUS
	@echo ""
	@echo "ERROR : VCS_HOME is not set"
	@echo "Please set VCS_HOME to run this Makefile"
	@echo ""
endif

#Compilation Command 
comp: check
		 $(COMPILE_CMD)  \
       $(RTL)

#Run Command 
run: comp
	@echo "Compiling.................."
	mkdir -p $(TEST_NAME) && $(RUN_CMD) \
				$(UVM_CLI_SWITCH)
	@echo "---------------------------------------------------------------------------------------------------------------"
	@echo "LOG FILE PATH :- $(TEST_NAME)/$(TEST_NAME)_$(SEED).log"
	@echo "---------------------------------------------------------------------------------------------------------------"

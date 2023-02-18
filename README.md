# Introduction to Efabless Caravel
The Efabless Caravel chip is a ready-to-use test harness for creating designs with the Google/Skywater 130nm Open PDK. The Caravel harness comprises of base functions supporting IO, power and configuration as well as drop-in modules for a management SoC core. The current SoC architecture is given below.

<img src="https://user-images.githubusercontent.com/11850122/214560743-cbad9de0-db4c-4ab1-9a0a-cc52d51191dd.jpg" width=120%>

## Caravel Lab Purpose
* Integrate a custom RTL design to Caravel SoC
* Go through overall Caravel user flow and ready to [MPW submission](https://efabless.com/open_shuttle_program)

## Caravel Lab Prerequisites
* Ubuntu 20.04+
* Installed Docker packages
* Icarus Verilog [version 12.0](https://bleyer.org/icarus/) bundled with GTKWave
* Caravel user project [sources with tag mpw-8c](https://github.com/efabless/caravel_user_project/tree/mpw-8c)
* Download and unzip [caravel lab data](https://github.com/bol-edu/caravel-lab/archive/refs/heads/main.zip)

## 1. Custom RTL Design
A GCD RTL design example was verified under Icarus Verilog version 12.0. The following timing diagram shows GCD(10312050, 29460792)=138.

<img src="https://user-images.githubusercontent.com/11850122/214568278-017816f2-8450-483e-878f-8cbccd79d248.png" width=100%>

    $ iverilog seq_gcd.v testbench.v  && vvp a.out
    VCD info: dumpfile dump.vcd opened for output.
                 Result is correct:  GCD(  10312050,  29460792) -->: Expected =        138; Actual Result =        138
                 Result is correct:  GCD(1993627629,1177417612) -->: Expected =          7; Actual Result =          7
                 Result is correct:  GCD(2097015289,3812041926) -->: Expected =          1; Actual Result =          1
                 Result is correct:  GCD(1924134885,3151131255) -->: Expected =        135; Actual Result =        135
                 Result is correct:  GCD( 992211318, 512609597) -->: Expected =          1; Actual Result =          1
    testbench.v:100: $stop called at 609 (1s)
    ** VVP Stop(0) **
    ** Flushing output streams.
    ** Current simulation time is 609 ticks.
    > finish
    ** Continue **
    
The GCD design and testbench sources located in [custom_design/gcd/source](https://github.com/bol-edu/caravel-lab/tree/main/custom_design/gcd/source). GCD's Openlane configuration file [config.json](https://github.com/bol-edu/caravel-lab/blob/main/custom_design/gcd/openlane_config/config.json) was tested under individual [Openlane flow](https://github.com/bol-edu/openlane-lab) with PDK sky130_fd_sc_hd and clock period 80 ns.

## 2. Caravel User Flow
The below instructions show Caravel user flow setup and execution step-by-step with custom GCD RTL design example. 
* Execute 'export PATH=$PATH:~/.local/bin' before first time 'make setup'. There is a 'volare: command not found' issue refered from offical [troubleshooting](https://github.com/efabless/volare#troubleshooting).
* The three variables OPENLANE_ROOT, PDK_ROOT and PDK always are needed to export before Caravel user flow execution. In Caravel lab, you need to change directory to ~/caravel_user_project firstly and then export the three variables.
* Download [custom_design](https://github.com/bol-edu/caravel-lab/tree/main/custom_design/gcd) to your experimental environment.
* The GCD design was wrapped with logic analyzer input/output in [user_proj_example.v](https://github.com/bol-edu/caravel-lab/blob/main/custom_design/gcd/user_proj_example/user_proj_example.v), which can be triggered by [la_test1.c](https://github.com/bol-edu/caravel-lab/blob/main/custom_design/gcd/verify-la_test1-rtl/la_test1.c) and monitored by [la_test1_tb.v](https://github.com/bol-edu/caravel-lab/blob/main/custom_design/gcd/verify-la_test1-rtl/la_test1_tb.v).
* After RTL simulation, you can find a VCD waveform file RTL-la_test1.vcd updated in ~/caravel_user_project/verilog/dv/la_test1/ and debug it with GTKWave tool.
* Caravel SoC [memory map definition](https://github.com/efabless/caravel/blob/main/verilog/dv/caravel/defs.h) and [testbench examples](https://github.com/efabless/caravel_user_project/blob/main/verilog/dv/README.md).
* We change default "RUN_CVC" : 1 to 0 in user project example's [config.json](https://github.com/bol-edu/caravel-lab/blob/main/custom_design/gcd/user_proj_example/config.json) to skip not working Openlane CVC step in Caravel user flow.
* The gate level static timing verifier is based on [OpenROAD OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA).
* In MPW precheck, you have to update two files to pass check (1) update README.md (>25% difference) to replace original one (2) change 13'hXXXX to 13'h0000 in user_defines.v.

All Caravel user flow step outputs were written to log files.
    
    Setup caravel_user_project    
    $ git clone -b mpw-8c https://github.com/efabless/caravel_user_project
    $ cd caravel_user_project
    $ mkdir dependencies
    $ export OPENLANE_ROOT=$(pwd)/dependencies/openlane_src
    $ export PDK_ROOT=$(pwd)/dependencies/pdks
    $ export PDK=sky130A    
    $ make setup
    
    Run RTL simulation
    $ cp ~/caravel-lab-main/custom_design/gcd/user_proj_example/user_proj_example.v ~/caravel_user_project/verilog/rtl/user_proj_example.v
    $ cp ~/caravel-lab-main/custom_design/gcd/verify-la_test1-rtl/la_test1.c ~/caravel_user_project/verilog/dv/la_test1/la_test1.c
    $ cp ~/caravel-lab-main/custom_design/gcd/verify-la_test1-rtl/la_test1_tb.v ~/caravel_user_project/verilog/dv/la_test1/la_test1_tb.v
    $ make simenv
    $ SIM=RTL
    $ make verify-la_test1-rtl
    
    Run Openlane to generate RTL netlist
    $ cp ~/caravel-lab-main/custom_design/gcd/user_proj_example/config.json ~/caravel_user_project/openlane/user_proj_example/config.json
    $ cd openlane
    $ make user_proj_example
    $ make user_project_wrapper
    
    Run gate level simulation (it will take 2~3 hours@i9/64GB)
    $ SIM=GL    
    $ make verify-la_test1-gl
    
    Run gate level static timing verifier
    $ make setup-timing-scripts
    $ make extract-parasitics
    $ make create-spef-mapping
    $ make caravel-sta
    
    Run MPW precheck
    $ cp ~/caravel-lab-main/custom_design/gcd/mpw_precheck/README.md ~/caravel_user_project/README.md
    $ cp ~/caravel-lab-main/custom_design/gcd/mpw_precheck/user_defines.v  ~/caravel_user_project/verilog/rtl/user_defines.v
    $ make precheck
    $ make run-precheck

Caravel user flow step logs
* [setup-caravel_user_project.log](https://github.com/bol-edu/caravel-lab/blob/main/logs/setup-caravel_user_project.log)
* [run-rtl-simulation.log](https://github.com/bol-edu/caravel-lab/blob/main/logs/run-rtl-simulation.log)
* [run-openlane-to-generate-rtl-netlist.log](https://github.com/bol-edu/caravel-lab/blob/main/logs/run-openlane-to-generate-rtl-netlist.log)
* [run-gate-level-static-timing-verifier.log](https://github.com/bol-edu/caravel-lab/blob/main/logs/run-gate-level-static-timing-verifier.log)
* [run-mpw-precheck.log](https://github.com/bol-edu/caravel-lab/blob/main/logs/run-mpw-precheck.log)

## List all Verilog Sources in Caravel (System Side) 
The two directories caravel_user_project/caravel and caravel_user_project/mgmt_core_wrapper were created after 'Setup caravel_user_project'.
* [caravel_user_project.caravel.log](https://github.com/bol-edu/caravel-lab/blob/main/logs/caravel_user_project.caravel.log)
* [caravel_user_project.mgmt_core_wrapper.log](https://github.com/bol-edu/caravel-lab/blob/main/logs/caravel_user_project.mgmt_core_wrapper.log)

## Checklist for Open-MPW Submission & MPW Public Project
Finally, you need to comply with [offical checklist](https://caravel-user-project.readthedocs.io/en/latest/#checklist-for-open-mpw-submission) to upload your [MPW public project](https://platform.efabless.com/shuttles/MPW-8#projects_list).

## Offical Documents
* [Quickstart of How to Use Caravel User Project](https://github.com/efabless/caravel_user_project/blob/main/docs/source/index.rst#section-quickstart)
* [Caravel User Project](https://caravel-user-project.readthedocs.io/en/latest/#caravel-user-project)
* [Efabless Caravel “harness” SoC](https://caravel-harness.readthedocs.io/en/latest/#efabless-caravel-harness-soc)
* [Efabless Caravel Specification](https://github.com/efabless/caravel/tree/main/docs/pdf)

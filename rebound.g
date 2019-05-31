// This script runs a protocol which
// gives rise to a rebound spike after
// an initial inhibition has been removed




float PI = 3.141592654

int	i
float dt = 1e-5
float sim_time = 1
setclock 0 {dt}
setclock 1 0.0001
setmethod 11
//setmethod 0

float NMDA=0.0
float AMPA = 0;
float Kainate=0.0

float Vrest	= -0.07

include library
include finish

make_cell cell.p neuron

str comp
foreach comp ({el /neuron/##[OBJECT=compartment]})
  setfield {comp} Em -0.058
  setfield {comp} initVm -0.058
end


include xout_rebound

// if hsolve is used
call /neuron SETUP

reset

float	I
float Imax = {3.14159};
step 0.010 -t
setfield /neuron/soma inject -0.3e-9
step 0.200 -t 
setfield /neuron/soma inject 0
step 0.6 -t















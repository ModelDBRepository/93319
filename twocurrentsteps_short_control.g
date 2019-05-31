float PI = 3.141592654

int	i
float dt = 1e-5
float sim_time = 0.1
setclock 0 {dt}
setclock 1 0.0001
setmethod 11
//setmethod 0

float NMDA=0.0
float AMPA=0.0

float Vrest	= -0.07

include library_ein
include finish
include output

make_cell dissociated_cell.p neuron

setfield /neuron/soma/KCa_NMDA	Z	0.0
setfield /neuron/soma/KCa_HVA	Z	0.0

// Apply 'cadmium', blocking Ca currents

setfield /neuron/soma/Ca_HVA Gbar {0.0*{getfield /neuron/soma/Ca_HVA Gbar}}
// setfield /neuron/primdend1/Ca_HVA Gbar 0
// setfield /neuron/primdend2/Ca_HVA Gbar 0
setfield /neuron/soma/Ca_L Gbar {0.0*{getfield /neuron/soma/Ca_L Gbar}}
setfield /neuron/soma/Ca_LVA Gbar {0.0*{getfield /neuron/soma/Ca_LVA Gbar}}
// setfield /neuron/primdend1/Ca_L Gbar 0
// setfield /neuron/primdend2/Ca_L Gbar 0


include xout_diss

// if hsolve is used
call /neuron SETUP

reset

float	I
float Imax = {3.14159};
 
 step 0.020 -t

 float inj = 0.9e-9;

 setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0.0
 step 2e-3 -t   
 setfield /neuron/soma inject {inj}
 step 20e-3 -t
 setfield /neuron/soma inject 0
 step 50e-3 -t















































// This script does 4 runs with different injected
// currents; 1-4 time rheobase (0.35 nA) 
// The resulting steady-state frequencies are
// plotted in Fig. 3b

float PI = 3.141592654

int	i
float dt = 1e-5
float sim_time = 5
setclock 0 {dt}
setclock 1 1e-4
setmethod 11
// setmethod 0

float NMDA=0
float AMPA=0.0

include library
include finish

make_cell cell.p neuron

include xout_fig3b

create spikegen /neuron/soma/spike
setfield /neuron/soma/spike thresh -0.035 abs_refract 0.010 output_amp 1

create spikehistory spike.history
setfield spike.history ident_toggle 0 \ // index specification
                                  filename "spikes.dat" \
                                  initialize 1 leave_open 1 flush 1

addmsg /neuron/soma/spike spike.history SPIKESAVE

reset

// setfield neuron chanmode 0
// if hsolve is used
 call /neuron SETUP
 reset

setfield /neuron/soma inject 0.35e-9
step 1 -t

setfield /neuron/soma inject 0
step 0.25 -t

setfield /neuron/soma inject 0.7e-9
step 1 -t

setfield /neuron/soma inject 0
step 0.25 -t

setfield /neuron/soma inject 1.05e-9
step 1 -t

setfield /neuron/soma inject 0
step 0.25 -t

setfield /neuron/soma inject 1.4e-9
step 1 -t













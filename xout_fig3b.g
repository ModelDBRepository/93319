create neutral /xout

function make_control
	create	xform	/xout/control 		[10,10,250,250]
	create	xlabel	/xout/control/label	-hgeom 30	-bg cyan -label "THIS IS A CONTROL PANEL"
	create	xbutton	/xout/control/RESET	-wgeom 33%	-script reset
	create	xbutton	/xout/control/RUN	-xgeom 0:RESET -ygeom 0:label -wgeom 33% \
			-script step_tmax
	create	xbutton	/xout/control/QUIT	-xgeom 0:RUN -ygeom 0:label -wgeom 34% \
			-script	quit
	create	xdialog	/xout/control/time	-label "Simulation time" \
			-value {sim_time}  -script "set_sim_time <widget>"
	create	xdialog	/xout/control/Inj	-label "Injection (nA)" \
			-value 0.0 -script "set_inject <widget>"
    xshow	/xout/control
end

function make_Vmgraph
    create xform /xout/data [270,10,700,225]
    create xlabel /xout/data/label -hgeom 10% -label "Membrane Potential"
    create xgraph /xout/data/voltage  -hgeom 90%
    setfield ^ XUnits sec YUnits mV
    setfield ^ xmax {sim_time} ymin -0.080 ymax 0.060
    // setfield ^ xmax {sim_time} ymin -0.15 ymax 0.1
	useclock /xout/data 1
    xshow /xout/data
end

function make_currgraph
    create xform /xout/curr [270,270,700,225]
    create xlabel /xout/curr/label -hgeom 10% "Current"
    create xgraph /xout/curr/current -hgeom 90% -wgeom 50%
    setfield ^ XUnits msec YUnits nA
    setfield ^ xmin {10} xmax {15} ymin 0 ymax 1 cdxmin 100
    create xgraph /xout/curr/conc -xgeom 0:current -ygeom 0:label -hgeom 90% -wgeom 50%
    setfield ^ XUnits sec YUnits M
    setfield ^ xmax {sim_time} ymin 0.0 ymax 1.0
 	useclock /cout/curr 1
    xshow /xout/curr
end

function step_tmax
	step {sim_time} -t
end

function set_inject(dialog)
    str dialog
    setfield /neuron/soma inject {{getfield {dialog} value}*1e-9}
end

function set_sim_time(dialog)
    str dialog,plot
    sim_time={{getfield {dialog} value}}
	foreach plot ({el /xout/##[TYPE=xgraph]})
		setfield {plot} xmax {sim_time}
	end
end

// FILE OUTPUT

// Voltages

create asc_file /out-v
setfield /out-v filename out-v.dat flush 1 leave_open 1
useclock /out-v 0.1

// Voltages in a primary dendritic comp

create asc_file /out-v-pd
setfield /out-v-pd filename out-v-pd.dat flush 1 leave_open 1
useclock /out-v-pd 0.1

// Voltages in a tertiary dendritic comp

create asc_file /out-v-td
setfield /out-v-td filename out-v-td.dat flush 1 leave_open 1
useclock /out-v-td 0.1

// Currents

create asc_file /out-c
setfield /out-c filename out-c.dat flush 1 leave_open 1
useclock /out-c 0.1

// Currents in a primary dendritic comp

create asc_file /out-c-pd
setfield /out-c-pd filename out-c-pd.dat flush 1 leave_open 1
useclock /out-c-pd 0.1

// Currents in a tertiary dendritic comp

create asc_file /out-c-td
setfield /out-c-td filename out-c-td.dat flush 1 leave_open 1
useclock /out-c-td 0.1

// Activations

create asc_file /na-act-inact-soma
setfield /na-act-inact-soma filename na-act-inact-soma.dat flush 1 leave_open 1
useclock /na-act-inact-soma 0.1

create asc_file /ka-act-inact-soma
setfield /ka-act-inact-soma filename ka-act-inact-soma.dat flush 1 leave_open 1
useclock /ka-act-inact-soma 0.1

create asc_file /na-act-inact-is
setfield /na-act-inact-is filename na-act-inact-is.dat flush 1 leave_open 1
useclock /na-act-inact-is 0.1

make_control
make_Vmgraph
make_currgraph
// make_Cagraph

// Plot voltages

addmsg /neuron/soma /xout/data/voltage PLOT Vm *neuron1 *red
// addmsg /neuron/is /xout/data/voltage PLOT Vm *Iseg *blue
// addmsg /neuron/soma /out-v SAVE Vm 

// Plot Na and Ca pool conc.

// addmsg /neuron/soma/fshNa/Na_slow_pool /xout/curr/conc PLOT Ca *slowNapool(soma) *red
addmsg /neuron/soma/Ca_N/Ca_N_pool /xout/curr/conc PLOT Ca *CaNpool(soma) *blue 

// Plot currents

// Spiking and spiking-coupled

addmsg /neuron/soma/fshNa /xout/curr/current PLOT Ik *Na *red 
addmsg /neuron/soma/Kt /xout/curr/current PLOT Ik *Kt *blue
addmsg /neuron/soma/Ks /xout/curr/current PLOT Ik *Ks *black
addmsg /neuron/soma/KNa_fast /xout/curr/current PLOT Ik *KNa_fast *yellow

// addmsg /neuron/is/fshNa-is /xout/curr/current PLOT Ik *Na *red 
// addmsg /neuron/is/Kt /xout/curr/current PLOT Ik *Ka *blue

// AHP related

addmsg /neuron/soma/Ca_N /xout/curr/current PLOT Ik *Ca_N *brown  
addmsg /neuron/soma/Ca_L /xout/curr/current PLOT Ik *Ca_L *green  
addmsg /neuron/soma/KCa_N /xout/curr/current PLOT Ik *KCa_N *orange 
addmsg /neuron/soma/Ca_LVA /xout/curr/current PLOT Ik *Ca_LVA *purple  
addmsg /neuron/soma/KNa_slow /xout/curr/current PLOT Ik *KNa_slow *red 

// NMDA related

// addmsg /neuron/soma/NMDA /xout/curr/current PLOT Ik *NMDA *white  
// addmsg /neuron/soma/Ca_NMDA /xout/curr/current PLOT Ik *Ca_NMDA *purple  
// addmsg /neuron/soma/KCa_NMDA /xout/curr/current PLOT Ik *KCa_NMDA *cyan  

// Write currents to file

// AP related
// addmsg /neuron/soma/Kt /out-c SAVE Ik 
// addmsg /neuron/soma/fshNa /out-c SAVE Ik
// addmsg /neuron/soma/Ks /out-c SAVE Ik
// addmsg /neuron/soma/KNa_fast /out-c SAVE Ik

// Slow
// addmsg /neuron/soma/Ca_N /out-c SAVE Ik
// addmsg /neuron/soma/KCa_N /out-c SAVE Ik
// addmsg /neuron/soma/Ca_L /out-c SAVE Ik

// addmsg /neuron/soma/NMDA /out-c SAVE Ik
// addmsg /neuron/soma/Ca_NMDA /out-c SAVE Ik
// addmsg /neuron/soma/KCa_NMDA /out-c SAVE Ik

// addmsg /neuron/soma/KNa_slow /out-c SAVE Ik











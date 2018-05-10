
function [ram_air, intake, compressor, combustor, turbine, nozzle, mech_feat] = userdata_turbojet()
	%%%
	
	%%%%%%%%%%%%%%%%%%%% ram air (to design for cruise flight)
	h = 0;    % altitude (metre)
	M = 0;    % flight mach number
	[p_h, ro_h, T_h] = standard_atmosphere(h);
	gama = 1.4;		cp = 1004.5;		%R = cp*(1-1/gama);
	m_dot = 0.98;   % mass flow (kg/s)
	ram_air = struct('P',p_h,  'ro',ro_h,  'T',T_h,  'cp',cp,  'gama',gama,  'M',M,   'm_dot',m_dot);
	
	%%%%%%%%%%%%%%%%%%%% intake
	% M_out: intake flow Mach number (mach number of flight for aircrafts, otherwise 0)
	% efficiency: intake efficiency of output pressure
	intake = struct('M_out',0,   'efficiency',0.99);
	
	%%%%%%%%%%%%%%%%%%%% compressor
	% P_ratio: pressure ratio
	% efficiency: compressor power consumed efficiency
	% mass_loss_portion: taken mass flow portion from the compressor output mass flow
	compressor = struct('P_ratio',3.5,  'efficiency',0.70, 'mass_loss_portion',0);
	
	%%%%%%%%%%%%%%%%%%%% combustor
	% dcp_dT: cp variation with respect to dT in combustion
	% dgama_dT: gama variation with respect to dT in combustion
	% fuel_energy_density: energy density of fuel (j/(kg.K))
	% T_max: maximum outlet temperature (Kelvin)
	% Pressure_drop: Pressure drop due to geometry ang combustion
	combustor = struct('fuel_energy_density',42.8e6,  'combustion_efficiency',0.95,  'T_max',1100,  'Pressure_drop',17.5e3);
	
	%%%%%%%%%%%%%%%%%%%% turbine
	turbine = struct('efficiency',0.75);
	
	%%%%%%%%%%%%%%%%%%%% nozzle
	nozzle = struct('efficiency',0.95);
	
	%%%%%%%%%%%%%%%%%%%% mechanical features
	mech_feat = struct('APU',500,  'mech_efficiency',0.99);	% consider 200-1000 watts for aircrafts;
	
end

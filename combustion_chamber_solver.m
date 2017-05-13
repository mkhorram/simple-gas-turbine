
function [combustor_out_flow, fuel_m_dot] = combustion_chamber_solver(compressor_out_flow, combustor)
	
	%%%%%%%%%% extract inputs
	m_dot = compressor_out_flow.m_dot;
	cp    = compressor_out_flow.cp;
	gama  = compressor_out_flow.gama;
	T1    = compressor_out_flow.T;
	P1    = compressor_out_flow.P;
	ro1   = compressor_out_flow.ro;
	% M1    = compressor_out_flow.M;
	
	
	% dcp_dT                = combustor.dcp_dT;
	% dgama_dT              = combustor.dgama_dT;
	fuel_energy_density   = combustor.fuel_energy_density;
	combustion_efficiency = combustor.combustion_efficiency;
	T_max                 = combustor.T_max;
	Pressure_drop         = combustor.Pressure_drop;
	
	T2 = T_max;
	dT = T2 - T1;
	
	%%%%% final gas
	combustor_out_flow = compressor_out_flow;
	
	P2 = P1;
	ro2 = ro1 * (T1/T2);
	% P1/T1/ro1
	% P2/T2/ro2
	% [P1, ro1, T1; P2, ro2, T2]
	P_r = (P2-Pressure_drop)/P2;
	P2 = P2-Pressure_drop;
	ro2 = ro2 * P_r^(1/gama);
	T2 = T2 * P_r^((gama-1)/gama);
	% P2/T2/ro2
	% [P2, ro2, T2]
	combustor_out_flow.T = T2;
	combustor_out_flow.ro = ro2;
	
	%%%%% specific teat corrections
	% combustor_out_flow.cp = cp + dcp_dT*dT;
	% combustor_out_flow.gama = gama + dgama_dT*dT;
	
	R = cp * (1-1/gama);
	% gama = 1.38;   cp = R / (1-1/gama);
	gama = 1.4;   cp = R / (1-1/gama);
	combustor_out_flow.cp = cp;
	combustor_out_flow.gama = gama;
	
	%%%%% fuel consumption
	fuel_m_dot = (m_dot*cp*dT) / (fuel_energy_density*combustion_efficiency);
	
end


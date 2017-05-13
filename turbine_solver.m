
function [turbine_out_flow] = turbine_solver(combustor_out_flow, power_needs, turbine)
	
	%%%%%%%%%% extract inputs of combustor
	m_dot = combustor_out_flow.m_dot;
	cp    = combustor_out_flow.cp;
	gama  = combustor_out_flow.gama;
	T1    = combustor_out_flow.T;
	P1    = combustor_out_flow.P;
	ro1   = combustor_out_flow.ro;
	M1    = combustor_out_flow.M;
	
	efficiency        = turbine.efficiency;
	
	% the power output of turbine
	turbine_power = power_needs / efficiency;
	dT = turbine_power / (m_dot*cp);
	T2 = T1 - dT;
	T_ratio = T2/T1;
	P2 = P1 * T_ratio^(gama/(gama-1));
	ro2 = ro1 * T_ratio^(1/(gama-1));
	
	% [T1,P1,ro1, P1/T1/ro1;T2,P2,ro2, P2/T2/ro2]
	
	turbine_out_flow = combustor_out_flow;
	turbine_out_flow.P = P2;
	turbine_out_flow.T = T2;
	turbine_out_flow.ro = ro2;
	
end

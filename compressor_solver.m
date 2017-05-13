
function [compressor_out_flow, compressor_power] = compressor_solver(intake_out_flow, compressor)
	
	%%%%%%%%%% extract inputs of compressor
	m_dot = intake_out_flow.m_dot;
	cp    = intake_out_flow.cp;
	gama  = intake_out_flow.gama;
	T1    = intake_out_flow.T;
	P1    = intake_out_flow.P;
	ro1   = intake_out_flow.ro;
	M1    = intake_out_flow.M;
	
	P_ratio           = compressor.P_ratio;
	efficiency        = compressor.efficiency;
	mass_loss_portion = compressor.mass_loss_portion;
	
	% compute the stagnation properties
	T0T1 = 1 + (gama-1)/2 * M1^2;
	T0  = T1  * T0T1;
	P0  = P1  * T0T1^(gama/(gama-1));
	ro0 = ro1 * T0T1^(1/(gama-1));
	
	% pressurizing
	P2 = P0 * P_ratio;
	T2 = T0 * P_ratio ^ ((gama-1)/gama);
	ro2 = ro0 * P_ratio ^ (1/gama);
	
	compressor_out_flow = intake_out_flow;
	compressor_out_flow.P = P2;
	compressor_out_flow.T = T2;
	compressor_out_flow.ro = ro2;
	compressor_out_flow.m_dot = m_dot * (1-mass_loss_portion); % subtract the scaped mass flow
	compressor_out_flow.M = 0;
	
	compressor_power = (cp * (T2 - T0) * m_dot) / efficiency;
	
end

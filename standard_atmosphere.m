function [p_h, ro_h, T_h] = standard_atmosphere(h_vec)
	% This function recieves a one-dimensional matrix as altitude (in metre)
	% Then returns temperature, density & pressure based on en.wikipedia.org/wiki/Barometric_formula
	% Note: model is based on en.wikipedia.org/wiki/US_Standard_Atmosphere
	
	M=0.0289644; Rstar=8.31432; g0=9.80665;
	
	p_h=h_vec*0;  ro_h=p_h;  T_h=p_h;  % creating empty matrices
	for ii=1:max(size(h_vec))
		h=h_vec(ii);
		% determination of constants for the specified altitude (h) in metre
		if h<11000
			rb=1.2250;    pb=101325;   Tb=288.15;  Lb=-0.0065;  hb=0;
		elseif h<20000
			rb=0.36391;   pb=22632.1;  Tb=216.65;  Lb=0;        hb=11000;
		elseif h<32000
			rb=0.08803;   pb=5474.89;  Tb=216.65;  Lb=0.001;    hb=20000;
		elseif h<47000
			rb=0.01322;   pb=868.019;  Tb=228.65;  Lb=0.0028;   hb=32000;
		elseif h<51000
			rb=0.00143;   pb=110.906;  Tb=270.65;  Lb=0;        hb=47000;
		elseif h<71000
			rb=0.00086;   pb=66.9389;  Tb=270.65;  Lb=-0.0028;  hb=51000;
		else     % >>>>> valid up to 86000 metre <<<<<
			rb=0.000064;  pb=3.95642;  Tb=214.65;  Lb=-0.002;   hb=71000;
		end
		
		% determination of equations of changes
		if Lb==0  % The changes of temperature with altitude is zero (constant temperature)
			aa = (-g0 * M * (h-hb)) / (Rstar*Tb);
			p_h(ii)  = pb * exp(aa);  % Pressure at altitude h
			ro_h(ii) = rb * exp(aa);  % Density at altitude h
		else  % The temperature changes with altitude
			aa = Tb / (Tb+Lb*(h-hb));	bb = 1/aa;	cc = g0*M / (Rstar*Lb);
			p_h(ii)  = pb * aa^cc;  % Pressure at altitude h
			ro_h(ii) = rb * bb^(-cc-1);  % Density at altitude h
		end
		% Temperature at altitude h
		T_h(ii) = Tb + Lb * (h-hb);
	end
	% plot(T_h, h_vec)
	% close();
	% plotyy(h_vec, ro_h, h_vec, T_h);
	
	
end

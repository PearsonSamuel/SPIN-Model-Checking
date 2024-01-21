byte m = 4;
bit crit[m];
byte first;
mtype = {token};
byte cs = 0;

chan C[m] = [1] of {mtype}; /* C[i] points to from i to i+1 (mod m) */

proctype P (byte id) {

	mtype t; /* the token */
	
	if 
	:: id == first -> crit[id] = 1; cs++; crit[id] = 0; cs--; C[id] ! token;
	:: else -> skip;
	fi

	
	do
	:: C[(m + id - 1)%m] ? t; crit[id] = 1; cs++; crit[id] = 0; cs--; C[id] ! token;
	od
	
}

init {

	first = 0;
	
	do
	:: first < m - 1 -> first ++;
	:: true -> break;
	od
	
	byte i = 0;

	atomic{
		do
		:: i < m -> run P(i); i++;
		:: else -> break;
		od
	}

}


ltl mutex { [](cs < 2) }

ltl nodeadlock { []<>(cs > 0) }

ltl nostarvation { []<>crit[0] }
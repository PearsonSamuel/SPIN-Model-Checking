byte m = 4;
bit crit[m];
byte first;
mtype = {token};
byte cs = 0;

chan cLeft[m] = [1] of {mtype}; /* i sends through cLeft[i], cRight[i] and receives through cLeft[i+1] and cRight[i-1] (mod m) */
chan cRight[m] = [1] of {mtype};

inline pass_token(id) {

	if
	:: true -> cLeft[id] ! token;
	:: true -> cRight[id] ! token;
	fi

}

proctype P (byte id) {

	mtype t; /* the token */
	
	#define left (m + id - 1)%m
	#define right (id + 1)%m
	
	if 
	:: id == first -> crit[id] = 1; cs++; crit[id] = 0; cs--; pass_token(id);
	:: else -> skip;
	fi

	
	do
	:: cRight[left] ? t; crit[id] = 1; cs++; crit[id] = 0; cs--; pass_token(id)
	
	:: cLeft[right] ? t; crit[id] = 1; cs++; crit[id] = 0; cs--; pass_token(id)
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




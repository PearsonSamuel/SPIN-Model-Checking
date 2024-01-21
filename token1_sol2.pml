byte m = 4;
bit crit[m];
byte last; /* last process to access the critical section. This variable is also used to determine 
the first process to have access in the beginning of the protocol */
byte cs = 0;
mtype = {token};

chan C[m] = [1] of {mtype};

inline pass_token(left, right) {

	if
	:: true -> C[left] ! token;
	:: true -> C[right] ! token;
	fi

}

proctype P (byte id) {

	mtype t; /* the token */
	
	#define left (m + id - 1)%m
	#define right id
	
	if 
	:: id == last -> crit[id] = 1; cs++; crit[id] = 0; cs--; pass_token(left, right);
	:: else -> skip;
	fi

	
	do
	:: last != id -> if
					 :: C[left] ? t; crit[id] = 1; cs++; last = id; 
					 	crit[id] = 0; cs--; pass_token(left, right);
						
					 :: C[right] ? t; crit[id] = 1; cs++; last = id; 
					 	crit[id] = 0; cs--; pass_token(left, right);
					 fi
	od
	
}

init {

	last = 0;
	
	do
	:: last < m - 1 -> last ++;
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
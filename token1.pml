byte m = 4;
bit crit[m];
byte first;
byte cs = 0;

chan C[m] = [1] of {bit};

/* One channel between each pair of adjacent nodes ( C[i] is the channel between node i and (i+1) % m ) */
/* If the token = 0 is in a channel, it was sent by the left node. If token = 1 it was sent by the right node */
/* We assume node i is left of node i+1 (mod m) */

inline pass_token(left, right) {

	if
	:: true -> C[left] ! 1;
	:: true -> C[right] ! 0;
	fi

}

proctype P (byte id) {

	bit t; /* the token */
	
	#define left (m + id - 1)%m
	#define right id
	
	if 
	:: id == first -> crit[id] = 1; cs++; crit[id] = 0; cs--; pass_token(left, right);
	:: else -> skip;
	fi

	
	do
	:: C[left] ? t; 
		if
		:: t == 0 -> crit[id] = 1; cs++; crit[id] = 0; cs--; pass_token(left, right);
		:: else -> C[left] ! 1;
		fi
		
	:: C[right] ? t; 
		if
		 :: t == 1 -> crit[id] = 1; cs++; crit[id] = 0; cs--; pass_token(left, right);
		 :: else -> C[right] ! 0;
		 fi
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

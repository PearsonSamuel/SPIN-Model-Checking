#define N 4

#define B 3

/* variables representing number of missionaries/cannibals 
on each bank and on the boat */
byte LM = N;
byte LC = N;

byte RM = 0;
byte RC = 0;

byte BM = 0;
byte BC = 0;

short trips = 0; /* count number of one-way trips */

bit direction; /* 0 when boat is on the left side, 1 when on the right */

/* To check for termination: */
#define done (RM == N && RC == N)
bit terminated = 0;

/* These formulas must hold when a missionary can be removed from the respective
location without leaving other missionaries outnumbered */
#define Lsafe (LM > LC || LM == 1)
#define Rsafe (RM > RC || RM == 1)

/* We assume that everyone on the boat always disembarks immediately after crossing (they may board again) */

inline cross() {
	if
	:: (direction == 0) && (BM + RM >= BC + RC || BM + RM == 0) -> direction = 1; trips++; RM = RM + BM; RC = RC + BC; BM = 0; BC = 0;
	:: (direction == 1) && (BM + LM >= BC + LC || BM + LM == 0) -> direction = 0; trips++; LM = LM + BM; LC = LC + BC; BM = 0; BC = 0;
	:: else -> skip;
	fi
}


active proctype river_crossing() {

	do
	
	:: done -> break; /* When finished, exit cycle and terminate process */
	
	:: (BM + BC) > 0 -> cross(); /* Allow boat to come and go */
	
	/* Missionary from left bank tries to board the boat */
	:: (direction == 0) && (LM > 0) && Lsafe && (BM + BC < B) && (BM + 1 >= BC) -> LM--; BM++;
	
	/* Cannibal from left bank tries to board the boat */
	:: (direction == 0) && (LC > 0) && (BM + BC < B) && (BM > BC || BM == 0) -> LC--; BC++;
	
	/* Missionary from right bank tries to board the boat */
	:: (direction == 1) && (RM > 0) && Rsafe && (BM + BC < B) && (BM + 1 >= BC) -> RM--; BM++;
	
	/* Cannibal from right bank tries to board the boat */
	:: (direction == 1) && (RC > 0) && (BM + BC < B) && (BM > BC || BM == 0) -> RC--; BC++;
	
	/* If all remaining missionaries on the left fit on the boat and won't be outnumbered on the boat,
	 they may board simultaneously */
	:: (direction == 0) && (LM > 0) && (LM <= (B - (BC + BM)) ) && (LM + BM >= BC) -> BM = BM + LM; LM = 0;
	
	od
	
	terminated = 1;
}

ltl nocannibalism {[]((LM >= LC || LM == 0) && (RM >= RC || RM == 0) && (BM >= BC || BM == 0) )} 

ltl nosinking {[](BM + BC <= B)} 

ltl notermination {[](terminated == 0)}




active proctype T() {

	atomic{
	if
	:: true -> goto s1;
	:: true -> goto s2;
	fi
	}

s1:	do
	:: goto s4;
	:: goto s3;
	od
	
s2:	do
	:: goto s4;
	od
	
s3:	do
	:: goto s4;
	od
	
s4:	do
	:: goto s2;
	:: goto s3;
	:: goto s5;
	od
	
s5:	do
	:: goto s4;
	:: goto s5;
	od

}

#define a (T@s1 || T@s5)
#define b (T@s3 || T@s4 || T@s5)
#define c (T@s2 || T@s3 || T@s5)

/* In properties where the label of a state in some specific time instant matters, we write X F instead of F ...*/
/* ... because one step is needed at the beggining to choose the initial state */

ltl i { <>[]c } /* should give error (and does) */

ltl ii { []<>c } /* shouldn't give error (and doesn't) */

ltl iii { X ( (X !c) -> (X X c) ) } /* shouldn't give error (and doesn't) */

ltl iv { X []a } /* should give error (and does) */

ltl v { X [](a || [](b||c) ) } /* shouldn't give error (and doesn't) */

ltl v2 { <>[](b || c) } /* shouldn't give error (and doesn't) */

ltl vi { X ( []( (X X b) || (b || c) ) ) } /* should give error in s1 (s1 - s4 -s2) and does */

ltl vi2 { <>(b || c) } /* Holds, but since vi doesn't then formula 1 a) vi) isn't satisfied */



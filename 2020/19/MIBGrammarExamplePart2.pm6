grammar MIBGrammarExamplePart2 {
    token r42 { <r9> <r14> | <r10> <r1> }
 
    token r9 { <r14> <r27> | <r1> <r26> }
 
    token r10 { <r23> <r14> | <r28> <r1> }
 
    token r1 { "a" }
 
    token r11 { <r42> <r31> }
 
    token r5 { <r1> <r14> | <r15> <r1> }
 
    token r19 { <r14> <r1> | <r14> <r14> }
 
    token r12 { <r24> <r14> | <r19> <r1> }
 
    token r16 { <r15> <r1> | <r14> <r14> }
 
    token r31 { <r14> <r17> | <r1> <r13> }
 
    token r6 { <r14> <r14> | <r1> <r14> }
 
    token r2 { <r1> <r24> | <r14> <r4> }
 
    token TOP { <r8> <r11> }
 
    token r13 { <r14> <r3> | <r1> <r12> }
 
    token r15 { <r1> | <r14> }
 
    token r17 { <r14> <r2> | <r1> <r7> }
 
    token r23 { <r25> <r1> | <r22> <r14> }
 
    token r28 { <r16> <r1> }
 
    token r4 { <r1> <r1> }
 
    token r20 { <r14> <r14> | <r1> <r15> }
 
    token r3 { <r5> <r14> | <r16> <r1> }
 
    token r27 { <r1> <r6> | <r14> <r18> }
 
    token r14 { "b" }
 
    token r21 { <r14> <r1> | <r1> <r14> }
 
    token r25 { <r1> <r1> | <r1> <r14> }
 
    token r22 { <r14> <r14> }
 
    token r8 { <r42> }
 
    token r26 { <r14> <r22> | <r1> <r20> }
 
    token r18 { <r15> <r15> }
 
    token r7 { <r14> <r5> | <r1> <r21> }
 
    token r24 { <r14> <r1> }
}

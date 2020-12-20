grammar MIBGrammarV2 {
    token r16 { <r95> <r7> | <r53> <r12> }
 
    token r41 { <r12> <r13> | <r7> <r107> }
 
    token r12 { "a" }
 
    token r56 { <r17> <r12> | <r129> <r7> }
 
    token r102 { <r12> <r5> | <r7> <r53> }
 
    token r30 { <r105> <r7> | <r26> <r12> }
 
    token r66 { <r7> <r5> | <r12> <r119> }
 
    token r14 { <r27> <r7> | <r109> <r12> }
 
    token r62 { <r95> <r7> | <r43> <r12> }
 
    token r21 { <r12> <r12> }
 
    token r23 { <r12> <r112> | <r7> <r38> }
 
    token r108 { <r7> <r43> | <r12> <r21> }
 
    token r80 { <r7> <r21> | <r12> <r91> }
 
    token r72 { <r7> <r41> | <r12> <r89> }
 
    token r117 { <r35> <r12> | <r37> <r7> }
 
    token r83 { <r7> <r91> | <r12> <r5> }
 
    token r13 { <r94> <r12> | <r95> <r7> }
 
    token r18 { <r7> <r62> | <r12> <r87> }
 
    token r24 { <r21> <r12> | <r19> <r7> }
 
    token r35 { <r7> <r81> | <r12> <r113> }
 
    token r8 { <r42> || <r42> <r8loop> }

    token r8loop { <r8> ** {1..10} }
 
    token r20 { <r12> <r27> | <r7> <r1> }
 
    token r120 { <r12> <r29> | <r7> <r97> }
 
    token r110 { <r107> <r7> | <r102> <r12> }
 
    token r7 { "b" }
 
    token r32 { <r7> <r92> | <r12> <r83> }
 
    token r116 { <r12> <r40> | <r7> <r98> }
 
    token r86 { <r65> <r94> }
 
    token r75 { <r12> <r118> | <r7> <r119> }
 
    token r46 { <r7> <r103> | <r12> <r80> }
 
    token r49 { <r109> <r7> | <r57> <r12> }
 
    token r95 { <r12> <r12> | <r7> <r7> }
 
    token r128 { <r7> <r19> | <r12> <r5> }
 
    token r19 { <r12> <r65> | <r7> <r7> }
 
    token r94 { <r7> <r12> | <r12> <r7> }
 
    token r99 { <r38> <r12> | <r21> <r7> }
 
    token r130 { <r7> <r6> | <r12> <r116> }
 
    token r76 { <r7> <r118> | <r12> <r94> }
 
    token r85 { <r7> <r67> | <r12> <r126> }
 
    token r104 { <r12> <r19> | <r7> <r38> }
 
    token r22 { <r44> <r7> | <r24> <r12> }
 
    token r79 { <r66> <r7> | <r24> <r12> }
 
    token r114 { <r70> <r7> | <r115> <r12> }
 
    token r27 { <r5> <r12> | <r118> <r7> }
 
    token r4 { <r7> <r91> | <r12> <r21> }
 
    token r105 { <r106> <r7> | <r58> <r12> }
 
    token r70 { <r18> <r7> | <r2> <r12> }
 
    token r33 { <r7> <r112> | <r12> <r38> }
 
    token r71 { <r53> <r12> | <r93> <r7> }
 
    token r87 { <r53> <r7> | <r119> <r12> }
 
    token r28 { <r7> <r64> | <r12> <r16> }
 
    token r63 { <r7> <r13> | <r12> <r33> }
 
    token r9 { <r57> <r7> | <r36> <r12> }
 
    token r34 { <r7> <r74> | <r12> <r59> }
 
    token r60 { <r7> <r108> | <r12> <r86> }
 
    token r67 { <r123> <r12> | <r72> <r7> }
 
    token r37 { <r52> <r12> | <r71> <r7> }
 
    token r112 { <r7> <r12> }
 
    token r44 { <r12> <r5> | <r7> <r118> }
 
    token r26 { <r121> <r7> | <r63> <r12> }
 
    token r50 { <r127> <r12> | <r48> <r7> }
 
    token r15 { <r93> <r12> | <r119> <r7> }
 
    token r68 { <r112> <r12> }
 
    token r78 { <r7> <r77> | <r12> <r36> }
 
    token r59 { <r49> <r12> | <r22> <r7> }
 
    token r109 { <r5> <r12> | <r95> <r7> }
 
    token r17 { <r38> <r12> | <r119> <r7> }
 
    token r54 { <r7> <r68> | <r12> <r25> }
 
    token r92 { <r119> <r12> | <r94> <r7> }
 
    token r123 { <r78> <r7> | <r20> <r12> }
 
    token r65 { <r7> | <r12> }
 
    token r129 { <r21> <r7> | <r21> <r12> }
 
    token r90 { <r12> <r112> | <r7> <r95> }
 
    token r98 { <r7> <r93> | <r12> <r118> }
 
    token r47 { <r12> <r93> | <r7> <r21> }
 
    token r2 { <r47> <r12> | <r103> <r7> }
 
    token r115 { <r125> <r7> | <r56> <r12> }
 
    token r25 { <r43> <r7> | <r38> <r12> }
 
    token r121 { <r7> <r23> | <r12> <r99> }
 
    token r36 { <r12> <r95> | <r7> <r91> }
 
    token r1 { <r7> <r118> | <r12> <r91> }
 
    token r113 { <r53> <r12> | <r119> <r7> }
 
    token r42 { <r12> <r85> | <r7> <r50> }
 
    token r6 { <r90> <r12> | <r88> <r7> }
 
    token r111 { <r5> <r12> | <r5> <r7> }
 
    token r69 { <r12> <r117> | <r7> <r55> }
 
    token r5 { <r12> <r7> }
 
    token r106 { <r12> <r101> | <r7> <r75> }
 
    token r118 { <r7> <r65> | <r12> <r7> }
 
    token r77 { <r7> <r112> | <r12> <r43> }
 
    token r101 { <r53> <r7> | <r38> <r12> }
 
    token r31 { <r7> <r84> | <r12> <r45> }
 
    token r107 { <r53> <r7> | <r118> <r12> }
 
    token r119 { <r12> <r7> | <r12> <r12> }
 
    token r97 { <r119> <r7> | <r112> <r12> }
 
    token r57 { <r12> <r119> | <r7> <r38> }
 
    token r96 { <r7> <r98> | <r12> <r4> }
 
    token r100 { <r96> <r7> | <r120> <r12> }
 
    token r84 { <r12> <r114> | <r7> <r30> }
 
    token r64 { <r112> <r12> | <r94> <r7> }
 
    token TOP { <r8> <r11> }
 
    token r52 { <r43> <r12> | <r118> <r7> }
 
    token r74 { <r12> <r28> | <r7> <r79> }
 
    token r58 { <r12> <r10> | <r7> <r15> }
 
    token r122 { <r12> <r104> | <r7> <r29> }
 
    token r127 { <r130> <r12> | <r100> <r7> }
 
    token r103 { <r21> <r7> }
 
    token r81 { <r7> <r118> | <r12> <r93> }
 
    token r51 { <r122> <r12> | <r9> <r7> }
 
    token r10 { <r118> <r7> | <r119> <r12> }
 
    token r53 { <r12> <r7> | <r7> <r7> }
 
    token r89 { <r12> <r128> | <r7> <r80> }
 
    token r82 { <r12> <r32> | <r7> <r60> }
 
    token r124 { <r111> <r12> | <r108> <r7> }
 
    token r73 { <r19> <r7> | <r5> <r12> }
 
    token r3 { <r7> <r98> | <r12> <r102> }
 
    token r29 { <r38> <r12> | <r5> <r7> }
 
    token r126 { <r12> <r39> | <r7> <r51> }
 
    token r43 { <r7> <r12> | <r7> <r7> }
 
    token r125 { <r73> <r7> | <r76> <r12> }
 
    token r93 { <r65> <r65> }
 
    token r11 { <r42> <r31> || <r11inner> }

    token r11inner { <r42> <r11> <r31> }
 
    token r45 { <r12> <r69> | <r7> <r34> }
 
    token r39 { <r54> <r12> | <r46> <r7> }
 
    token r91 { <r65> <r12> | <r12> <r7> }
 
    token r61 { <r7> <r124> | <r12> <r3> }
 
    token r88 { <r91> <r7> | <r19> <r12> }
 
    token r38 { <r7> <r12> | <r12> <r12> }
 
    token r48 { <r61> <r12> | <r82> <r7> }
 
    token r55 { <r110> <r12> | <r14> <r7> }
 
    token r40 { <r112> <r12> | <r43> <r7> }
}

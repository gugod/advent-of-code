grammar MIBGrammarExamplePart1 {
    token TOP { <r4> <r1> <r5> }
    token r1 { <r2> <r3> | <r3> <r2> }
    token r2 { <r4> <r4> | <r5> <r5> }
    token r3 { <r4> <r5> | <r5> <r4> }
    token r4 { "a" }
    token r5 { "b" }
};

# 0: 4 1 5
# 1: 2 3 | 3 2
# 2: 4 4 | 5 5
# 3: 4 5 | 5 4
# 4: "a"
# 5: "b"

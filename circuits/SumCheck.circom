pragma circom 2.0.0;

// NOTE: reimplemented Sum instead of using the one from util.circom
// since there will be unresolved relative paths in the generated code

template SumCheck(nInputs) {
    signal input in[nInputs][1];
    signal input out[1];

    signal sum_till[nInputs];
    sum_till[0] <== in[0][0];
    for (var i = 1; i<nInputs; i++){
        sum_till[i] <== sum_till[i-1]+in[i][0];
    }
    sum_till[nInputs-1] === out[0]*nInputs;
}

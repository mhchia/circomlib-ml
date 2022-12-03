pragma circom 2.0.0;

include "../../circuits/Conv2D.circom";
include "../../circuits/Dense.circom";
include "../../circuits/ArgMax.circom";
include "../../circuits/Poly.circom";
include "../../circuits/Flatten2D.circom";

template mnist_poly() {
    signal input in[28][28][1];
    signal input conv2d_weights[3][3][1][1];
    signal input conv2d_bias[1];
    signal input dense_weights[676][10];
    signal input dense_bias[10];
    signal output out;

    component conv2d = Conv2D(28,28,1,1,3,1);
    component flatten = Flatten2D(26,26,1);
    component poly[26*26];
    component dense = Dense(676,10);
    component argmax = ArgMax(10);

    for (var i=0; i<28; i++) {
        for (var j=0; j<28; j++) {
            conv2d.in[i][j][0] <== in[i][j][0];
        }
    }

    for (var i=0; i<3; i++) {
        for (var j=0; j<3; j++) {
            conv2d.weights[i][j][0][0] <== conv2d_weights[i][j][0][0];
        }
    }

    conv2d.bias[0] <== conv2d_bias[0];

    for (var i=0; i<26; i++) {
        for (var j=0; j<26; j++) {
            flatten.in[i][j][0] <== conv2d.out[i][j][0];
        }
    }

    for (var i=0; i<26*26; i++) {
        poly[i] = Poly(10**18);
        poly[i].in <== flatten.out[i];
        dense.in[i] <== poly[i].out;
        for (var j=0; j<10; j++) {
            dense.weights[i][j] <== dense_weights[i][j];
        }
    }

    for (var i=0; i<10; i++) {
        dense.bias[i] <== dense_bias[i];
    }

    for (var i=0; i<10; i++) {
        log(dense.out[i]);
        argmax.in[i] <== dense.out[i];
    }

    out <== argmax.out;
}

component main = mnist_poly();
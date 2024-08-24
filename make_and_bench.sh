#! /usr/bin/env bash

bench_tmp_file=$(mktemp)
noop_tmp_file=$(mktemp)

python3 build_benchmark_contract.py templates/benchmark.huff.tmpl bench > contracts/benchmark.huff
python3 build_benchmark_contract.py templates/benchmark.huff.tmpl bench > contracts/noop.huff

huffc --bytecode contracts/benchmark.huff -r 2>&1 | python3 capture_huffc_output.py > $bench_tmp_file
huffc --bytecode contracts/noop.huff -r 2>&1 | python3 capture_huffc_output.py > $noop_tmp_file

input=$(python3 gen_bench_input.py $PRECOMPILE $INPUT_COUNT)

~/projects/go-ethereum/build/bin/evm --codefile $bench_tmp_file --input $input --prestate ./genesis.json --bench run 2>&1

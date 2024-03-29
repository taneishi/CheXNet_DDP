#!/bin/bash
#PBS -l nodes=1:ppn=2
#PBS -N chexnet
#PBS -j oe
#PBS -o output.log

if [ ${PBS_O_WORKDIR} ]; then
    cd ${PBS_O_WORKDIR}
fi

CPUS=2
CORES=24
TOTAL_CORES=$((${CPUS}*${CORES}))

HPUS=8
CORES_PER_PROC=$((${TOTAL_CORES}/${HPUS}))

echo "CPUS=${CPUS} CORES=${CORES} TOTAL_CORES=${TOTAL_CORES} HPUS=${HPUS}"
export OMP_NUM_THREADS=${CORES_PER_PROC}
export KMP_SETTING="KMP_AFFINITY=granularity=fine,compact,1,0"

torchrun --nnodes=1 --nproc_per_node=${HPUS} main.py --hpu --batch_size 4

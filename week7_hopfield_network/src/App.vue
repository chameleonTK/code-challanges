<template>
    
    <header>
      <h1> 
          Hopfield Network
          <button type="button" class="btn btn-outline-secondary" @click="reset()">RESET</button>
      </h1>
    </header>

    <main>
        <div class="container pt-3">
            <div class="row">
              <div class="col p-0">
                <div class="card border-0">
                    
                    <div class="card-body">
                      <h5 class="card-title">Target Data</h5>
                      <div class="memory__container border" v-drag-select="{ getSelectedItems: handleSelectedCell, finishSelectingItems: triggerTrainingNeural }">
                          <div class="row memory__row m-0 " v-for="rowIdx in rect" :key="'memory__row-'+rowIdx">
                              <div 
                                :style="{'background-color': getState(data, rowIdx, colIdx)==1?'#000':'#fff' }" 
                                class="col memory__col selectable border p-0" 
                                v-for="colIdx in rect" 
                                :id="get2DIdxTo1dIdx(rowIdx, colIdx)"
                                :key="'memory__col-'+colIdx"
                                @click="triggerState(data, rowIdx, colIdx)">
                                
                              </div>
                          </div>
                      </div>
                    </div>
                  </div>
                  
              </div>
              <div class="col p-0">
                <div class="card border-0">
                    
                    <div class="card-body">
                      <h5 class="card-title">Network</h5>
                      <div class="memory__container border">
                          <div class="row memory__row m-0 " v-for="rowIdx in rect" :key="'memory__row-'+rowIdx">
                            <div :style="{'background-color': getState(neurons, rowIdx, colIdx)==1?'#000':'#fff' }" class="col memory__col border p-0" v-for="colIdx in rect" :key="'memory__col-'+colIdx">
                                {{ "" }}
                              </div>
                          </div>
                      </div>
                    </div>
                  </div>
                  
              </div>
            </div>
        </div>
    </main>
</template>

<style>

  .memory__col {
    border: 1px solid #bbb;
  }

  /* .memory__col.selected {
    background-color: #000 !important;
  } */

  .memory__col:after {
    content: "";
    display: block;
    padding-bottom: 100%;
  }
</style>


<script setup>

    import { reactive, ref } from 'vue'
    import _ from 'lodash'

    const W = ref(16);
    const rect = reactive(_.range(W.value));

    const N = ref(W.value*W.value);
    const data = reactive(_.range(N.value).map(() => -1));


    const neurons = reactive(_.range(N.value).map(() => Math.random() > 0.5 ? 1 : -1));
    // const neurons = reactive(_.range(N.value).map(() => 1));

    const weights = reactive(_.range(N.value).map(() => _.range(N.value).map(() => 0)));

    const step = reactive({interval: null});

    function get2DIdxTo1dIdx(row, col) {
        return row * W.value + col;
    } 

    function getState(arr, row, col) {
        const idx = get2DIdxTo1dIdx(row, col);
        return arr[idx];
    }

    function triggerState(arr, row, col) {
        const idx = get2DIdxTo1dIdx(row, col);
        // arr[idx] = arr[idx] === 1 ? 0 : 1;
        return ;
    }

    function handleSelectedCell(cells) {
      _.each(cells, (idx) => {
        if (+idx >= data.length) {
          return;
        }

        data[+idx] = 1;
      })
    }


    function resetNetwork() {
      weights.values = _.range(N.value).map(() => _.range(N.value).map(() => 0))
    }

    function trainNetwork() {
      _.range(N.value).map(
        (colIdx) => _.range(N.value).map(
          (rowIdx) => {
            if (colIdx === rowIdx) {
              weights[colIdx][rowIdx] = 0;
            } else {
              weights[colIdx][rowIdx] = data[colIdx] * data[rowIdx];
            }
      }))
    };

    function updateNetwork() {
      if (!_.isNil(step.interval)) {
        clearInterval(step.interval);
      }

      console.log("WEIGHTS", weights);
      step.interval = setInterval(() => {
          const rndIdx = parseInt(Math.random() * N.value);
          if (rndIdx < 0 || rndIdx >= N.value) {
            return false;
          }

          
          const val = _.sum(_.map(weights[rndIdx], (w, idx) => w*neurons[idx]));
          
          neurons[rndIdx] = val >= 0 ? 1 : -1;
          


      }, 1);
    }

    function triggerTrainingNeural() {
      
      resetNetwork();
      trainNetwork();
      updateNetwork();
    }


    function reset() {
      clearInterval(step.interval);
      _.range(N.value).forEach((idx) => {
        data[idx] = -1;
        neurons[idx] = Math.random() > 0.5 ? 1 : -1;
      });
      
    }

    
</script>
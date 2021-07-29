class AntColonyOptimizer{
    constructor(ant_factory) {
        this.weights = []
        this.distances = []

        this.alpha = 1.0 // pheromone weight
        this.beta = 2.0 // greedy weight
        this.evaporate_rate = 0.999
        this.batch_size = 20;

        this.ant_factory = ant_factory;
    }

    init(nodes) {
        this.weights = []
        this.distances = []
        this.nodes = nodes
        this.best_len = 0;
        let n = this.nodes.length;
        this.num_nodes = n

        for(let i=0; i<n; i++) {
            let weight_i = []
            let distance_i = []
            for(let j=0; j<n; j++) {
                weight_i.push(1)

                let na = nodes[i];
                let nb = nodes[j];
                let d = Math.sqrt(Math.pow(na.x-nb.x, 2) + Math.pow(na.y-nb.y, 2))

                this.best_len += d
                distance_i.push(d)
            }
            this.weights.push(weight_i)
            this.distances.push(distance_i)
        }
    }

    
    get_transition_probability(i, j) {
        return Math.pow(this.weights[i][j], this.alpha) * Math.pow(this.distances[i][j], -this.beta)
    }

    run() {
        let num_nodes = this.num_nodes;
        
        // evaporate 
        for(let i=0; i < num_nodes; i++) {
            for(let j=0; j < num_nodes; j++) {
                this.weights[i][j] *= this.evaporate_rate
            }
        }

        let new_weights = _.cloneDeep(this.weights)
        let vm = this;

        _.range(vm.batch_size).forEach(function() {
            var path = []
            var dist = 0.0

            let idx = Math.floor(Math.random()*num_nodes)
            path.push(idx)
            var curr_idx = idx

            while (path.length < num_nodes) {
                var n_sum = 0.0;
                var possible_next = []

                for(let i=0; i < num_nodes; i++) {
                    if (_.includes(path, i)) {
                        continue
                    }
                    n_sum += vm.get_transition_probability(curr_idx, i)
                    possible_next.push(i)
                }
                var r = Math.random()*n_sum
                var x = 0.0

                for(let i=0; i < possible_next.length; i++) {
                    let nn = possible_next[i]
                    
                    x += vm.get_transition_probability(curr_idx, nn)
                    if (r <= x) {
                        dist += vm.distances[curr_idx][nn]
                        curr_idx = nn
                        path.push(nn)
                        break
                    }
                }
            }
            
            dist += vm.distances[curr_idx][idx]
            
            if (dist < vm.best_len) {
                vm.best_len = dist
            }

            // 0.05 to prevent divide by zero
            var diff = dist - vm.best_len + 0.05
            var w = 0.01 / diff
            for(let i=0; i< path.length; i++) {
                let idx1 = path[i]
                let idx2;
                if (i+1 < path.length) {
                    idx2 = path[i+1]
                } else {
                    idx2 = path[0]
                }

                new_weights[idx1][idx2] += w
                new_weights[idx2][idx1] += w
            }

            vm.ant_factory.new_ant(path);
        })

        // Update the weights after normalizing
        for(let i=0; i < num_nodes; i++) {
            var n_sum = 0.0
            for(let j=0; j < num_nodes; j++) {
                if (i == j) {
                    continue
                }
                n_sum += new_weights[i][j]
            }

            for(let j=0; j < num_nodes; j++) {
                // multiplying by 2 since every node has two neighbors eventually
                this.weights[i][j] = 2 * new_weights[i][j] / n_sum
            }
        }

        return this.best_len;
    }

}
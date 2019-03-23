function randInt(maxval) {
    return Math.floor(maxval*Math.random());
}

ImageEvolution = function(conf) {
    this.conf = conf;
    // crossOverRate: 0,
    // mutationRate: 1,
    
    // env
    // env.stepTotal = 0;
    // env.fitness = Number.MAX_SAFE_INTEGER;
    // env.elapsedTime = 0;
    // env.mutsec = 0;
    // env.countBenefit = 0;
    
    this.mutationOpetation = new MutationOpetation();
    this.evoTimeout = 1;
    this.dna = [];

    this.run = function(env) {
        var vm = this;
        this.initDNA(env);
        this.drawDNA(env);

        env.fitness = Number.MAX_SAFE_INTEGER;
        // vm.evolve(env);
        // for (let index = 0; index < 100; index++) {
        //     vm.evolve(env);
            
        // }
        setInterval(function() {
            vm.evolve(env);
        }, this.evoTimeout)
    }

    this.initDNA = function (env) {
        env.actualNumberOfPolys = this.conf.initialPolys;
        this.dna = _.times(this.conf.initialPolys, _.constant(null)).map(function() {
            return new Gene(this.conf, env);
        })
    }

    this.drawDNA = function (env) {
        var ctx = env.contextOutput;
        ctx.fillStyle = "rgb(255,255,255)";
        ctx.fillRect(0, 0, env.width, env.height);
        for(var i=0; i < this.dna.length; i++) {
            this.dna[i].draw(ctx);
        }
    }

    this.computeFitness = function(env) {
        var fitness = 0;

        var dataInput = env.dataInput;
        var dataOutput = env.contextOutput.getImageData(0, 0, env.width, env.height).data;

        for (var i=0;i< env.subpixels;++i) {
            if (i % 4 != 3)
                fitness += Math.abs(dataInput[i] - dataOutput[i]);
        }

        return fitness;
    }

    this.evolve = function(env) {
        var mutatedGene = this.mutateDNA(env);

        var backupGene = this.dna[mutatedGene.index];
        this.dna[mutatedGene.index] = mutatedGene.gene;
        this.drawDNA(env);

        var newFitness = this.computeFitness(env);
        // console.log(env.fitness, newFitness, mutatedGene.gene)
        if (newFitness < env.fitness) {
            //Accept new gene
            env.fitness = newFitness;
            
            //TODO: calculate fitness_normalised
            // FITNESS_BEST_NORMALIZED = 100*(1-FITNESS_BEST/NORM_COEF);

            env.countBenefit++;
            this.drawDNA(env);
        } else {
            this.dna[mutatedGene.index] = backupGene;
        }

        env.stepTotal++;
        //TODO: update 
        // env.elapsedTime = 0;
        // env.mutsec = 0; number of mutation opetation per sec
        
    }

    this.mutateDNA = function(env) {
        return this.mutationOpetation.mutate(this.dna, env);
    }
}


MutationOpetation = function () {

    //TODO: implement gaussian mutation
    this.mutate = function(dna, env) {
        var index = randInt(dna.length);
        var roulette = randInt(2);
        var mutatedGene = dna[index].clone();
        if(roulette==0) {
            this.mutateColor(mutatedGene);
        } else {
            this.mutateShape(mutatedGene, env);
        }

        return {
            gene: mutatedGene,
            index: index
        };        
    }

    this.mutateColor = function (gene) {
        var roulette = randInt(4);
        switch(roulette) {
            case 0: gene.color.r = randInt(255); break;
            case 1: gene.color.g = randInt(255); break;
            case 2: gene.color.b = randInt(255); break;
            case 3: gene.color.a = Math.random(); break;
        }
    }

    this.mutateShape = function (gene, env) {
        var index = randInt(gene.shape.length);
        var roulette = randInt(2);
        switch(roulette) {
            case 0: gene.shape[index].x = randInt(env.width); break;
            case 1: gene.shape[index].y = randInt(env.height); break;
        }
    }
}
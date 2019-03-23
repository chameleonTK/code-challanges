function Gene(conf, env) {
    this.conf = conf;
    this.env = env;
    this.color = {};
    this.shape = [];
    this.init(conf, env);
}

Gene.prototype.clone = function() {
    var newGene = new Gene(this.conf, env);
    newGene.color = {'r': this.color.r,
        'g': this.color.g,
        'b': this.color.b,
        'a': this.color.a
    }

    newGene.shape = this.shape.map(function(s) {
        return {
            x: s.x,
            y: s.y
        }
    });
    
    return newGene;
}

Gene.prototype.init = function (conf, env) {
    var points = _.times(conf.maxNumberOfVertices, _.constant(null))
    .map(function() {
        return {
            x:randInt(env.width),
            y:randInt(env.height)
        };
    });

    var color = {'r':randInt(255),'g':randInt(255),'b':randInt(255),'a':0.1};

    this.color = color;
    this.shape = points;
}

Gene.prototype.draw = function(ctx) {
    var color = this.color;
    var shape = this.shape;
    ctx.fillStyle = "rgba("+color.r+","+color.g+","+color.b+","+color.a+")";

    ctx.beginPath();
    ctx.moveTo(shape[0].x, shape[0].y);
    for(var j=1; j< shape.length;j++) {
        ctx.lineTo(shape[j].x, shape[j].y);
    }
    
    ctx.closePath();
    ctx.fill();
}
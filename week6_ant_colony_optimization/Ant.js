class AntFactory{
    constructor(svg, steps) {
        this.ants = []
        this.steps = steps
        this.svg = svg;
    }

    init(nodes) {
        this.nodes = nodes;
    }

    new_ant(path, dist) {
        
        let n = this.nodes[path[0]];
        let x = n.x;
        let y = n.y;
        this.ants.push(new Ant(x, y, path, this.steps, this.nodes, this.svg, dist))
    }

    move(callback) {
        _.each(this.ants, function(a) {
            a.move(callback);
        })
    }

    clear_ants() {
        _.remove(this.ants, function(a) {
            return a.end;
        })
    }
}

class Ant{
    constructor(x, y, path, steps, nodes, svg, dist) {
        this.x = x;
        this.y = y;

        this.path = path;
        this.dist = dist;
        this.idx = 0
        let n = path.length;
        // let d = Math.floor(steps/n);

        this.end = false;

        let points = [
            [x, y]
        ]

        for(let i=0; i<path.length; i++) {
            let na = path[i]
            let nb;
            if (i+1 < path.length) {
                nb = path[i+1]
            } else {
                nb = path[0]
            }

            let dx = (nodes[nb].x - nodes[na].x);
            let dy = (nodes[nb].y - nodes[na].y);

            let norm = Math.sqrt(dx*dx + dy*dy);
            
            // walk k units at each step
            let k = 1;
            dx = (dx / norm) * k;
            dy = (dy / norm) * k;
            
            while(true) {
                x = x + dx;
                y = y + dy;
                let nx = (nodes[na].x - x);
                let ny = (nodes[na].y - y);

                let newd = Math.sqrt(nx*nx + ny*ny);
                if (newd >= norm) {
                    break
                }

                points.push([x, y])
            }

            points.push([nodes[nb].x, nodes[nb].y])
        }

        this.points = points;
        this.a = svg.append("circle")
                    .style("stroke", "gray")
                    .style("fill", "black")
                    .attr("r", 2)
                    .attr("cx", this.x)
                    .attr("cy", this.y);


    }

    move(callback) {
        
        this.idx += 1
        if (this.idx >= this.points.length) {
            this.a.remove();
            this.end = true;
            callback(this);
            return;
        }

        let pt = this.points[this.idx]
        this.x = pt[0]
        this.y = pt[1]
        
        this.a
            .attr("cx", this.x)
            .attr("cy", this.y);
    }
}
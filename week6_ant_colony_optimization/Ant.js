class AntFactory{
    constructor(svg, steps) {
        this.ants = []
        this.steps = steps
        this.svg = svg;
    }

    init(nodes) {
        this.nodes = nodes;
    }

    new_ant(path) {
        let n = this.nodes[path[0]];
        let x = n.x;
        let y = n.y;
        this.ants.push(new Ant(x, y, path, this.steps, this.nodes, this.svg))
    }

    render() {
        _.each(this.ants, function(a) {
            a.move();
        })
    }
}

class Ant{
    constructor(x, y, path, steps, nodes, svg) {
        this.x = x;
        this.y = y;

        this.idx = 0
        let n = path.length;
        // let d = Math.floor(steps/n);

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

    move() {
        
        this.idx += 1
        if (this.idx >= this.points.length) {
            this.a.remove();
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
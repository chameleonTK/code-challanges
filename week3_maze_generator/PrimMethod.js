class PrimMethod{
    constructor(cells) {
        this.cells = cells;
        this.reset()
    }

    reset() {
        this.frontier = new TinyQueue([], function (a, b) {
            return a.priority - b.priority;
        });

        let n = this.cells.length;
        for (let i=0; i<n; i++) {
            for (let j=0; j<n; j++) {
                cells[i][j].index = i*n + j;
                
                cells[i][j].visited = false;
                cells[i][j].hideLeft = false;
                cells[i][j].hideTop = false;
                cells[i][j].c = "rgb(190, 190, 190)";
            }
        }
    
        let init = Math.floor(Math.random()*n*n);
        let x = init % n;
        let y = Math.floor(init / n);
        this.cells[x][y].visited = true;
        this.addNeighbors(x, y);

        let direction = [];
        direction.push(Direction.UP);
        direction.push(Direction.DOWN);
        direction.push(Direction.LEFT);
        direction.push(Direction.RIGHT);
        this.direction = direction;
    }

    getCell(x, y) {
        if (x < 0 || x >= this.cells.length) {
            return null;
        }
    
        if (y < 0 || y >= this.cells.length) {
            return null;
        }
    
        return this.cells[x][y];
    }

    addNeighbors(x, y) {
        let a;

        a = this.getCell(x-1, y);
        if (a != null && !a.visited) {
            a.c = "rgb(255, 221, 221)";
            this.frontier.push({"x": x-1, "y": y, "priority": Math.random()});  
        }
        
        a = this.getCell(x+1, y);
        if (a != null && !a.visited) {
            a.c = "rgb(255, 221, 221)";
            this.frontier.push({"x": x+1, "y": y, "priority": Math.random()});  
        }
        
        a = this.getCell(x, y+1);
        if (a != null && !a.visited) {
            a.c = "rgb(255, 221, 221)";
            this.frontier.push({"x": x, "y": y+1, "priority": Math.random()});  
        }
        
        a = this.getCell(x, y-1);
        if (a != null && !a.visited) {
            a.c = "rgb(255, 221, 221)";
            this.frontier.push({"x": x, "y": y-1, "priority": Math.random()});  
        }
    }


    run() {
        let frontier = this.frontier;

        if (frontier.length <= 0) {
            return false;
        }
    
        let n = frontier.pop();
        while(this.cells[n.x][n.y].visited) {
            if (frontier.length <= 0) {
                return false;
            }
            n = frontier.pop();
        }

        let direction = _.shuffle(this.direction);

        let vm = this;
        let done = false
        _.each(direction, function(d) {
            if (done) {
                return;
            }

            let c;
            switch(d){
                case Direction.LEFT:
                    c = vm.getCell(n.x-1, n.y);
                    break;
                case Direction.RIGHT:
                    c = vm.getCell(n.x+1, n.y);
                    break;
                case Direction.UP:
                    c = vm.getCell(n.x, n.y-1);
                    break;
                case Direction.DOWN:
                    c = vm.getCell(n.x, n.y+1);
                    break;
                default:
                    break;
            }

            if (c == null) {
                return;
            }
            
            if (!c.visited) {
                return;
            }

            switch(d){
                case Direction.LEFT:
                  vm.cells[n.x][n.y].hideLeft = true;
                  break;
                case Direction.RIGHT:
                  vm.cells[n.x+1][n.y].hideLeft = true;
                  break;
                case Direction.UP:
                  vm.cells[n.x][n.y].hideTop = true;
                  break;
                case Direction.DOWN:
                  vm.cells[n.x][n.y+1].hideTop = true;
                  break;
                default:
                  break;
            }

            done = true;
        })

        this.cells[n.x][n.y].visited = true;
        this.addNeighbors(n.x, n.y);
        return true;
    }
}
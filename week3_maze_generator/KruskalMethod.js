class KruskalMethod{
    constructor(cells) {
        this.cells = cells;
        this.reset()
    }

    reset() {
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
    
        let setIndex = [];
        let edges = [];
        
        for (let i=0; i<n; i++) {
            for (let j=0; j<n; j++) {
                let tmp = [];
                tmp.push(cells[i][j]);
                setIndex.push(tmp);
            }
        }
    
        for (let i=0; i<n-1; i++) {
            for (let j=0; j<n; j++) {
                edges.push({
                    "x": i,
                    "y": j,
                    "d": Direction.HORIZONTAL
                })
            }
        }
    
        for (let i=0; i<n; i++) {
            for (let j=0; j<n-1; j++) {
                edges.push({
                    "x": i,
                    "y": j,
                    "d": Direction.VERTICAL
                })
            }
        }

        edges = _.shuffle(edges);
        this.bigestSet = 1;
        this.setIndex = setIndex;
        this.edges = edges;
    }

    next() {
        let a, b, e;
        do {
            e = this.edges.pop();
            let x = e.x;
            let y = e.y;
            a = this.cells[x][y];
            b = null;
            if (e.d==Direction.HORIZONTAL) {
                b = this.cells[x+1][y];        
            } else {
                b = this.cells[x][y+1];
            }
        } while(a.index==b.index);
        
        return e;
    }

    run() {
        if (this.bigestSet >= this.setIndex.length) {
            return false;
        }
      
        let e = this.next();
        let a, b;
        let x = e.x;
        let y = e.y;
        a = this.cells[x][y];
        b = null;
        if (e.d==Direction.HORIZONTAL) {
            b = this.cells[x+1][y];        
        } else {
            b = this.cells[x][y+1];
        }
        
        // if (a.index != b.index) {
        a.visited = true;
        b.visited = true;
        if (e.d==Direction.HORIZONTAL) {
            b.hideLeft = true;
        } else {
            b.hideTop = true;
        }
        
        let setIndex = this.setIndex;
        this.bigestSet = setIndex[a.index].length + setIndex[b.index].length;
            
        let bigger = a;
        let smaller = b;
        if (setIndex[a.index].length < setIndex[b.index].length) {
            bigger = b;
            smaller = a;
        }

        _.each(setIndex[smaller.index], function(c) {
            c.index = bigger.index;
            setIndex[bigger.index].push(c);
        })

        setIndex[smaller.index] = setIndex[bigger.index];
        return true
    }
}
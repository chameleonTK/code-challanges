class EllerMethod{
    constructor(cells) {
        this.cells = cells;
        this.row = 0;
        this.col = 0;

        this.done = false;
        this.reset()
    }

    reset() {
        this.row = 0;
        this.col = 0;

        this.done = false;

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
        console.log(this.cells);
    }

    print_() {
        let s = ""
        for (let i=0; i<n; i++) {
            for (let j=0; j<n; j++) {
              s += (" "+cells[j][i].index)
            }
            s += "\n"
        }
        console.log(s)
    }

    
    run() {
        if (this.done) {
            return false;
        }

        let n = this.cells.length;
        if (this.col < n) {
            this.horizontalConnect();
            this.col++;
        } else {
            if (this.row+1 < n) {
                this.verticalConnect();
            }
        
            for(let i=0; i<n; i++) {
                this.cells[i][this.row].visited = true;
            }

            this.col = 0;
            this.row++;
        }
        
        
        if (this.row >= n) {
            this.finalise();
            this.done = true;
            return false;
        }

        return true
    }

    horizontalConnect() {
        let col = this.col;
        let row = this.row;

        let now = this.cells[col][row];
        now.c = "rgb(251, 251, 202)";
        
        if (Math.random() > 0.5) {
            now.hideLeft = true;
            if (col!=0) {
                if (this.cells[col-1][row].index < now.index) {
                    now.index = this.cells[col-1][row].index;  
                } else {
                    this.cells[col-1][row].index = now.index;
                }
                
            }
        }
    }

    verticalConnect() {
        let hasConnection = {};
        let n = this.cells.length;
        let col = this.col;
        let row = this.row;

        for(let i=0; i<n; i++) {
            let now = this.cells[i][row];
            hasConnection[now.index] = false;
        }

        //Randomly create vertical connections
        for(let i=0; i<n; i++) {
            if (Math.random() > 0.5) {
                this.cells[i][row+1].hideTop = true;
                this.cells[i][row+1].index = this.cells[i][row].index;
                hasConnection[this.cells[i][row+1].index] = true;
            }
        }

        // Make sure that at least one vertical connection for each set;
        var vm = this;
        _.each(hasConnection, function(connected, index) {
            if (connected) {
                return;
            }

            let count = 0;
            for(let i=0; i<n; i++) {
                let now = vm.cells[i][row];
                if (now.index == index) {
                    count++;
                }
            }
            
            
            let d = Math.floor(Math.random()*count);
            count = 0;
            for(let i=0; i<n; i++) {
                let now = vm.cells[i][row];
                if (now.index == index && count == d) {
                    vm.cells[i][row+1].hideTop = true;
                    vm.cells[i][row+1].index = vm.cells[i][row].index;
                    break;
                }
                
                if (now.index == index) {
                    count++;
                }
            }
        })
    }

    finalise() {
        let n = this.cells.length;
        let col = this.col;
        let row = this.row;
        

        for(let i=0; i<n-1; i++) {
            let now = this.cells[i][n-1];
            let sibling = this.cells[i+1][n-1];
            // console.log(now.index)
            // this.print_()
            if (now.index != sibling.index) {
                let rm = sibling.index;
                sibling.hideLeft = true;
                sibling.index = now.index;
                for(let j=i+1; j<n; j++) {
                    if (this.cells[j][n-1].index == rm) {
                        this.cells[j][n-1].index = now.index;
                    }
                }
            }
        }
    }
}
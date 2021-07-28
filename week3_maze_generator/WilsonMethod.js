class WilsonMethod{
    constructor(cells) {
        this.cells = cells;
        this.reset()
    }

    reset() {
        this.order = [];
        this.directionTable = [];

        let n = this.cells.length;
        for (let i=0; i<n; i++) {
            let dirrow = [];
            for (let j=0; j<n; j++) {
                cells[i][j].index = i*n + j;
                this.order.push(i*n + j)
                dirrow.push(0);

                cells[i][j].visited = false;
                cells[i][j].hideLeft = false;
                cells[i][j].hideTop = false;
                cells[i][j].c = "rgb(190, 190, 190)";

            }
            this.directionTable.push(dirrow)
        }

        this.now = null;
        this.start = null;
        this.order = _.shuffle(this.order);

        let init = this.order.shift();
        let x = init % n;
        let y = Math.floor(init / n);
        this.cells[x][y].visited = true;
    }

    setupStartPoint() {
        let x, y;
        while (true) {
            if (this.order.length <= 0) {
                break;
            }
      
            let init = this.order.shift();
            x = init % n;
            y = Math.floor(init / n);
      
            if (!this.cells[x][y].visited) {
                break;
            }
        }
    
    
        this.now = this.cells[x][y];
        this.now.c = "rgb(251, 251, 202)";
        this.start = this.now;
    }

    move() {
        if (this.now.visited) {
            return;
        }

        while(true) {
            let d = Math.floor(Math.random()*100);
            let next = null;
            let now = this.now;

            switch(d%4){
                case 0:
                    this.directionTable[now.x][now.y] = Direction.LEFT;
                    next = this.getCell(now.x-1, now.y);
                    break;
                case 1:
                    this.directionTable[now.x][now.y] = Direction.RIGHT;
                    next = this.getCell(now.x+1, now.y);
                    break;
                case 2:
                    this.directionTable[now.x][now.y] = Direction.UP;
                    next = this.getCell(now.x, now.y-1);
                    break;
                case 3:
                    this.directionTable[now.x][now.y] = Direction.DOWN;
                    next = this.getCell(now.x, now.y+1);
                    break;
            }
            
            if (next == null) {
                continue;
            }
            
            now.c = "rgb(255, 221, 221)";
            next.c = "rgb(251, 251, 202)";
            this.now = next;
            break;
        }
    }

    addToMaze() {
        let start = this.start;
        if (start.visited) {
            return;
        }

        start.visited = true;
        switch(this.directionTable[start.x][start.y]){
            case Direction.LEFT:
                this.start.hideLeft = true;
                this.start = this.getCell(start.x-1, start.y);
                break;
            case Direction.RIGHT:
                this.start = this.getCell(start.x+1, start.y);
                this.start.hideLeft = true;
                break;
            case Direction.UP:
                this.start.hideTop = true;
                this.start = this.getCell(start.x, start.y-1);
                break;
            case Direction.DOWN:
                this.start = this.getCell(start.x, start.y+1);
                this.start.hideTop = true;
                break;
            default:
                break;
        }
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

    run() {
        if (this.order.length <= 0) {
            return false;
        }
    
        if (this.now == null) {
            this.setupStartPoint();
            return true;
        }

        this.move();
        if (this.now.visited) {
            this.addToMaze();
        }

        let n = this.cells.length;
        if (this.start.visited) {
            for (let i=0; i<n; i++) {
                for (let j=0; j<n; j++) {
                    if (!this.cells[i][j].visited) {
                        this.cells[i][j].c = "rgb(190, 190, 190)";
                    }
                }
            }
            
            this.now = null;
            this.start = null;
        }
        return true;
    }
}
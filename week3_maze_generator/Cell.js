class Cell{
    constructor(index, x, y, size, offset) {
      this.index = index;
      this.x = x;
      this.y = y;
      this.size = size;
      this.offset = offset;

      this.visited = false;
      this.hideLeft = false;
      this.hideTop = false;
      this.c = "rgb(190, 190, 190)";
    }

    draw(svg) {
        let px = this.x*size+offset/2;
        let py = this.y*size+offset/2;

        this.g = svg.append("g")

        this.rect = this.g.append('rect')
            .attr('x', px)
            .attr('y', py)
            .attr('width', size)
            .attr('height', size)
            .attr('stroke', this.c)
            .attr('fill', this.c);
        
        this.linetop = this.g.append('line')
            .style("stroke", "#000")
            .style("stroke-width", 2)
            .attr("x1", px)
            .attr("y1", py)
            .attr("x2", px+this.size)
            .attr("y2", py); 

        this.lineleft = this.g.append('line')
            .style("stroke", "#000")
            .style("stroke-width", 2)
            .attr("x1", px)
            .attr("y1", py)
            .attr("x2", px)
            .attr("y2", py+this.size); 

        this.drawBorder();
    }
    
    repaint() {
        if (this.visited) {
            this.rect.style("fill", "#fff");
        } else {
            this.rect.style("fill", this.c);
        }

        this.drawBorder();
    }

    drawBorder(offset) {
        if (this.hideTop) {
            this.linetop.style("stroke", "#fff");
        } else {
            this.linetop.style("stroke", "#000");
        }
        
        if (this.hideLeft) {
            this.lineleft.style("stroke", "#fff");
        } else {
            this.lineleft.style("stroke", "#000");
        }
    }

  
}
  
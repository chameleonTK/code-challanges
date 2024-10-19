import { nextTick } from "vue";
export default {
  mounted(el, binding) {
    let isSelecting = false; // if the selection has started
    let initialX = null; // the initial mouse click - x
    let initialY = null; // the initial mouse click - y
    let selectableElements = [];

    const updateselectableElements = () => {
      nextTick(() => {
        selectableElements = el.querySelectorAll(".selectable"); // add "selectable" class to the items that needs selection
      });
    };

    updateselectableElements();
    
    const getSelectedItems = binding.value.getSelectedItems;
    const finishSelectingItems = binding.value.finishSelectingItems;


    const handleMouseDown = (event) => {
        if(!isSelecting){
            getSelectedItems([]); //empty the previous selected items
        }
      isSelecting = true;
      initialX = event.pageX;
      initialY = event.pageY;
      
      selectableElements.forEach((item) => item.classList.remove("selected"));
    };

    const handleMouseMove = (event) => {
      if (!isSelecting) return;
      const currentX = event.pageX;
      const currentY = event.pageY;
      const diffX = currentX - initialX;
      const diffY = currentY - initialY;

      const selectedItems = [];
      selectableElements.forEach((selectable, idx) => {
        let {
          left: elLeft,
          top: elTop,
          right: elRight,
          bottom: elBottom,
        } = selectable.getBoundingClientRect();
        
        elLeft += window.scrollX;
        elRight += window.scrollX;

        elTop += window.scrollY;
        elBottom += window.scrollY;
        
        if (
            elLeft < currentX && currentX < elRight &&
            elTop < currentY && currentY < elBottom
        ) {
            selectable.classList.add("selected");
            const itemId = selectable.id;
            if (itemId) {
                selectedItems.push(itemId);
            }
        } else {
            // selectable.classList.remove("selected");
        }
      });

      getSelectedItems(selectedItems);
    };

    const handleMouseUp = () => {
      if (isSelecting) {
        isSelecting = false;
        finishSelectingItems();
      }

      
    };

    el.addEventListener("mousedown", handleMouseDown);
    document.addEventListener("mousemove", handleMouseMove);
    document.addEventListener("mouseup", handleMouseUp);

    el.cleanup = () => {
      el.removeEventListener("mousedown", handleMouseDown);
      document.removeEventListener("mousemove", handleMouseMove);
      document.removeEventListener("mouseup", handleMouseUp);
    };

    
  },
  unmounted(el) {
    el.cleanup();
  },
};
var AddChildMenu = Behavior.create({
  initialize: function() {
    this.parent = $(this.element.parentNode);
    document.observe('click', this.hideMenu.bindAsEventListener(this))
  },
  onclick: function(event) {
    event.stop();
    if(!this.menu){
      try {
      this.parent.insert(add_child_menu);
      this.menu = this.parent.down("ul.add_child_menu");
      this.menu.getElementsBySelector("li a").each(function(element){
        if(element.title != '') 
          element.href = this.element.href + "?template=" + element.title;
        else
          element.href = this.element.href;
        element.title = null;
      }, this);
      } catch(e) { alert(e); }
    }
    this.menu.show();
  },
  hideMenu: function(){
    if(this.menu)
      this.menu.hide();
  }
});
Event.addBehavior({
  '.add-child a': AddChildMenu
});
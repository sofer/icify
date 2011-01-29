var ICE = {}

ICE.session = {
  
  editStockId: null,
  
  getContent: function() {
    
  },
  
  editStock: function(item) {
    var title = item.text();
    var inventory = item.parent().children('.inventory').text();
    $('#stock-title').text(title);
    $('#stock-current').val(inventory);
    $('#stock-difference').val('0');
    $('#new-stock-level').val(inventory);
    self.editStockId = item.attr('data-variant-id');
    $('edit-stock-id').val(inventory);
  },
  
  incrementStock: function(inc) {
    var inventory = parseInt($('#new-stock-level').val())+inc;
    if (inventory < 0) { inventory = 0; }
    $('#new-stock-level').val(inventory);
  },

  updateStock: function() {
    var inventory = $('#new-stock-level').val();
    var selector = 'a[data-variant-id="'+self.editStockId+'"]';
    $(selector).parent().children('.inventory').text(inventory);
  }
  
}


$(document).ready(function() {

  ICE.session.getContent();
  
  $('.stock a').live('click tap', function(){
    ICE.session.editStock($(this));
  });
  
  $('#add-stock').live('click tap', function(){
    ICE.session.incrementStock(1);
  });
  
  $('#remove-stock').live('click tap', function(){
    ICE.session.incrementStock(-1);
  });

  $('#stock-edit').live('pagehide', function(){
    ICE.session.updateStock();
  });

  // NOT WORKING
  $('#add-stock').live('taphold', function(){
    ICE.session.incrementStock(10);
  });
  $('#remove-stock').live('taphold', function(){
    ICE.session.incrementStock(-10);
  });
  $('#remove-stock').live('touchend', function(){
    alert('touchend')
  });
  


})

// see http://stackoverflow.com/questions/2010892/storing-objects-in-html5-localstorage
Storage.prototype.setObject = function(key, value) {
    this.setItem(key, JSON.stringify(value));
}
Storage.prototype.getObject = function(key) {
    return JSON.parse(this.getItem(key));
}

String.prototype.unhyphenate = function () {
  return this.replace(/-/g, ' ');
};

var ICE = {}

ICE.session = {
    
  company: [],
  editStockId: null,
  
  getStock: function() {
    this.subjects = localStorage.getObject('company') || [];
    if (this.company.length > 0) {
      this.loadFront();
    } else {
      this.getRemoteStock();
    }
    
  },
  
  // json request
  getRemoteStock: function() {
    var that = this;
    var jsonUrl = 'http://' + document.location.host + '/companies/1.json'; //generalize later
    $.ajax({
      url: jsonUrl,
      dataType: 'json',
      error: function () {
        alert("Failed to retrieve stock list. Please try again later.");
      },
      success: function(json){
        that.company = json.company;
        localStorage.setObject('company', that.company);
        that.loadFront();
      }
    });
  },
  
  loadFront: function() {
    $('#home div[data-role="content"]').html('');
    var list = $('<ul data-role="listview"/>');
    for (var i=0;i<this.company.brands.length;i++) {
      var collection = this.company.brands[i];
      var item = $('<li>');
      var link = $('<a>').attr({
        href: '#products',
        'data-brand-index': i
      }).text(collection.name);
      item.append(link)
      list.append(item);
    }
    $('#home div[data-role="content"]').append(list);
    $('#home ul[data-role="listview"]').listview(); //regenerate the listview
  },
  
  // not in use
  loadCollections: function(link) {
    var kind = link.attr('data-kind');    
    $('#collections div[data-role="content"]').html('');
    var list = $('<ul data-role="listview"/>');
    for (var i=0;i<this.company[kind].length;i++) {
      var collection = this.company[kind][i];
      var item = $('<li>');
      var link = $('<a>').attr({
        href: '#products',
        'data-kind': kind,
        'data-id': i
      }).text(collection.name);
      item.append(link)
      list.append(item);
    }
    $('#collections div[data-role="content"]').append(list);
    $('#collections ul[data-role="listview"]').listview(); //regenerate the listview
  },

  loadProducts: function(link) {
    var brand_index = link.attr('data-brand-index');
    var brand = this.company.brands[brand_index];
    $('#products h1').text(brand.name);
    $('#products div[data-role="content"]').html('');
    var list = $('<ul data-role="listview" data-filter="true" data-inset="true"/>');
    for (var i=0;i<brand.products.length;i++) {
      var product = brand.products[i];
      var item = $('<li data-role="list-divider">');
      item.text(product.name);
      list.append(item);
      for (var j=0;j<product.variants.length;j++) {
        var variant = this.addVariant(product.variants[j]);
        list.append(variant);
      }
    }
    $('#products div[data-role="content"]').append(list);
    $('#products ul[data-role="listview"]').listview(); //regenerate the listview
  },
  
  addVariant: function(variant) {
    var item = $('<li>');
    var link = $('<a>').attr({
      href: '#stock-edit',
      'data-rel': 'dialog', 
      'data-transition': 'pop',
      'data-variant-id': variant.id,
      'data-variant-inventory': variant.inventory        
    }).text(variant.sku.unhyphenate());
    item.append(link);
    var count = $('<div>').attr({
      class: 'ui-li-count inventory'
    }).text(variant.inventory);
    item.append(count);
    return item;
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

  ICE.session.getStock();
  
  $('#home a').live('click tap', function(){
    ICE.session.loadProducts($(this));
  });

  $('#products a').live('click tap', function(){
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
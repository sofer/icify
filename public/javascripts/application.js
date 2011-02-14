
// see http://stackoverflow.com/questions/2010892/storing-objects-in-html5-localstorage
Storage.prototype.setObject = function(key, value) {
  this.setItem(key, JSON.stringify(value));
}
Storage.prototype.getObject = function(key) {
  return this.getItem(key) && JSON.parse(this.getItem(key));
}

String.prototype.unhyphenate = function () {
  return this.replace(/-/g, ' ');
};

var ICE = {}

ICE.session = {
    
  company: {},
  editStockId: null,
  currentBrandIndex: '0',
  currentCollectionIndex: '0',
  
  // json request
  getStock: function() {
    var that = this;
    var jsonUrl = 'http://' + document.location.host + '/companies/1.json'; //generalize later
    $.ajax({
      url: jsonUrl,
      dataType: 'json',
      error: function () {
        that.company = localStorage.getObject('company') || {};
        if (that.company.name) {
          that.loadFront();
          alert("Failed to retrieve stock list. Loading from local cache.");
        } else {
          alert("Failed to retrieve stock list. Try again later.");
        }
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
        href: '#collections',
        'data-brand-index': i
      }).text(collection.name);
      item.append(link)
      list.append(item);
    }
    $('#home div[data-role="content"]').append(list);
    $('#home ul[data-role="listview"]').listview(); //regenerate the listview
  },

  loadCollections: function() {
    var brand = this.company.brands[this.currentBrandIndex];
    $('#collections div[data-role="content"]').html('');
    var list = $('<ul data-role="listview"/>');
    for (var i=0;i<brand.collections.length;i++) {
      var collection = brand.collections[i];
      var item = $('<li>');
      var link = $('<a>').attr({
        href: '#products',
        'data-collection-index': i
      }).text(collection.name);
      item.append(link)
      list.append(item);
    }
    $('#collections div[data-role="content"]').append(list);
    $('#collections ul[data-role="listview"]').listview(); //regenerate the listview
  },
  
  selectBrand: function(link) {
    this.currentBrandIndex = link.attr('data-brand-index');
  },

  selectCollection: function(link) {
    this.currentCollectionIndex = link.attr('data-collection-index');
  },

  loadProducts: function(link) {
    var collection = this.company.brands[this.currentBrandIndex].collections[this.currentCollectionIndex];
    $('#products h1').text(collection.name);
    $('#product-list').html('');
    var list = $('<ul data-role="listview" data-filter="true" data-inset="true"/>');
    for (var i=0;i<collection.products.length;i++) {
      var product = collection.products[i];
      var item = $('<li data-role="list-divider">');
      item.text(product.title);
      list.append(item);
      for (var j=0;j<product.variants.length;j++) {
        var variant = this.addVariant(product.variants[j], i, j);
        list.append(variant);
      }
    }
    $('#product-list').append(list);
    $('#products ul[data-role="listview"]').listview(); //regenerate the listview
  },
  
  addVariant: function(variant, product_index, variant_index) {
    var item = $('<li>');
    var link = $('<a>').attr({
    //item.attr({
      href: '#stock-edit',
      'data-rel': 'dialog', 
      'data-transition': 'pop',
      'data-variant-id': variant.id, 
      'data-variant-index': variant_index, 
      'data-product-index': product_index
    }).text(variant.sku.unhyphenate());
    item.append(link);
    var count = $('<div>').addClass(
      'ui-li-count inventory'
    ).attr({
      'data-variant-id': variant.id
    }).text(variant.inventory||'0');
    item.append(count);
    return item;
  },

  editStock: function() {
    var li = $('#products li a[data-variant-id="'+this.editStockId+'"]')
    var title = li.text();
    var inventory = li.parent().children('.inventory').text();
    $('#stock-title').text(title);
    $('#stock-current').val(inventory);
    $('#stock-difference').val('0');
    $('#new-stock-level').val(inventory);
    self.editStockId = li.attr('data-variant-id');
    $('edit-stock-id').val(inventory);
  },
  
  incrementStock: function(inc) {
    var inventory = parseInt($('#new-stock-level').val())+inc;
    if (inventory < 0) { inventory = 0; }
    $('#new-stock-level').val(inventory);
  },

  incrementStock2: function(inc) {
    var selector = '.inventory[data-variant-id="'+this.editStockId+'"]';
    var inventory = parseInt($(selector).text())+inc;
    if (inventory >= 0) { 
      $(selector).text(inventory); 
    }
  },

  updateStock: function() {
    var inventory = $('#new-stock-level').val();
    var selector = '.inventory[data-variant-id="'+this.editStockId+'"]';
    $(selector).text(inventory);
  }
  
}

$(document).bind("mobileinit", function(){

  ICE.session.getStock();
  window.location = '#home';

    
  $('#home a').live('click tap', function(){
    ICE.session.selectBrand($(this));
  });

  $('#collections a').live('click tap', function(){
    ICE.session.selectCollection($(this));
  });

  $('#collections').live('pageshow', function(event, ui){
    $.mobile.pageLoading();
    ICE.session.loadCollections();
    $.mobile.pageLoading(true);
  });

  $('#products').live('pageshow', function(event, ui){
    $.mobile.pageLoading();
    ICE.session.loadProducts();
    $.mobile.pageLoading(true);
  });
  
  $('#products').live('scrollstart', function(){
    alert('scrolling');
  })

  $('#product-list a').live('click tap', function(){
    ICE.session.editStockId = $(this).attr('data-variant-id');
    //ICE.session.incrementStock2(1);
  });
  
  // pageshow not working for dialogs
  $('#stock-edit').live('pageshow', function(event, ui){
    ICE.session.editStock();
  });

  $('#add-stock').live('click tap', function(){
    ICE.session.incrementStock(1);
  });
  
  $('#remove-stock').live('click tap', function(){
    ICE.session.incrementStock(-1);
  });

  // pagehide does work for dialogs
  $('#stock-edit').live('pagehide', function(){
    ICE.session.updateStock();
  });

  $('#add-stock').live('taphold', function(){
    ICE.session.incrementStock(9);
  });
  $('#remove-stock').live('taphold', function(){
    ICE.session.incrementStock(-9);
  });

})

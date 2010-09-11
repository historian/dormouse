var Filters = {
  setup: function(){
    var filters = $('#sidebar .block .filters');

    $('.letters label', filters).click(function(){
      $(this).next('input').click();
      $('form', filters).submit();
    });

    $('.page-size select', filters).change(function(){
      $('form', filters).submit();
    });

  }
};

$(function(){
  Filters.setup();
});
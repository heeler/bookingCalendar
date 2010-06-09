// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $('#user_color').ColorPicker(
    {
    	onSubmit: function(hsb, hex, rgb, el) {
    		$(el).val(hex);
    		$(el).ColorPickerHide();
    	},
    	onBeforeShow: function () {
    		$(this).ColorPickerSetColor(this.value);
    	}
    }
    );
});
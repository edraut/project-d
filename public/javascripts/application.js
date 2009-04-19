// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function handleCCForm(){
	if($("[ui_binding='address_form']").length == 0){
		$('#place_order').show();
	} else {
		$('#place_order').hide();
	}
};

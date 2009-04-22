// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function handleCCForm(){
	if($("[ui_binding='address_form']").length == 0){
		$('#place_order').show();
	} else {
		$('#place_order').hide();
	}
};
function reloadTotals(){
	$.ajax({
		url: '/cart',
		type: 'GET',
		data: {get_totals: 'true'},
		dataType: 'json',
		success: function(data,textStatus) {
			$('#shipping_total').html(data.shipping_total);
			$('#subtotal').html(data.subtotal);
			$('#total').html(data.total);
			$('#sales_tax').html(data.sales_tax);
			if(data.sales_tax != '$0.00'){
				$('#sales_tax_container').show();
			} else {
				$('#sales_tax_container').hide();
			}
		}
	})
};

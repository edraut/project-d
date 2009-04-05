function bindAjaxEvents(target_document){
	$("[ajax_binding='ajax_form']",target_document).unbind('submit', ajaxEvent);	
	$("[ajax_binding='ajax_form']").bind('submit', ajaxEvent);
	$("[ajax_binding='ajax_link']",target_document).unbind('click', ajaxEvent);	
	$("[ajax_binding='ajax_link']").bind('click', ajaxEvent);
};
function ajaxEvent(e){
	our_element = $(e.target);
	if(our_element.is('form')){
		element_type = 'form';
	} else if(our_element.is('a')) {
		element_type = 'link';
	} else if(our_element.parents('a').length > 0){
		element_type = 'link';
		our_element = our_element.parents('a');
	}
	if(our_element.attr('ajax_return_type')){
		return_type = our_element.attr('ajax_return_type');
	} else {
		return_type = 'html';
	};
	our_parameters = {
		type: our_element.attr('ajax_method'),
		dataType: return_type,
		beforeSend: function(XMLHttpRequest) {
			if(our_element.attr('ajax_before_callback')){
				eval(our_element.attr('ajax_before_callback'));
			};
			if(our_element.attr('ajax_confirm')) {
				return confirm(our_element.attr('ajax_confirm'));
			} else {
				return true;
			};
			
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			if(jquery_error_element = our_element.attr('ajax_error_element')){
				switch( our_element.attr('ajax_error_placement') ) {
					case 'after':
						$('#' + jquery_error_element).after(XMLHttpRequest.responseText);
						break;
					case 'html':
						$('#' + jquery_error_element).html(XMLHttpRequest.responseText);
						break;
					case 'before':
						$('#' + jquery_error_element).before(XMLHttpRequest.responseText);
						break;
					case 'prepend':
						$('#' + jquery_error_element).prepend(XMLHttpRequest.responseText);
						break;
					case 'append':
						$('#' + jquery_error_element).append(XMLHttpRequest.responseText);
						break;
					default:
						$('#' + jquery_error_element).html(XMLHttpRequest.responseText);
						break;
				}
			} else {
				alert(XMLHttpRequest.responseText);
			}
			bindAjaxEvents();
		},
		success: function(data,textStatus) {
			if(jquery_success_element = our_element.attr('ajax_dynamic_success_element')) {
				jquery_success_element = eval(jquery_success_element);
			} else {
				jquery_success_element = our_element.attr('ajax_success_element');
			}
			if(jquery_success_element) {
				switch( our_element.attr('ajax_success_placement') ) {
					case 'after':
						$('#' + jquery_success_element).after(data);
						break;
					case 'html':
						$('#' + jquery_success_element).html(data);
						break;
					case 'before':
						$('#' + jquery_success_element).before(data);
						break;
					case 'prepend':
						$('#' + jquery_success_element).prepend(data);
						break;
					case 'append':
						$('#' + jquery_success_element).append(data);
						break;
					default:
						$('#' + jquery_success_element).html(data);
						break;
				}
			}; 
			if(our_element.attr('ajax_success_callback')){
				eval(our_element.attr('ajax_success_callback'));
			};
			bindAjaxEvents();
		}
	};
	switch(element_type){
		case 'form':
			our_parameters.data = our_element.serializeArray();
			our_parameters.url = our_element.attr('action');
			break;
		case 'link':
			our_parameters.url = our_element.attr('href')
			break;
	}
	$.ajax(our_parameters);
	return false;
};

$(document).ready(function() {
	bindAjaxEvents();
});

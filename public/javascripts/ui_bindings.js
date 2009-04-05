function bindTabs(){
	$(document).ready(function(){
		$("[ui_binding='tab']").click(function(e){
			switch($(e.target).attr('ui_binding')){
				case 'tab':
					real_target = $(e.target)
					break;
				default:
					real_target = $(e.target).parents("[ui_binding='tab']");
					break;
			}
			$("[ui_binding='tab']").removeClass('selected');
			real_target.addClass('selected');
			$("[ui_binding='tab_content']").hide();
			$('#' + real_target.attr('ui_tab')).show();
		});
	});
};
function bindExpanders(){
	$(document).ready(function(){
		$("[ui_binding='expander'][ui_action='expand']").click(function(e){
			$("[ui_binding='expander'][ui_state='expanded'][ui_id='" + $(e.target).attr('ui_id') + "']").show();
			$("[ui_binding='expander'][ui_state='contracted'][ui_id='" + $(e.target).attr('ui_id') + "']").hide();
		});
		$("[ui_binding='expander'][ui_action='contract']").click(function(e){
			$("[ui_binding='expander'][ui_state='expanded'][ui_id='" + $(e.target).attr('ui_id') + "']").hide();
			$("[ui_binding='expander'][ui_state='contracted'][ui_id='" + $(e.target).attr('ui_id') + "']").show();
		});
		$("[ui_binding='expander'][ui_action='contract']").click();
	});
};
function bindSortables(){
	$(document).ready(function(){
		$("[ui_binding='sortable']").sortable({
			update: function(e,ui){
				$.ajax({
					type: 'PUT', 
					url: $(this).attr('ui_url'),
					data: $(this).sortable('serialize')
				})
			},
			handle: ($(this).find("[ui_binding='sortable_drag_handle']").length == 0) ? false : "[ui_binding='sortable_drag_handle']"
		});
	});
}
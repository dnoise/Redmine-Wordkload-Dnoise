jQuery.noConflict();


	
/*
 * 
 * @options {Object} options
 * 
 *	options = { 1 => '100' , 2 => '200' }
 	options = { '100' , '200' }  
 */
	function createCss(options){
		var altura = jQuery("#today").height();
		var num = options.length
		
		for( var i = 0; i<num; i++){
			jQuery(".all_users_workload").append('<div class="month_end_' + i + '"></div>');
			jQuery(".month_end_" + i).css('height', altura);
			jQuery(".month_end_" + i).css('top', (('-' + altura) * (i + 1)) + 'px');
			jQuery(".month_end_" + i).css('background','none repeat scroll 0 0 #999999');
			jQuery(".month_end_" + i).css('left', options[i] );
			jQuery(".month_end_" + i).css('position', 'relative');
			jQuery(".month_end_" + i).css('width', '3px');
		}
		jQuery(".all_users_workload").css('max-height', altura); 
	}

	jQuery.fn.CreateCss = createCss

//MOSTRAMOS EL WIDGET DE INFORMACI�N DE TAREA EN EL EVENTO HOVER Y LO OCULTAMOS CON EL EVENTO OUT
	jQuery(".tareas").mouseover(function() {
		jQuery(".info_widget").hide();
	    jQuery(this).parent().parent().find(".info_widget").fadeIn("slow");
	});
	jQuery(".tareas").mouseleave(function() {
	    jQuery(".info_widget").fadeOut();
	});
	
//MOSTRAR EL CALENDARIO

jQuery(".campofecha").calendarioDW(jQuery);

//COMPROBAR SI UNA TAREA REMANENTE TIENE SUBTAREAS ASOCIADAS

jQuery(".user_total_hours").each(function(){
	
	if (jQuery(this).find(".user_each_hours").length == 0) {
		
		jQuery(this).css('height','50px');
	}
});

//OBTENER LA ALTURA DEL DIV USERS PARA APLICARSELO AL DIV TOTAL USER WORKLOAD

jQuery(".user").each(function(i){
	
	
	jQuery(".total_user_workload:eq("+i+")").height( jQuery(this).height());
});



//ILUMINAR TODA LA FILA DE UNA MISMA TAREA

jQuery(".user_each_hours").mouseenter(function(event) {
	jQuery(this).css('font-weight', 'bold');
	var id_tarea = jQuery(this).attr('id');
	var i = jQuery('.workload.tarea.'+id_tarea);
	i.css({'margin-bottom':'1px','padding-top' : '1px', 'border': '1px solid #ccc','background': '#ebebec' });

});

jQuery(".user_each_hours").mouseleave(function() {
	jQuery(this).css('font-weight', 'normal');
	var id_tarea = jQuery(this).attr('id');
	var i = jQuery('.workload.tarea.'+id_tarea);
	i.css( { 'margin-bottom' : '2px', 'padding-top' : '2px', 'border' : '0px solid #ccc', 'background' : 'transparent' } );
});

 	
	


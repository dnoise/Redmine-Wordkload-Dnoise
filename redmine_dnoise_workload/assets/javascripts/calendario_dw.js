jQuery.noConflict();

jQuery.fn.calendarioDW = function() {
   this.each(function(){
		//saber si estoy mostrando el calendario
		var mostrando = false;
		//variable con el calendario
		var calendario;
		//variable con los días del mes
		var capaDiasMes;
		//variable para mostrar el mes y ano que se está viendo
		var capaTextoMesAnoActual = jQuery('<div class="visualmesano"></div>');
		//iniciales de los días de la semana
		var dias = ["l", "m", "x", "j", "v", "s", "d"];
		//nombres de los meses
		var nombresMes = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
		
		//elemento input
		var elem = jQuery(this);
		//creo un enlace-botón para activar el calendario
		var boton = jQuery(".calendar_icon");
		//inserto el enlace-botón después del campo input
		
		
		//evento para clic en el botón
		boton.click(function(e){
			e.preventDefault();
			mostrarCalendario();
		});
		//evento para clic en el campo
		elem.click(function(e){
			this.blur();
			mostrarCalendario();
		});
		
		//función para mostrar el calendario
		function mostrarCalendario(){
			if(!mostrando){
				mostrando = true;
				//es que hay que mostrar el calendario
				//dias de la semana
				var capaDiasSemana = jQuery('<div class="diassemana"></div>');
				jQuery(dias).each(function(indice, valor){
					var codigoInsertar = '<span class="calendar_icon"';
					if (indice==0){
						codigoInsertar += ' class="primero"';
					}
					if (indice==6){
						codigoInsertar += ' class="domingo ultimo"';
					}
					codigoInsertar += ">" + valor + '</span>';
					
					capaDiasSemana.append(codigoInsertar);
				});
				
				//capa con los días del mes
				capaDiasMes = jQuery('<div class="diasmes"></div>');
				
				//un objeto de la clase date para calculo de fechas
				var objFecha = new Date();
				//miro si en el campo INPUT tengo alguna fecha escrita
				var textoFechaEscrita = elem.val();
				if (textoFechaEscrita!= ""){
					if (validarFechaEscrita(textoFechaEscrita)){
						var arrayFechaEscrita = textoFechaEscrita.split("/");
						//hago comprobación sobre si el año tiene dos cifras
						if(arrayFechaEscrita[2].length == 2){
							if (arrayFechaEscrita[2].charAt(0)=="0"){
								arrayFechaEscrita[2] = arrayFechaEscrita[2].substring(1);
							}
							arrayFechaEscrita[2] = parseInt(arrayFechaEscrita[2]);
							if (arrayFechaEscrita[2] < 50)
								arrayFechaEscrita[2] += 2000;
						}
						objFecha = new Date(arrayFechaEscrita[2], arrayFechaEscrita[1]-1, arrayFechaEscrita[0])
					}
				}
				
				//mes y año actuales
				var mes = objFecha.getMonth();
				var ano = objFecha.getFullYear();
				//muestro los días del mes y año dados
				muestraDiasMes(mes, ano);
				
				//control para ocultar el calendario
				var botonCerrar = jQuery('<a href="#" class="calencerrar"><span></span></a>');
				botonCerrar.click(function(e){
					e.preventDefault();
					calendario.hide("slow");
				})
				var capaCerrar = jQuery('<div class="capacerrar"></div>');
				capaCerrar.append(botonCerrar)
				
				//controles para ir al mes siguiente / anterior
				var botonMesSiguiente = jQuery('<a href="#" class="botonmessiguiente"><span></span></a>');
				botonMesSiguiente.click(function(e){
					e.preventDefault();
					mes = (mes + 1) % 12;
					if (mes==0)
						ano++;
					capaDiasMes.empty();
					muestraDiasMes(mes, ano);
				})
				var botonMesAnterior = jQuery('<a href="#" class="botonmesanterior"><span></span></a>');
				botonMesAnterior.click(function(e){
					e.preventDefault();
					mes = (mes - 1);
					if (mes==-1){
						ano--;
						mes = 11
					}	
					capaDiasMes.empty();
					muestraDiasMes(mes, ano);
				})
				
				
				//capa para mostrar el texto del mes y ano actual
				var capaTextoMesAno = jQuery('<div class="textomesano"></div>');
				var capaTextoMesAnoControl = jQuery('<div class="mesyano"></div>')
				capaTextoMesAno.append(botonMesSiguiente);
				capaTextoMesAno.append(botonMesAnterior);
				capaTextoMesAno.append(capaTextoMesAnoControl);
				capaTextoMesAnoControl.append(capaTextoMesAnoActual);
				
				
				//calendario y el borde
				calendario = jQuery('<div class="capacalendario"></div>');
				var calendarioBorde = jQuery('<div class="capacalendarioborde"></div>');
				calendario.append(calendarioBorde);
				calendarioBorde.append(capaCerrar);
				calendarioBorde.append(capaTextoMesAno);
				calendarioBorde.append(capaDiasSemana);
				calendarioBorde.append(capaDiasMes);
				
				//inserto el calendario en el documento
				jQuery(document.body).append(calendario);
				//lo posiciono con respecto al boton
				calendario.css({
					top: boton.offset().top + "px",
					left: (boton.offset().left + 20) + "px"
				})
				//muestro el calendario
				calendario.show("slow");
				
			}else{
				//es que el calendario ya se estaba mostrando...
				calendario.fadeOut("fast");
				calendario.fadeIn("fast");
				
			}
			
		}
		
		function muestraDiasMes(mes, ano){
			//console.log("muestro (mes, ano): ", mes, " ", ano)
			//muestro en la capaTextoMesAno el mes y ano que voy a dibujar
			capaTextoMesAnoActual.text(nombresMes[mes] + " " + ano);
			
			//muestro los días del mes
			var contadorDias = 1;
			
			//calculo la fecha del primer día de este mes
			var primerDia = calculaNumeroDiaSemana(1, mes, ano);
			//calculo el último día del mes
			var ultimoDiaMes = ultimoDia(mes,ano);
			
			//escribo la primera fila de la semana
			for (var i=0; i<7; i++){
				if (i < primerDia){
					//si el dia de la semana i es menor que el numero del primer dia de la semana no pongo nada en la celda
					var codigoDia = '<span class="diainvalido';
					if (i == 0)
						codigoDia += " primero";
					codigoDia += '"></span>';
				} else {
					var codigoDia = '<span';
					if (i == 0)
						codigoDia += ' class="primero"';
					if (i == 6)
						codigoDia += ' class="ultimo domingo"';
					codigoDia += '>' + contadorDias + '</span>';
					contadorDias++;
				}
				var diaActual = jQuery(codigoDia);
				capaDiasMes.append(diaActual);
			}
			
			//recorro todos los demás días hasta el final del mes
			var diaActualSemana = 1;
			while (contadorDias <= ultimoDiaMes){
				var codigoDia = '<span';
				//si estamos a principio de la semana escribo la clase primero
				if (diaActualSemana % 7 == 1)
					codigoDia += ' class="primero"';
				//si estamos al final de la semana es domingo y ultimo dia
				if (diaActualSemana % 7 == 0)
					codigoDia += ' class="domingo ultimo"';
				codigoDia += '>' + contadorDias + '</span>';
				contadorDias++;
				diaActualSemana++;
				var diaActual = jQuery(codigoDia);
				capaDiasMes.append(diaActual);
			}
			
			//compruebo que celdas me faltan por escribir vacias de la última semana del mes
			diaActualSemana--;
			if (diaActualSemana%7!=0){
				//console.log("dia actual semana ", diaActualSemana, " -- %7=", diaActualSemana%7)
				for (var i=(diaActualSemana%7)+1; i<=7; i++){
					var codigoDia = '<span class="diainvalido';
					if (i==7)
						codigoDia += ' ultimo'
					codigoDia += '"></span>';
					var diaActual = jQuery(codigoDia);
					capaDiasMes.append(diaActual);
				}
			}
			
			//crear el evento para cuando se pulsa un día de mes
			//console.log(capaDiasMes.children());
			capaDiasMes.children().click(function(e){
				var numDiaPulsado = jQuery(this).text();
				if (numDiaPulsado != ""){
					elem.val(numDiaPulsado + "/" + (mes+1) + "/" + ano);
					calendario.fadeOut();
				}
			})
		}
		//función para calcular el número de un día de la semana
		function calculaNumeroDiaSemana(dia,mes,ano){
			var objFecha = new Date(ano, mes, dia);
			var numDia = objFecha.getDay();
			if (numDia == 0) 
				numDia = 6;
			else
				numDia--;
			return numDia;
		}
		
		//función para ver si una fecha es correcta
		function checkdate ( m, d, y ) {
			// función por http://kevin.vanzonneveld.net
			// extraida de las librerías phpjs.org manual en http://www.desarrolloweb.com/manuales/manual-librerias-phpjs.html
			return m > 0 && m < 13 && y > 0 && y < 32768 && d > 0 && d <= (new Date(y, m, 0)).getDate();
		}
		
		//funcion que devuelve el último día de un mes y año dados
		function ultimoDia(mes,ano){ 
			var ultimo_dia=28; 
			while (checkdate(mes+1,ultimo_dia + 1,ano)){ 
			   ultimo_dia++; 
			} 
			return ultimo_dia; 
		} 
		
		function validarFechaEscrita(fecha){
			var arrayFecha = fecha.split("/");
			if (arrayFecha.length!=3)
				return false;
			return checkdate(arrayFecha[1], arrayFecha[0], arrayFecha[2]);
		}
   });
   return this;
};
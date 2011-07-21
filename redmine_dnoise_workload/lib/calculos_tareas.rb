class CalculosTareas
  attr_accessor :id, :finicio, :ffin, :factual, :fcierre, :hasignadas, :hdedicadas, :realizado, :priority, :duracion_tarea, :dias_restantes, :percent_dedicado, :eficacia_actual, :horas_dias, :difftiempo, :diffhoras, :hrestantes, :hdias_restantes, :start_date, :horas_dias_realizadas, :dias_trabajados, :dias_y_time_restantes,:percent_dias_dedicado, :percent_horas_dedicado, :dias_trabajados_virtuales
  @datetools = nil
  
  def initialize(id, finicio, ffin, hasignadas, hdedicadas, realizado, priority, factual = 0)
    @datetools = DateTools.new
    @id = id
    @finicio = finicio.to_date.strftime("%Y-%m-%d")
    @ffin = ffin.to_date.strftime("%Y-%m-%d")
    @factual = (factual == 0 ) ? DateTime.now.strftime("%Y-%m-%d") : factual.to_date.strftime("%Y-%m-%d")
    
    if (@finicio.to_time > @factual.to_time ) then
      @start_date = @finicio
    else
      @start_date = @factual
    end
    
    @hasignadas =  hasignadas
    @hdedicadas =  hdedicadas
    @realizado =  realizado
    #@realizado = ( @hdedicadas * 100 ) / @hasignadas
    @priority = priority
    @duracion_tarea = duracion
    @dias_restantes = restantes
    @percent_dias_dedicado = percent_dedicado
    @percent_horas_dedicado = (@hasignadas > 0 && @hdedicadas > 0 ) ? ( @hdedicadas / @hasignadas) * 100 : 0
    @diffhoras =  diff_horas
    @difftiempo = diff_tiempo
    @eficacia_actual = eficacia_actual
    @horas_dias = horas_by_day
    @hrestantes = @hasignadas - @hdedicadas
    
    @dias_trabajados =  trabajados 
    @dias_trabajados_virtuales = virtuales
    
    @dias_azules = {}
    @dias_grises = {}
    @hdias_restantes = @datetools.stimated_days(@hrestantes, @dias_restantes);
    if @dias_trabajados_virtuales > 0 then
      #@hdias_restantes = @datetools.stimated_days(@hrestantes, @dias_restantes - @dias_trabajados_virtuales + 1);
      @dias_trabajados_virtuales.times {
      |x|
       dia = @datetools.add_commercial_days(@finicio, x)
       @dias_azules[dia] = true
       
       
      }
    
      
    end
    
    
    #@horas_dias_realizadas = horas_by_day_realizadas(@hdedicadas, @dias_trabajados)
    
   # if(@dias_trabajados_virtuales > 0)then
   #   @factual = (@factual.to_time+(86400*@dias_trabajados_virtuales)).to_date.strftime("%Y-%m-%d")
   #   @start_date = @factual 
   # end
    
    @dias_y_time_restantes = TimeDaysIssues(@dias_restantes, @hdias_restantes, @start_date)
    if (@finicio.to_time < @factual.to_time ) then
      @dias_y_time_realizados =  asignar_horas_trabajadas_a_dias_trabajdos(@dias_trabajados, @hdedicadas, @horas_dias, @finicio)
      @dias_y_time_restantes = @dias_y_time_restantes.merge(@dias_y_time_realizados)  
    end
    
    
  end
  
  def virtuales 
    if (@hasignadas > 0 && @dias_restantes > 0 && @hdedicadas > 0 ) then
       return  (@hdedicadas / ( @hasignadas / @dias_restantes )).round  
    end
    return 0
  end
  
  
  
  def asignar_horas_trabajadas_a_dias_trabajdos(dias_trabajados, horas_dedicadas, horas_al_dia, finicio)
	
       dias_y_time = {}
        counter = 1
        tiempo_estimado_dedicado = (horas_al_dia > 0 && horas_dedicadas > 0 ) ? (horas_dedicadas / horas_al_dia).round : 0
       dias_trabajados.times{
        |i|
        day = @datetools.add_commercial_days(finicio, i)
        if( day.to_time >= @finicio.to_time && day.to_time <= @ffin.to_time && day.to_time < @factual.to_time  ) then
          #dias_y_time[day] = (counter <= tiempo_estimado_dedicado ) ?  9 : 10
          #dias_y_time[day] = 0
          if (counter > tiempo_estimado_dedicado && !@dias_azules.include?(day) ) then
            @dias_grises[day] = true
            
          else
            @dias_azules[day] = true
          end
          @dias_y_time_restantes[day] = 0
          counter = counter + 1
        end
          
       }
      return dias_y_time  
  end
  
  def horas_by_day
    return @datetools.stimated_days(@hasignadas, @duracion_tarea);
  end
  
  def horas_by_day_realizadas
    return @datetools.stimated_days(@hasignadas, @duracion_tarea);
  end
  
  def duracion
    return @datetools.getRealDistanceInDays(@finicio, @ffin)
  end
  
  def trabajados
    return @datetools.getRealDistanceInDays(@finicio, @factual)
  end
  
  def restantes
    return @datetools.getRealDistanceInDays(@start_date, @ffin) 
  end
  
  def percent_dedicado
    return (@duracion_tarea > 0 ) ? (( @duracion_tarea - @dias_restantes  ) * 100) / @duracion_tarea : 0
  end
  
  def diff_horas
     return @realizado - @percent_horas_dedicado
  end
  
  def diff_tiempo
     return @realizado -  @percent_dias_dedicado
  end
  
  def eficacia_actual
    return  @difftiempo + @diffhoras
  end
  
  def getTiming(perfecto = 30, entiempo = -10 , retraso = -30 )
	
    if @eficacia_actual >= perfecto
        return 1
    elsif  @eficacia_actual > entiempo  
        return 2
    elsif  @eficacia_actual > retraso 
        return 3
    else
        return 4
    end

  end
  
  
  def tengo_trabajo(dia)
	
    5.times do 
      if( dia.to_time >= @finicio.to_time && dia.to_time <= @ffin.to_time ) then
        return true
      end
      dia = dia.to_date.next
    end
    return false
  end
  
  def get_load_by_day(dia)

      if( dia.to_time >= @finicio.to_time && dia.to_time <= @ffin.to_time ) then
          if @dias_grises.length > 0  && @dias_grises.include?(dia) then
            return '_g'
          end
          if(@hdias_restantes < 0) then
            if dia.to_time < @factual.to_time && @dias_azules.length > 0  && @dias_azules.include?(dia) then
              return '_a'
            end
            return '9'
          end
          if @dias_azules.length > 0  && @dias_azules.include?(dia) then
            return '_a'
          end
         
          if(@dias_y_time_restantes.include?(dia))then
            return (dia.to_time < @factual.to_time ) ? @dias_y_time_restantes[dia].round : ( @dias_y_time_restantes[dia].round == 0 ) ? 1 : ( @dias_y_time_restantes[dia].round > 8 ) ? 8 : @dias_y_time_restantes[dia].round
          end
      end
      return 0
  end
  
  def TimeDaysIssues(num_dias, horas_al_dia, start_date)
	
       dias_y_time = {}

       num_dias.times{
        |i|
        day = @datetools.add_commercial_days(start_date, i)
        if( day.to_time >= @finicio.to_time && day.to_time <= @ffin.to_time && horas_al_dia > 0 ) then
          #dias_y_time[day] = (@dias_azules.include?(day) ) ? 0 : horas_al_dia
          dias_y_time[day] = horas_al_dia
        end
       }
      return dias_y_time
      #dias_y_time
  end
  
  
 
end

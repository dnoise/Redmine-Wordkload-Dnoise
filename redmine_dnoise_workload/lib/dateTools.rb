class DateTools

  def distance_of_time_in_days(from_time, to_time = 0, inclusive = true)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    if inclusive then
      from_time = from_time - 86400 
    end
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_days = (((to_time.to_i - from_time.to_i).abs)/86400).round
    return (from_time > to_time ) ? "-#{distance_in_days}".to_i : distance_in_days
  end
  
  def stimated_days(  hours, days )
    return hours/days
  end

  def getRealDistanceInDays(inicio, fin )
    inicio = inicio.to_date
    fin = fin.to_date
    
    days = 0
    
    if inicio.to_time == fin.to_time then
	   return 1
    end

    while (inicio.to_time <= fin.to_time ) do
      if inicio.cwday != 7 && inicio.cwday != 6 then
          days = days + 1
      end
      
      inicio = inicio.next  
    end
  return days  
end

  def add_commercial_days(fecha,days)
    fecha = fecha.to_date if fecha.respond_to?(:to_date)
    while days > 0
      fecha = fecha.next
      if fecha.cwday < 6 then
        days = days - 1
      end
      
    end
    
    return fecha.strftime("%Y-%m-%d")
    

  end
  
end

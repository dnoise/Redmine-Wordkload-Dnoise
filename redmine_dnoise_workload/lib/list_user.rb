class ListingUser
  unloadable
  attr_accessor :tools
  @tools = nil
  
  def initialize(openstatus)
      @tools = DateTools.new
      @openstatus = openstatus
  end
  
   
  def getRemanente(user_id, date_end )
    issues_opened = getIssuesOpened(user_id, date_end)
    total = 0
    issues_opened.each do |sum|
      total+= sum.estimated_hours  
    end
    return total
  end
  
  def getIssuesOpened(user_id, date_end)
    date_end = date_end.to_date.strftime("%Y-%m-%d") if date_end.respond_to?(:to_date)
    return Issue.find(:all,  :joins => :project, :conditions => [ " start_date < '#{date_end}' AND status_id = 1 AND assigned_to_id = #{user_id} AND estimated_hours IS NOT NULL AND projects.status = 1" ] )
  end
  
  def getIssuesOpenedWihtout(user_id, date_end)
    date_end = date_end.to_date.strftime("%Y-%m-%d") if date_end.respond_to?(:to_date)
    return Issue.find_all_by_status_id(@openstatus, :joins => :project, :conditions => [ "assigned_to_id = #{user_id} AND projects.status = 1 AND estimated_hours IS NULL" ] )
  end
  
  def issue_have_work(issue, day)
    if (issue.start_date.nil? || issue.due_date.nil? ) then
      return false
    end
    if(day.to_time >= issue.start_date.to_time && day.to_time <= issue.due_date.to_time )then
      return true
    end
    return false
  end
  
  def issue_is_parent(issue)
    if (issue.id.nil? || issue.root_id.nil? ) then
      return false
    end
    return (issue.id == issue.root_id && issue.parent_id.nil? && issue.children.count > 0 )
  end
  
  def getIssuesOpenedEntreFechas(user_id, start_date, date_end )
     date_end = date_end.to_date.strftime("%Y-%m-%d") if date_end.respond_to?(:to_date)
     start_date = start_date.to_date.strftime("%Y-%m-%d") if start_date.respond_to?(:to_date)
    return Issue.find_all_by_status_id( @openstatus ,:joins => :project, :conditions => [ " ( due_date <= '#{date_end}' OR start_date >= '#{start_date}') AND assigned_to_id = #{user_id} AND start_date IS NOT NULL AND due_date IS NOT NULL AND estimated_hours IS NOT NULL AND projects.status = 1" ],   :order => 'root_id asc, id asc' )
  end
  
   
   
  def sumIssuesTimes(merged)
    results = {}
    merged.each do |issue_arr|
      issue_arr.each do |key, value|

        if results.include?(key)then
            results[key] =  ( value > 0 && value.round == 0 ) ? results[key] + (value.round + 1) : results[key] + value.round
        else
            results[key] = ( value > 0 && value.round == 0 ) ? value.round + 1 :  value.round
        end
     end
   end
   return results
  end
 
  def parse_date(date)
    Date.parse date.gsub(/[{}\s]/, "").gsub(",", ".")
  end

  
  
end

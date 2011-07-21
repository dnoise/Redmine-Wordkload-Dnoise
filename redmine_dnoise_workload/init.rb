require 'redmine'
require_dependency 'dateTools'
require_dependency 'list_user'
require_dependency 'calculos_tareas'

Redmine::Plugin.register :redmine_dnoise_workload do
  name 'Redmine Dnoise Workload plugin'
  author 'Dnoise Rafael Calleja'
  description 'This is a plugin for Redmine Workload'
  version '0.0.1'
  url ''
  author_url 'http://www.d-noise.net/'
  
  menu :top_menu, :WorkLoad, { :controller => 'work_load', :action => 'show' }, :caption => 'WorkLoad'
  
  #permission :WorkLoad, {:work_load => [:index ] }, :public => true
  #menu :project_menu, :WorkLoad, { :controller => 'work_load', :action => 'index' }, :caption => 'WorkLoad'

  
end

class RedmineToolbarHookListener < Redmine::Hook::ViewListener
   def view_layouts_base_html_head(context)
     stylesheet_link_tag('style', :plugin => :redmine_dnoise_workload )
   end
end

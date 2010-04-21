# @abstract
class Dormouse::Views::Base
  
  attr_reader :manifest
  
  def initialize(manifest)
    @manifest = manifest
  end
  
  def render_in_controller(controller, *args)
    @controller = controller
    render(*args)
  end
  
  def render
    
  end
  
private
  
  def controller_eval(&block)
    @controller.instance_eval(&block)
  end
  
end